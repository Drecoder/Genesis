# Mock variables for the test run
variables {
  gcp_project_id = "mock-project-123"
  gcp_region     = "us-central1"
  environment    = "dev"
}

run "verify_gcp_bootstrap_outputs" {
  command = plan

  # Assert that the network name includes the environment suffix
  assert {
    condition     = output.network_name == "vpc-genesis-bootstrap-dev"
    error_message = "The GCP compute network name is missing the environment suffix."
  }
}