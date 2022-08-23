

variable "project" {
  description = "the project for this network"
  type        = string
}

variable "vpc_name" {
  description = "network for the firewall"
  type        = string
}

variable "net_tags" {
  description = "tags for the firewall"
  type        = list(string)
}

