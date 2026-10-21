# Milestone 1: GCP Governance Conformance

*Three controls proven against the real GCP API, built by the Builder, verified independently.*

Governance standard: `.playbook` → `00_UniversalStandards/08_Governance_Guardrails.md` (§5a
conformance tests, §6 exceptions). Baseline: `governance_baseline.v1.json`.

---

## 1. Goal

Two objectives, both required:

1. **Prove** `GOV-013` (identity isolation) and `GOV-002` (no service account keys) on GCP, including
   the exception path, and advance both to `integration_tested` for GCP in the baseline.
2. **Show the Builder can deliver a real infrastructure change** without bypassing the governance
   model it is building: plan only, deterministic gates first, human-approved merge.

Success is not three green tests. It is three independently verified results, plus evidence that
the Builder produced the infrastructure inside the rules.

---

## 2. Scope and boundary

| | In scope | Out of scope |
| :--- | :--- | :--- |
| Hierarchy | A new `governance-test` folder under org `459458052777`, one disposable project inside it | The org root, every existing project (`sovereign-vpc-488522`, `data-net-488522`, others) |
| Policies | `iam.disableServiceAccountKeyCreation` enforced **on the test folder only** | Any org-root policy |
| Identities | `governance-test` SA (Org Policy Administrator on the test folder only); `probe` SA (Owner on the test project only) | Any org-level grant beyond the bootstrap below |
| Cloud | GCP | AWS (joins once SSO exists) |

**Bootstrap (human, once):** you create the `governance-test` folder and grant the Genesis apply
identity `roles/orgpolicy.policyAdmin` and `roles/resourcemanager.projectCreator` on that folder.
Everything after that is Genesis IaC.

---

## 3. Design checks done before any privilege is granted

| Check | Result | Evidence |
| :--- | :--- | :--- |
| Can a project Owner change an inherited org policy? | **No** at the role-definition level: `roles/owner` holds only `orgpolicy.policy.get` / `policies.list`; `policy.set` and `policies.create/update/delete` are only in `roles/orgpolicy.policyAdmin` | `gcloud iam roles describe` on 2026-10-21. T1 must still prove it at runtime |
| Do native org policies support time-based exceptions? | **No.** Org policy conditions match resource tags, not time. Expiry is Genesis reconciliation: an unexpired exception renders a project-level override; once expired, the next Genesis run removes it | T3 proves removal and the post-expiry denial |
| Does a temporary exception need a broader control weakened? | **No.** The exception is a project-level override inside the test folder, applied by the governance identity; the folder policy is unchanged | T3 checks the folder policy before and after |

---

## 4. Who builds what

Independence is structural, not a promise:

