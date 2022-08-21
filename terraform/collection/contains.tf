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
/*
variable staff {
  type        = string
  default     = "rakesh"
  description = "description"
}

locals {
  is_true = contains(["vijay","amol","imtiyaz"], var.staff)
}
*/
locals {
  is_true = contains(["vijay","amol","imtiyaz"], "vijay")
}

resource "local_file" "foo" {
    count = local.is_true ? 1 : 0
    content  = "foo! content is this ${count.index}"
    filename = "${path.module}/foo${count.index}.bar"
}