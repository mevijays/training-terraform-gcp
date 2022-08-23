data "null_data_source" "grant_admin" {
  inputs = {
    command = <<EOF
kubectl get clusterrolebinding gke-tutorial-admin-binding &> /dev/null ||
kubectl create clusterrolebinding gke-tutorial-admin-binding \
--clusterrole cluster-admin --user $(gcloud config get-value account)
EOF

  }
}

data "template_file" "startup_script" {
  template = <<EOF
sudo apt-get update -y
sudo apt-get install -y kubectl
echo "gcloud container clusters get-credentials $${cluster_name} \
--zone $${zone} --project $${project}" >> /etc/profile
echo "$${admin_binding}" >> /etc/profile
EOF


  vars = {
    cluster_name = var.cluster_name
    zone         = var.zone
    region       = var.region
    project      = var.project
    admin_binding = var.grant_cluster_admin ? data.null_data_source.grant_admin.outputs["command"] : ""
  }
}


data "template_file" "rbac_yaml" {
template = file("${path.module}/templates/rbac.yaml")

  vars = {
    auditor_email = var.auditor_email
    owner_email   = var.owner_email
  }
}


resource "google_compute_instance" "instance" {
name         = var.hostname
machine_type = var.machine_type
zone         = var.zone
project      = var.project
tags         = var.tags


boot_disk {
initialize_params {
image = "debian-cloud/debian-11"
}
}


network_interface {
subnetwork = var.cluster_subnet


access_config {

}
}

// Ensure that when the bastion host is booted, it will have kubectl.
metadata_startup_script = data.template_file.startup_script.rendered

// Allow the instance to be stopped by terraform when updating configuration
allow_stopping_for_update = true

// Necessary scopes for administering kubernetes.
service_account {
email  = var.service_account_email
scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
}

// local-exec providers may run before the host has fully initialized. However, they
// are run sequentially in the order they were defined.
//
// This provider is used to block the subsequent providers until the instance
// is available.
// local-exec providers may run before the host has fully initialized. However, they
// are run sequentially in the order they were defined.
//
// This provider is used to block the subsequent providers until the instance
// is available.
provisioner "local-exec" {
  command = <<EOF
        READY=""
        for i in $(seq 1 18); do
          if gcloud compute ssh ${var.hostname} --command uptime; then
            READY="yes"
            break;
          fi
          echo "Waiting for ${var.hostname} to initialize..."
          sleep 10;
        done
        if [[ -z $READY ]]; then
          echo "${var.hostname} failed to start in time."
          echo "Please verify that the instance starts and then re-run `terraform apply`"
          exit 1
        fi
EOF

}

provisioner "local-exec" {
  command = "echo \"${data.template_file.rbac_yaml.rendered}\" > '${path.module}/manifests/rbac.yaml'"
}

provisioner "local-exec" {
  command = "gcloud compute scp --project ${var.project} --zone ${var.zone} --recurse ${path.module}/manifests ${var.hostname}:"
}
}

