package apps

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
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

			if !hasNonEmptyTerraformConfig(t, appPath) {
				t.Skip("application has no Terraform configuration yet")
			}

			terraform.InitAndValidate(t, &terraform.Options{
				TerraformDir:    appPath,
				TerraformBinary: "terraform",
			})
		})
	}
}

func hasNonEmptyTerraformConfig(t *testing.T, dir string) bool {
	t.Helper()
	entries, err := os.ReadDir(dir)
	if err != nil {
		t.Fatalf("read Terraform configuration %s: %v", dir, err)
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
