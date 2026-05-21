package values

import (
	"os"
	"testing"
	"gopkg.in/yaml.v3"
)

type GrafanaConfig struct {
	ApiVersion  int `yaml:"apiVersion"`
	Datasources []struct {
		Name     string `yaml:"name"`
		Type     string `yaml:"type"`
		Url      string `yaml:"url"`
		Editable bool   `yaml:"editable"`
	} `yaml:"datasources"`
}

func TestGrafanaDatasourcesInvariants(t *testing.T) {
	yamlFile, err := os.ReadFile("grafana-datasources.yaml")
	if err != nil {
		t.Fatalf("Failed to read config file: %v", err)
	}

	var config GrafanaConfig
	err = yaml.Unmarshal(yamlFile, &config)
	if err != nil {
		t.Fatalf("Failed to parse YAML schema: %v", err)
	}

	if config.ApiVersion != 1 {
		t.Errorf("Security Violation: apiVersion must be locked to 1, found %d", config.ApiVersion)
	}

	for _, ds := range config.Datasources {
		if ds.Editable {
			t.Errorf("Governance Failure: Datasource '%s' must have 'editable: false' to prevent manual drift inside the UI.", ds.Name)
		}
	}
}
