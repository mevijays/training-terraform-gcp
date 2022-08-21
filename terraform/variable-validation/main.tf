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

variable list {
  type        = list
  description = "description"
    validation {
    condition     = length(var.list) <= 2
    error_message = "Error.. name list can accept only 2 names"
  }
}

resource "local_file" "foo" {
    for_each = toset(var.list)
    content  = "foo! content is this ${each.key}"
    filename = "${path.module}/foo${each.key}.bar"
}
~  