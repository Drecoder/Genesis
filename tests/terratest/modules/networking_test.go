package modules

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
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

			if !hasNonEmptyTerraformConfig(t, netPath) {
				t.Skip("module has no Terraform configuration yet")
			}

			terraform.InitAndValidate(t, &terraform.Options{
				TerraformDir:    netPath,
				TerraformBinary: "terraform",
			})
		})
	}
}
