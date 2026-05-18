package provider

import (
	"context"
	"testing"

	"github.com/hashicorp/terraform-plugin-framework/datasource"
)

// TestHubDataSourceSchema enforces the structural design requirements of the Hub Domain.
// In our DDD hierarchy, the Hub must strictly serve as a read-only context.
func TestHubDataSourceSchema(t *testing.T) {
	ctx := context.Background()
	ds := NewHubDataSource()

	// Instantiate the schema response structures from the plugin framework
	req := datasource.SchemaRequest{}
	resp := &datasource.SchemaResponse{}

	// Invoke the target Method Under Test (MUT)
	ds.Schema(ctx, req, resp)

	// -------------------------------------------------------------------------
	// 1. Structural Validation: Invariants must be documented
	// -------------------------------------------------------------------------
	if resp.Schema.MarkdownDescription == "" {
		t.Error("Documentation Defect: Hub Data Source schema must provide an explicit architectural description")
	}

	// -------------------------------------------------------------------------
	// 2. Read-Only Enforcement: Data Source Attribute Behavior Validation
	// -------------------------------------------------------------------------
	// By definition in the Terraform Plugin Framework, attributes inside a
	// Data Source must NEVER be marked as 'Required' or 'Optional' if they represent
	// state managed purely by the Hub. They must be 'Computed' to maintain a strict
	// read-only security boundary for downstream Spokes.
	for name, attr := range resp.Schema.Attributes {
		if attr.IsRequired() || attr.IsOptional() {
			t.Errorf("Security Boundary Violation: Attribute %q inside Hub Data Source must be strictly read-only (Computed). Write inputs are forbidden.", name)
		}
	}
}
