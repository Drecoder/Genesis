package modules

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMultiCloudNetworkingTDD(t *testing.T) {
	t.Parallel()

	netModules := []string{
		"../../../modules/networking/aws",
		"../../../modules/networking/azure",
		"../../../modules/networking/gcp",
	}

	for _, netPath := range netModules {
		netPath := netPath
		t.Run(netPath, func(t *testing.T) {
			t.Parallel()

			opts := &terraform.Options{
				TerraformDir: netPath,
			}

			// 1. Run terraform init
			terraform.Init(t, opts)

			// 2. Generate the plan string safely
			planOut, err := terraform.PlanE(t, opts)
			if err != nil {
				t.Fatalf("Terraform Plan failed hard on compilation: %v", err)
			}

			// 3. TDD Domain Invariant: Catch empty 0-byte network module configurations
			assert.NotContains(t, planOut, "No changes.", "Domain Violation: Networking module %s does not declare any network topologies!", netPath)
		})
	}
}
