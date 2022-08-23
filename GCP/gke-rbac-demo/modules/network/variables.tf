

variable "project" {
  description = "the project for this network"
  type        = string
}

variable "ip_range" {
  type    = string
  default = "10.0.96.0/22"
}

variable "region" {
  type = string
}

variable "secondary_ip_range" {
  type    = string
  default = "10.0.92.0/22"
}

variable "vpc_name" {
  type    = string
  default = "kube-net"
}

