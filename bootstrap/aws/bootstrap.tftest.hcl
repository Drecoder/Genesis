# Mock variables for the test run
variables {
  aws_region  = "us-east-1"
  environment = "test-env"
}

# Run block to execute a plan and assert structural integrity
run "verify_aws_bootstrap_outputs" {
  command = plan

  # Assert that the environment output matches our input variable
  assert {
    condition     = output.environment_tier == "test-env"
    error_message = "The environment_tier output did not match the configured input variable."
  }

  # Assert against a known configuration value instead of an asset ID
  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "The bootstrap VPC CIDR block configuration is incorrect."
  }
}