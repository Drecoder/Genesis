package genesis

import (
	"context"
	"testing"
)

// TestNewClientValidation asserts that the initialization logic enforces its parameter boundaries.
func TestNewClientValidation(t *testing.T) {
	// 1. Invariant: Empty Host URL must fail explicitly
	_, err := NewClient("", "mock-auth-token")
	if err == nil {
		t.Error("TDD Guardrail Failure: Expected an error when initializing a client with an empty HostURL, got nil")
	}

	// 2. Happy Path: Valid settings must produce an initialized structure
	client, err := NewClient("https://api.genesis.local", "mock-auth-token")
	if err != nil {
		t.Fatalf("Initialization Defect: Expected successful client generation, got error: %v", err)
	}

	if client.HostURL != "https://api.genesis.local" {
		t.Errorf("State Mismatch: Expected HostURL 'https://api.genesis.local', got: %q", client.HostURL)
	}

	if client.HTTPClient == nil {
		t.Error("Structural Defect: Client initialization failed to instantiate internal HTTPClient pool wrapper")
	}
}

// TestCreateSpokeInvariants validates that the data translation models enforce zero-trust
// payload requirements before shooting requests into network IO boundaries.
func TestCreateSpokeInvariants(t *testing.T) {
	ctx := context.Background()
	client, _ := NewClient("https://api.genesis.local", "mock-auth-token")

	// 1. Invariant Assertion: Missing mandatory fields must trigger validation faults
	invalidPayload := SpokePayload{
		Name: "isolated-cre-api",
		// Missing Cloud and Environment designations
	}

	_, err := client.CreateSpoke(ctx, invalidPayload)
	if err == nil {
		t.Error("DDD Validation Failure: Expected an invariant error when payload is missing 'cloud' and 'environment' markers, got nil")
	}

	// 2. Happy Path: Complete payloads must cleanly return an generated identity wrapper
	validPayload := SpokePayload{
		Name:        "market-signals",
		Cloud:       "azure",
		Environment: "staging",
	}

	result, err := client.CreateSpoke(ctx, validPayload)
	if err != nil {
		t.Fatalf("Pipeline Failure: Expected clean payload tracking, got error: %v", err)
	}

	expectedID := "spk-azure-staging"
	if result.ID != expectedID {
		t.Errorf("Identity Generation Defect: Expected ID assignment of %q, got: %q", expectedID, result.ID)
	}
}

// TestGetSpokeAssertion validates the internal lookup and mock simulation engine.
func TestGetSpokeAssertion(t *testing.T) {
	ctx := context.Background()
	client, _ := NewClient("https://api.genesis.local", "mock-auth-token")

	// 1. Verification of missing unique lookup key exception
	_, err := client.GetSpoke(ctx, "")
	if err == nil {
		t.Error("Security Constraint Violation: Expected lookup request to fail when spokeID token is entirely blank")
	}

	// 2. Verification of retrieved domain contract alignment
	payload, err := client.GetSpoke(ctx, "spk-aws-dev")
	if err != nil {
		t.Fatalf("Lookup Failure: Expected successful retrieval loop simulation, got: %v", err)
	}

	if payload.ID != "spk-aws-dev" {
		t.Errorf("Domain Property Corruption: Expected payload contract ID to match query key 'spk-aws-dev', got: %q", payload.ID)
	}
}
