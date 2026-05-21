output "instance_self_link" {
  value       = google_compute_instance.app_node.self_link
  description = "The URI reference of the created compute node"
}

output "instance_private_ip" {
  value       = google_compute_instance.app_node.network_interface[0].network_ip
  description = "The internal IP address of the compute node"
}

output "instance_public_ip" {
  value       = google_compute_instance.app_node.network_interface[0].access_config[0].nat_ip
  description = "The external public IP address of the compute node"
}