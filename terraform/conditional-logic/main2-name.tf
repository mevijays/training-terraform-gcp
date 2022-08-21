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
  default     = ["vijay","ram"]
  description = "description"
    validation {
    condition     = length(var.list) <= 2
    error_message = "Err: name is not valid."
  }
}

locals {
   is_ok = contains(var.list , "ram" )
}
resource "local_file" "foo" {
    for_each = {
    for k, v in var.list : k => v if local.is_ok
   }
    /*
     { o="vijay",1="ram" }
    */
    content  = "foo! content is this ${each.value}"
    filename = "${path.module}/foo${each.value}.bar"
}
