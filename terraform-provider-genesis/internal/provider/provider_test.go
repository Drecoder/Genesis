package provider

import (
	"context"
	"testing"

	"github.com/hashicorp/terraform-plugin-framework/provider"
)

// TestGenesisProviderInitialization validates that the provider registers its core namespace
// and exposes its contract endpoints cleanly without panicking.
func TestGenesisProviderInitialization(t *testing.T) {
	ctx := context.Background()

	// Instantiate our provider under test with a mock version string
	testVersion := "0.0.0-test"
	prov := New(testVersion)()

	// 1. Assert Provider Metadata Namespace Contracts
	metaReq := provider.MetadataRequest{}
	metaResp := &provider.MetadataResponse{}

	prov.Metadata(ctx, metaReq, metaResp)

	if metaResp.TypeName != "genesis" {
		t.Errorf("DDD Violation: Provider type name must be explicitly registered as 'genesis', got: %q", metaResp.TypeName)
	}

	if metaResp.Version != testVersion {
		t.Errorf("Lifecycle Defect: Expected provider version string %q, got: %q", testVersion, metaResp.Version)
	}

	// 2. Assert Provider Schema Exists (Global Config Block)
	schemaReq := provider.SchemaRequest{}
	schemaResp := &provider.SchemaResponse{}

	prov.Schema(ctx, schemaReq, schemaResp)

	if schemaResp.Schema.MarkdownDescription == "" {
		t.Error("Documentation Defect: Global Genesis provider schema must provide an explicit architectural markdown description")
	}

	// 3. Assert Sub-Domain Registration Loops
	// Verify that the Spoke Domain Resource is safely registered to the runtime array
	resources := prov.Resources(ctx)
	if len(resources) == 0 {
		t.Fatal("TDD Gap: Genesis provider has zero resources registered to its executive lifecycle loop")
	}

	// Verify that the Hub Data Source is safely registered to the runtime array
	dataSources := prov.DataSources(ctx)
	if len(dataSources) == 0 {
		t.Fatal("TDD Gap: Genesis provider has zero data sources registered to its read-only query loop")
	}
}
