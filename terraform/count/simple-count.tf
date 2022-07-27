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
