# local api whitelisting
locals {
  cidr_blocks = concat(
    [
      {
        display_name : "GKE Cluster CIDR",
        cidr_block : format("%s/32", "192.168.0.10")
      },
      {
        display_name : "GKE subnet",
        cidr_block : format("%s/32", "192.168.0.12")
      },
      {
        display_name : "home access",
        cidr_block : format("%s/32", "103.149.126.200")
      },
    ]
  )
}

resource "google_container_cluster" "primary" {
  name                     = "${var.project_id}-gke"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnet.secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.subnet.secondary_ip_range.1.range_name
  }
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    gcp_filestore_csi_driver_config {
      enabled = true
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }

  }
  node_locations = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c",
  ]

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  network_policy {
    enabled = true
  }
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.10.0.0/28"
    master_global_access_config {
      enabled = true
    }
  }
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = [for cidr_block in local.cidr_blocks : {
        display_name = cidr_block.display_name
        cidr_block   = cidr_block.cidr_block
      }]
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name

      }
    }
  }

}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  autoscaling {
    min_node_count = 2
    max_node_count = 10
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  node_config {
    labels = {
      confidentiality = "C2"
      managed_by      = "vijay"
      environment     = "dev"
    }
    preemptible  = true
    machine_type = var.machineType
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    tags = ["gke-node", "${var.project_id}-gke"]
  }
}


data "google_client_config" "default" {
  depends_on = [google_container_cluster.primary]
}
data "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region
  depends_on = [
    google_container_node_pool.primary_nodes,
    google_container_cluster.primary
  ]
}