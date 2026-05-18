variable "gcp_project_id" {
  type        = string
  description = "The targeted Google Cloud Project ID where Genesis will be bootstrapped."
}

variable "gcp_region" {
  type        = string
  description = "The default GCP region for the bootstrap architecture."
  default     = "us-central1"
}

variable "environment" {
  type        = string
  description = "The targeting environment tier, matching the tree architecture ('dev', 'staging', 'prod')."
  default     = "dev"
}