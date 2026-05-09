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
    repo = string
  }))
}

variable "hub_state_bucket_name" {
  type        = string
  description = "Name of the Sovereign Root bucket for Read-Only access[cite: 39]."
}