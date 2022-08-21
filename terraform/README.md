#TERRAFORM   

### Sample code
```
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "local" {
  # Configuration options
}

resource "local_file" "foo" {
    count  = 2
    content  = "foo! content is this ${count.index}"
    filename = "${path.module}/foo${count.index}.bar"
}
```
### dynamic block sample
```
resource "google_dns_managed_zone" "private-zone" {
  name        = "private-zone"
  dns_name    = "private.example.com."
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }
  visibility = "private"
  private_visibility_config {
    dynamic "networks" {
        for_each = google_compute_network.network[*].id
        content {
            network_url = google_compute_network.network[networks.key].id
        }
    }
   }
}
```
