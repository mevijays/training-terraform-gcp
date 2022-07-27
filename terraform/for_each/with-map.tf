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
 for_each ={
     name = "vijay"
     age  = "42"
     value= "money"
 }
  content  = "foo! this is file ${each.value}"
  filename = "${path.module}/foo.bar${each.key}"
}