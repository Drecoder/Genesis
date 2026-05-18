package provider

import (
	"context"

	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/provider"
	"github.com/hashicorp/terraform-plugin-framework/provider/schema"
	"github.com/hashicorp/terraform-plugin-framework/resource"
)

// Ensure the implementation satisfies the expected interfaces.
var _ provider.Provider = &genesisProvider{}

type genesisProvider struct {
	version string
}

// New sets up the initial factory function for the Genesis provider engine.
func New(version string) func() provider.Provider {
	return func() provider.Provider {
		return &genesisProvider{
			version: version,
		}
	}
}

// Metadata defines the naming engine path used inside HCL configurations.
func (p *genesisProvider) Metadata(ctx context.Context, req provider.MetadataRequest, resp *provider.MetadataResponse) {
	resp.TypeName = "genesis"
	resp.Version = p.version
}

// Schema defines the global configuration block for the Genesis provider itself.
func (p *genesisProvider) Schema(ctx context.Context, req provider.SchemaRequest, resp *provider.SchemaResponse) {
	resp.Schema = schema.Schema{
		MarkdownDescription: "Genesis orchestrates multi-cloud governance and secure spoke deployment units directly via compiled binary invariants.",
		Attributes:          map[string]schema.Attribute{},
	}
}

// Configure initializes the backend clients or shared state structures (like OIDC authenticators).
func (p *genesisProvider) Configure(ctx context.Context, req provider.ConfigureRequest, resp *provider.ConfigureResponse) {
	// Global client setup will go here during the Phase 2 implementation loop.
}

// Resources registers our domain-driven resource types to the provider lifecycle.
func (p *genesisProvider) Resources(ctx context.Context) []func() resource.Resource {
	return []func() resource.Resource{
		NewSpokeResource,
	}
}

// DataSources registers read-only queries (like the secure Hub data source pattern).
func (p *genesisProvider) DataSources(ctx context.Context) []func() datasource.DataSource {
	return []func() datasource.DataSource{
		NewHubDataSource,
	}
}
