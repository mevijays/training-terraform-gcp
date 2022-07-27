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
    for_each = toset( ["vijay", "42"])      
    content  = "foo! content is this ${each.key}"
    filename = "${path.module}/foo${each.key}.bar"
}