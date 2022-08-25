variable "region" {
  type    = string
  default = "us-central1"
}

variable "project_id" {
  type    = string
  default = "gynosis-1661341380044"
}
variable "subnet_name" {
  type    = string
  default = "gke-subnet"
}
//values for network
variable "node_cidr" {
  type    = string
  default = "192.168.0.0/24"
}
variable "pod_cidr" {
  type    = string
  default = "172.16.0.0/16"
}
variable "svc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}
variable "enable_private" {
  type    = bool
  default = true
}
variable "enable_netlog" {
  type    = bool
  default = true
}
//values for dns zone
variable "dns_zone_name" {
  type    = string
  default = "gks-dns"
}
variable "dns_zone_prefix" {
  type    = string
  default = "gks"
}
//values for gke and node pool
variable "cluster_name" {
  type        = string
  default     = "gke-voda"
  description = "gke cluster name"
}
variable "gke_num_nodes" {
  type    = number
  default = 1
}
variable "min_node" {
  type    = number
  default = 1
}
variable "max_node" {
  type    = number
  default = 1
}
variable "node_size" {
  type        = string
  default     = "e2-medium"
  description = "t-shirt size of nodes in node pool"
}
variable "authorized_ipv4_cidr_block" {
  type    = list(any)
  default = ["192.168.1.0", "192.168.2.0"]
}
variable "k8s_version" {
  type        = string
  default     = "1.22."
  description = "give verion name suffix as (.) as given in default data"
}
