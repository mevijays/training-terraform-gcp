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

variable "names" {
  type        = map(object({
    name = string
    content = string
  }))
  default     = {
    "file1" ={
        name = "file1"
        content = "this is file1 content"
    },
    "file2" = {
        name = "file2"
        content = "this is file2 content"
    }
     "file3" = {
        name = "file3" 
        content = "this is file3 content"    
        }
     }
  }

resource "local_file" "foo" {
    for_each = var.names
    content  = each.value.content
    filename = "${path.module}/${each.value.name}"
}