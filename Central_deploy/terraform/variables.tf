variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "backend_tenant_id" {
  type = string
}

variable "backend_subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "vnet_address_space" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "deploy_k8s" {
  type    = bool
  default = false
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
