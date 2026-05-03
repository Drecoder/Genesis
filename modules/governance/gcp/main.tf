############################################
# GCP Governance Module - Entry Point
############################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# -------------------------------
# Provider Configuration
# (inherits auth via OIDC / env)
# -------------------------------
provider "google" {
  project = var.project_id
}

# -------------------------------
# Governance Constraints
# -------------------------------
module "constraints" {
  source = "./"

  org_id    = var.org_id
  folder_id = var.folder_id
}