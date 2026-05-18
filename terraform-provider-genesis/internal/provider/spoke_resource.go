package provider

import (
	"context"

	"github.com/Drecoder/terraform-provider-genesis/internal/genesis"
	"github.com/hashicorp/terraform-plugin-framework/resource"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema/planmodifier"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema/stringplanmodifier"
	"github.com/hashicorp/terraform-plugin-framework/types"
)

// spokeResourceModel maps the resource schema direct to typed Go memories.
// This matches the HCL parameters and translates cleanly to the genesis.SpokePayload.
type spokeResourceModel struct {
	ID          types.String `tfsdk:"id"`
	Name        types.String `tfsdk:"name"`
	Cloud       types.String `tfsdk:"cloud"`
	Environment types.String `tfsdk:"environment"`
}

// ToPayload converts our Terraform state/plan model into a pure Domain Service contract.
func (m *spokeResourceModel) ToPayload() genesis.SpokePayload {
	return genesis.SpokePayload{
		ID:          m.ID.ValueString(),
		Name:        m.Name.ValueString(),
		Cloud:       m.Cloud.ValueString(),
		Environment: m.Environment.ValueString(),
	}
}

// FromPayload maps a pure Domain Service response back into the Terraform state tracking model.
func (m *spokeResourceModel) FromPayload(payload *genesis.SpokePayload) {
	m.ID = types.StringValue(payload.ID)
	m.Name = types.StringValue(payload.Name)
	m.Cloud = types.StringValue(payload.Cloud)
	m.Environment = types.StringValue(payload.Environment)
}

// Ensure the implementation satisfies the expected interfaces.
var _ resource.Resource = &spokeResource{}

type spokeResource struct{}

func NewSpokeResource() resource.Resource {
	return &spokeResource{}
}

func (r *spokeResource) Metadata(ctx context.Context, req resource.MetadataRequest, resp *resource.MetadataResponse) {
	resp.TypeName = req.ProviderTypeName + "_spoke"
}

func (r *spokeResource) Schema(ctx context.Context, req resource.SchemaRequest, resp *resource.SchemaResponse) {
	resp.Schema = schema.Schema{
		MarkdownDescription: "Manages a secure, governance-isolated deployment unit (Spoke) across federated cloud providers.",
		Attributes: map[string]schema.Attribute{
			"id": schema.StringAttribute{
				Computed:            true,
				MarkdownDescription: "The absolute, compiled unique identifier of the deployment unit.",
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.UseStateForUnknown(),
				},
			},
			"name": schema.StringAttribute{
				Required:            true,
				MarkdownDescription: "The unique name of the target workload or application (e.g., 'cre-api', 'insurance-api').",
			},
			"cloud": schema.StringAttribute{
				Required:            true,
				MarkdownDescription: "The cloud platform hosting this spoke resource. Must be explicitly one of: 'aws', 'azure', or 'gcp'.",
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
			"environment": schema.StringAttribute{
				Required:            true,
				MarkdownDescription: "The targeting environment tier, matching the tree architecture ('dev', 'staging', 'prod').",
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
		},
	}
}

func (r *spokeResource) Configure(ctx context.Context, req resource.ConfigureRequest, resp *resource.ConfigureResponse) {
}

func (r *spokeResource) Create(ctx context.Context, req resource.CreateRequest, resp *resource.CreateResponse) {
}

func (r *spokeResource) Read(ctx context.Context, req resource.ReadRequest, resp *resource.ReadResponse) {
}

func (r *spokeResource) Update(ctx context.Context, req resource.UpdateRequest, resp *resource.UpdateResponse) {
}

func (r *spokeResource) Delete(ctx context.Context, req resource.DeleteRequest, resp *resource.DeleteResponse) {
}
