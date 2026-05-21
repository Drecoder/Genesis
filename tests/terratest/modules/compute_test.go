package modules

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMultiCloudComputeTDD(t *testing.T) {
	t.Parallel()

	computeModules := []string{
		"../../../modules/compute/aws",
		"../../../modules/compute/azure",
		"../../../modules/compute/gcp",
	}

	for _, compPath := range computeModules {
		compPath := compPath
		t.Run(compPath, func(t *testing.T) {
			t.Parallel()

			// Create minimalist mock options. Since we don't have networking output variables
			// populated yet, we pass a dummy subnet string to satisfy the variables requirement.
			opts := &terraform.Options{
				TerraformDir: compPath,
				Vars: map[string]interface{}{
					"project_id": "mock-project-id",
					"subnet_id":  "projects/mock/regions/us-central1/subnetworks/mock-subnet",
				},
			}

			// 1. Run terraform init
			terraform.Init(t, opts)

			// 2. Generate the plan string safely
			planOut, err := terraform.PlanE(t, opts)
			if err != nil {
				t.Fatalf("Terraform Plan failed hard on compilation: %v", err)
			}

			// 3. TDD Domain Invariant: Catch empty or unconfigured compute setups
			assert.NotContains(t, planOut, "No changes.", "Domain Violation: Compute module %s does not declare any virtual machine topologies!", compPath)
		})
	}
}
