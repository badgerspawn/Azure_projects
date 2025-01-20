# modules/k8s/variables.tf

variable "tenant_id" {
  type = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location for the cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "k8s_version" {
  type        = string
  description = "The Kubernetes version to use for the AKS cluster."
  default     = "1.31.3"
}

variable "agent_pool_name" {
  type        = string
  description = "A name for the node pool."
  default     = "nodepool1"
}

variable "agent_pool_vm_size" {
  type        = string
  description = "The VM size for the node pool."
  default     = "Standard_B2s"
}

variable "agent_pool_count" {
  type        = number
  description = "The number of nodes in the node pool."
  default     = 1
}

variable "network_plugin" {
  description = "Network plugin to use for the AKS cluster"
  type        = string
  default     = "azure"
}

variable "azure_rbac_enabled" {
  type    = bool
  default = false
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "List of Azure Active Directory group object IDs to use for admin access"
  default     = ["455c4440-b0ef-4809-bc18-2c2adaf9cdde"]
}

variable "tags" {
  description = "Tags to apply to the AKS cluster"
  type        = map(string)
  default     = {}
}