| Component | Built by | Why |
| :--- | :--- | :--- |
| Terragrunt units: test project, `probe` SA, folder policy, exceptions file → project override | **Builder** (`.hcl` / `.tf` only, plan only) | The Builder's first real run |
| Conformance harness: runs T1–T3, enforces the boundary, records evidence, cleans up | **Human or overseer, not the Builder** (Python; outside the Builder's write allow-list) | The thing under test never grades itself |
| Apply | Genesis post-merge pipeline, after human approval | Agents never apply |
| Evidence review and baseline promotion | Overseer, then human approval on the baseline PR | Promotion is a reviewed change |

---

## 5. The tests

Every test performs one **denied** and one **allowed** action, so over-blocking fails too.

| Test | Identity | Denied action → expected | Allowed action → expected |
| :--- | :--- | :--- | :--- |
| **T1** identity isolation (`GOV-013`) | `probe` (project Owner) | Override `iam.disableServiceAccountKeyCreation` on the test project → `PERMISSION_DENIED` | `governance-test` SA reads and sets the same policy → succeeds |
| **T2** denied operation (`GOV-002`) | `probe` | Create a service account key → `FAILED_PRECONDITION` naming the constraint | Create a service account → succeeds |
| **T3** exception expiry (`GOV-002` exception path) | `probe`, then `governance-test` via Genesis | After the exception expires and Genesis reconciles: create a key → denied again | While the 15-minute exception is active: create a key → succeeds (then deleted) |

T3 records the reconciliation latency: time from expiry to the override being removed. That number
becomes the documented worst case for how long an expired exception can still be used.

---

## 6. Evidence record

The harness writes one record per attempt, and nothing is promoted without it:

| Field | Example |
| :--- | :--- |
| `test`, `control`, `cloud` | `T2`, `GOV-002`, `gcp` |
| `expected` / `observed` | `deny` / `deny` |
| `principal` | `probe@<test-project>.iam.gserviceaccount.com` |
| `scope` | Full resource name of the target (must be inside the test folder) |
| `request` | API method and redacted body |
| `response` | Status code, error reason, constraint name |
| `effective_policy` | `orgpolicy` effective policy on the target at the time of the call |
| `timestamp` | UTC, per attempt |
| `cleanup` | Resources deleted, and confirmation the TTL sweep found nothing left |

A control advances to `integration_tested` only when its deny **and** allowed records both match
expectations and the overseer has checked them against the effective policy.

### 6a. Evidence is telemetry, not only files

Every evidence record is also emitted through the OpenTelemetry SDK to the collector from M1b, so
the platform's proof of its own controls can be queried rather than read.

| Signal | What | Example query |
| :--- | :--- | :--- |
| **Trace** | One trace per harness run; one span per attempt (`conformance.attempt`) with `control`, `cloud`, `test`, `expected`, `observed`, `principal`, `scope` attributes | Cloud Trace: `conformance.attempt` spans where `observed != expected` |
| **Log** | The evidence record above as structured JSON, carrying `trace_id` / `span_id` | Cloud Logging: `jsonPayload.control="GOV-002" AND jsonPayload.observed="deny"` |
| **Metric** | `governance_conformance_checks_total{control,cloud,test,expected,observed,result}` (counter; `result` is `pass` when `observed == expected`, else `fail`) | `sum by (control) (governance_conformance_checks_total{result="fail"})` must be 0 |
| **Metric** | `governance_exception_expiry_latency_seconds{control,cloud}` (histogram, from T3) | p99 is the documented worst case for an expired exception |

Acceptance adds: for each test, the span, the log line, and the counter increment all exist and
agree with the evidence file. A result that exists only as a file does not count.

---

## 7. Abort and cleanup (enforced by the harness, not the Builder)

- Before every call, the harness resolves the target's ancestry and **aborts the run** if it is not
  inside the `governance-test` folder.
- The harness only acts on resources carrying `du_class=ephemeral` and a TTL label, and deletes only
  resources it created in the same run.
- Expected outcomes and abort conditions are written before the run, in this document, and the
  harness reads them from it, not from the Builder's output.
- If cleanup fails, the run is marked failed and the resource IDs are reported; nothing is
  promoted.

---

## 8. Builder acceptance criteria

The infrastructure half passes when:

- Each Builder task ends `verified` (`terragrunt validate` + `plan` succeed), within its attempt cap
  and token budget.
- The PR passes the deterministic gates (`terragrunt hcl fmt`, `tflint`, `checkov`, `SEC-*`) and
  the no-destroy check, with no gate overridden.
- The Reviewer's findings are resolved within 3 rounds.
- The plan touches nothing outside the test folder, verified by the overseer from the plan JSON.
- Nothing is applied by an agent.

Per task, record the difficulty score, ladder rung, model, attempts, tokens, cost, and whether the
overseer had to send it back. That is the first data for calibrating the ladder thresholds. The
Builder and Reviewer already emit these as OpenTelemetry spans (GenAI conventions:
`gen_ai.request.model`, `gen_ai.usage.input_tokens`, `gen_ai.usage.output_tokens`); with M1b's
collector they land in Cloud Trace and Monitoring instead of only the local console.

---

## 9. M1b: telemetry pipeline (the Builder's first task)

M1's evidence needs somewhere to go, and the 2026-10-21 incidents (sovereign-vpc-gcp
`docs/incidents/`) were all found by a person looking because the platform has no telemetry on its
own CI. M1b is smaller than M1, so it is the Builder's **first** live task, and M1's tests run
after it.

| Piece | Scope | Done when |
| :--- | :--- | :--- |
| OpenTelemetry collector | One small VM or Cloud Run service in the platform subnet (`10.10.16.0/20`), OTLP in, exporting to Cloud Trace, Monitoring (Managed Prometheus), and Logging; only the runner and platform subnets may reach it; it authenticates to GCP with its own service account | A test span, log, and metric sent from a runner arrive in all three backends |
| Agent wiring | `OTEL_EXPORTER_OTLP_ENDPOINT` points at the collector for the Builder, Reviewer, and harness | A Builder run's GenAI spans are visible in Cloud Trace |
| CI telemetry (from the incident preventive actions) | `ci_runner_bootstrap_failures_total` (log-based, from the runner's `bootstrap failed` line), `ci_job_queue_age_seconds` (from the GitHub API on a schedule) | Alerts: any bootstrap failure; an apply job queued more than 15 minutes |

The collector is platform infrastructure, so its Terragrunt unit lives in sovereign-vpc-gcp (next
to `live/dev/gcp/inference`), not in Genesis; this milestone only depends on it. Collector endpoints
and credentials come from configuration only (`OTEL_EXPORTER_OTLP_ENDPOINT`,
`OTEL_EXPORTER_OTLP_HEADERS`), never code, per the playbook's Observability Rules.

---

## 10. Dependency and reassessment

The Builder runs on Opus 5.5 through Bedrock with SSO credentials (AWS Organization plus IAM
Identity Center, permission set `BuilderBedrockInvoke`). If SSO is not working by **2026-10-28**,
reassess who builds this milestone rather than letting governance verification stall.
