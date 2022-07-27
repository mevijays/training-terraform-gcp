variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}
variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}


variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}
variable "machineType" {
  default     = "e2-medium"
  description = "sizing of compute node"
}