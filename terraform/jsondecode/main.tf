terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    random = {
      source = "hashicorp/random"
      version = "3.3.2"
    }
  }
}

provider "local" {
  # Configuration options
}


locals {
    my_list = [
        "foo",
        "bar",
        "baz",
    ]

    json_list = jsonencode(local.my_list)
}

resource "local_file" "list" {
  content = local.json_list
  filename = "local.json"
}