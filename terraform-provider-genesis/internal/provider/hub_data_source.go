package provider

import (
	"context"

	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/datasource/schema"
)

// Ensure the implementation satisfies the expected interfaces.
var _ datasource.DataSource = &hubDataSource{}

type hubDataSource struct{}

func NewHubDataSource() datasource.DataSource {
	return &hubDataSource{}
}

func (d *hubDataSource) Metadata(ctx context.Context, req datasource.MetadataRequest, resp *datasource.MetadataResponse) {
	resp.TypeName = req.ProviderTypeName + "_hub"
}

func (d *hubDataSource) Schema(ctx context.Context, req datasource.SchemaRequest, resp *datasource.SchemaResponse) {
	resp.Schema = schema.Schema{
		MarkdownDescription: "Exposes a secure, read-only view of the Sovereign Root Hub architecture to downstream Spokes.",
		Attributes:          map[string]schema.Attribute{},
	}
}

func (d *hubDataSource) Read(ctx context.Context, req datasource.ReadRequest, resp *datasource.ReadResponse) {
	// Query logic to fetch secure hub primitives safely goes here
}
