terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

resource "google_compute_instance" "app_node" {
  name         = "genesis-gcp-mvp-node"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    # Empty access_config block assigns a public ephemeral IP for MVP access
    access_config {}
  }

  metadata = {
    environment  = "mvp"
    orchestrator = "genesis"
  }
}