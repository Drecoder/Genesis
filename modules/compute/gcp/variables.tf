variable "project_id" {
  type        = string
  description = "The target GCP Project ID"
}

variable "region" {
  type        = string
  description = "The target GCP region"
  default     = "us-central1"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnetwork where instances will be provisioned"
}