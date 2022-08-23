
output "network_self_link" {
  value = google_compute_network.gke-network.self_link
}

// subnet_self_link can be used to reference the network created by this module
output "subnet_self_link" {
  value = google_compute_subnetwork.cluster-subnet.self_link
}

