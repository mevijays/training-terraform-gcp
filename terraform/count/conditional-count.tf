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

# define a variable here as bool

variable is_create {
  type        = bool
  default     = "true"
  description = "if true then will create file"
}

resource "local_file" "foo" {
    count  = var.is_create ? 1 : 0
    content  = "if you see this content, a file exists!"
    filename = "${path.module}/foo.bar"
}