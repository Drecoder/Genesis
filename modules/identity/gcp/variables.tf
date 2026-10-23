###########################################################
# GCP Identity Layer - Input Contract
###########################################################

variable "project_id" {
  type        = string
  description = "The GCP Project ID where Identity resources reside."
}

variable "deployment_units" {
  description = "Map of Delivery Units for isolation."
  type = map(object({
    repo         = string
    state_prefix = string
  }))

  validation {
    condition = alltrue([
      for du in values(var.deployment_units) :
      du.repo != "" && du.state_prefix != "" &&
      du.state_prefix == trim(du.state_prefix, "/") &&
      !can(regex("(^|/)\\.\\.(/|$)", du.state_prefix))
    ])
    error_message = "Each deployment unit must have a repository and a normalized, non-empty state_prefix."
  }
}

variable "hub_state_bucket_name" {
  type        = string
  description = "Name of the hub bucket whose state objects are granted by deployment-unit prefix."
}