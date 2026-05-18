package provider

import (
	"context"
	"testing"

	"github.com/hashicorp/terraform-plugin-framework/resource"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema"
)

func TestSpokeResourceSchema(t *testing.T) {
	ctx := context.Background()
	res := NewSpokeResource()

	req := resource.SchemaRequest{}
	resp := &resource.SchemaResponse{}

	res.Schema(ctx, req, resp)

	// 1. Invariant Assertion: Ensure Core Domain Attributes Exist
	expectedAttributes := []string{"id", "name", "cloud", "environment"}
	for _, attr := range expectedAttributes {
		if _, exists := resp.Schema.Attributes[attr]; !exists {
			t.Fatalf("DDD Violation: Missing core domain attribute %q in Spoke Resource schema", attr)
		}
	}

	// 2. TDD Validation Assertion: Guardrails Must Be Enforced (Required Fields)
	requiredFields := []string{"name", "cloud", "environment"}
	for _, field := range requiredFields {
		attr := resp.Schema.Attributes[field]
		if !attr.IsRequired() {
			t.Errorf("Security Guardrail Defect: Field %q must be Required to prevent ungoverned states", field)
		}
	}

	// 3. Immutability Assertion: Lifecycle Triggers
	// Ensuring attributes are registered as StringAttributes so they match our definitions.
	immutableFields := []string{"cloud", "environment"}
	for _, field := range immutableFields {
		attr, ok := resp.Schema.Attributes[field].(schema.StringAttribute)
		if !ok {
			t.Fatalf("Structural Defect: Field %q must be a schema.StringAttribute", field)
		}

		// Verifying plan modifiers are populated on these fields to guarantee immutability rules
		if len(attr.PlanModifiers) == 0 {
			t.Errorf("Architecture Drift: Field %q is missing plan modifiers; must enforce immutability via RequiresReplace", field)
		}
	}

	// 4. Identity Assertion: Computed Key Isolation
	idAttr, ok := resp.Schema.Attributes["id"].(schema.StringAttribute)
	if !ok || !idAttr.Computed || idAttr.Required {
		t.Error("Structural Defect: 'id' must be a strictly Computed schema.StringAttribute to allow safe internal token generation")
	}
}
