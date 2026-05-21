package apps

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestGCPAppsTDDMatrix(t *testing.T) {
	t.Parallel()

	apps := []string{
		"../../../apps/gcp/data-refiner",
		"../../../apps/gcp/scan-engine",
		"../../../apps/gcp/vuln-detector",
	}

	for _, appPath := range apps {
		appPath := appPath
		t.Run(appPath, func(t *testing.T) {
			t.Parallel()

			opts := &terraform.Options{
				TerraformDir: appPath,
			}

			// 1. Run terraform init
			terraform.Init(t, opts)

			// 2. Run plan and inspect the text output directly for the "No changes" baseline
			planOut, err := terraform.PlanE(t, opts)
			if err != nil {
				t.Fatalf("Terraform Plan failed hard on compilation: %v", err)
			}

			// 3. TDD Domain Invariant: If it says 'No changes', the 0-value file is empty. Fail it!
			assert.NotContains(t, planOut, "No changes.", "Domain Violation: %s resulted in an empty plan. You must define application resources!", appPath)
		})
	}
}
