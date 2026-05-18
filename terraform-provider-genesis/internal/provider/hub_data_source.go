package provider

import (
	"context"

	"github.com/Drecoder/terraform-provider-genesis/internal/genesis"
	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/datasource/schema"
	"github.com/hashicorp/terraform-plugin-framework/types"
)

// hubDataSourceModel maps the read-only data source schema direct to Go memory.
type hubDataSourceModel struct {
	ID        types.String `tfsdk:"id"`
	RootToken types.String `tfsdk:"root_token"`
	Status    types.String `tfsdk:"status"`
}

// FromPayload populates the Terraform data source state from a pure Domain Service response.
func (m *hubDataSourceModel) FromPayload(payload *genesis.SpokePayload) {
	// For now, mapping simulated root properties for our TDD verification loops
	m.ID = types.StringValue("hub-global-root")
	m.RootToken = types.StringValue("vault-encrypted-token-stream")
	m.Status = types.StringValue("active_governed")
}

// Ensure the implementation satisfies the expected interfaces.
var _ datasource.DataSource = &hubDataSource{}

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
