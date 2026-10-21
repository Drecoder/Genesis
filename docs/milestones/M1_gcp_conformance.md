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
overseer had to send it back. That is the first data for calibrating the ladder thresholds.

---

## 9. Dependency and reassessment

The Builder runs on Opus 5.5 through Bedrock with SSO credentials (AWS Organization plus IAM
Identity Center, permission set `BuilderBedrockInvoke`). If SSO is not working by **2026-10-28**,
reassess who builds this milestone rather than letting governance verification stall.
