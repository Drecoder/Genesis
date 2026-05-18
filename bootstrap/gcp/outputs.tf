output "network_name" {
  value       = google_compute_network.vpc.name
  description = "The name of the bootstrapped GCP VPC network."
}

output "network_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "The URI of the bootstrapped GCP VPC network."
}