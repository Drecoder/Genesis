package modules

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
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

			if !hasNonEmptyTerraformConfig(t, compPath) {
				t.Skip("module has no Terraform configuration yet")
			}

			terraform.InitAndValidate(t, &terraform.Options{
				TerraformDir:    compPath,
				TerraformBinary: "terraform",
			})
		})
	}
}

func hasNonEmptyTerraformConfig(t *testing.T, dir string) bool {
	t.Helper()
	entries, err := os.ReadDir(dir)
	if err != nil {
		t.Fatalf("read Terraform module %s: %v", dir, err)
	}
	for _, entry := range entries {
		if entry.IsDir() || filepath.Ext(entry.Name()) != ".tf" {
			continue
		}
		content, err := os.ReadFile(filepath.Join(dir, entry.Name()))
		if err != nil {
			t.Fatalf("read Terraform config %s: %v", entry.Name(), err)
		}
		if strings.TrimSpace(string(content)) != "" {
			return true
		}
	}
	return false
}
