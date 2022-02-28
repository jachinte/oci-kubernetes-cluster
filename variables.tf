variable "availablity_domain_name" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "private_key_oci" {}
variable "public_key_oci" {}

variable "node_ocpus" {
  default = 2
}

variable "node_memory_in_gbs" {
  default = 3
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "cluster_options_kubernetes_network_config_pods_cidr" {
  default = "10.1.0.0/16"
}

variable "cluster_options_kubernetes_network_config_services_cidr" {
  default = "10.2.0.0/16"
}

variable "FoggyKitchenClusterSubnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "FoggyKitchenNodePoolSubnet-CIDR" {
  default = "10.0.3.0/24"
}

variable "node_pool_quantity_per_subnet" {
  default = 2
}

variable "kubernetes_version" {
  default = "v1.21.5"
}

variable "node_pool_size" {
  default = 3
}

variable "Shape" {
  default = "VM.Standard.E3.Flex"
}

variable "ClusterName" {
  default = "PFL-OKE-cluster"
}
