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
  default     = ["rakesh","vijay","imtiyaz","rahul"]
  description = "description"
}


locals {
  RESULTS = [for s in var.list : upper(s)]
}

output RESULTIS {
  value       = local.RESULTS
}



