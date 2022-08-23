
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

variable "users" {
  type        = map(object({
    name = string
    department = string
    is_admin = bool
  }))
  default     = {
    "user1" ={
        name = "vijay"
        department = "DevOps"
        is_admin = true
    },
    "user2" = {
        name = "imtiyaz"
        department = "consulting"
        is_admin = true
    }
     "user3" = {
        name = "naveen" 
        department = "engineering"    
        is_admin = false
        }
     }
  }

locals {
  admin_users = {
    for name, user in var.users : name => user
    if user.is_admin
  }
  regular_users = {
    for name, user in var.users : name => user
    if !user.is_admin
  }
}
output admins {
  value       = [for k,v in local.admin_users : v.name]
}
output nonadmins {
  value       = [for k,v in local.regular_users : v.name]
}

/*
variable "avengers" {
  type        = map(string)
  default     = {
    tony      = "ironman"
    bruce     = "Hulk"
    thor      = "GOD of thunder"
  }
}
output "bios" {
  //value = [for name, role in var.avengers : "${name} is the ${role}"]
  value = [for name, role in var.avengers : "${name}"  if role != "Hulk"]
}
*/