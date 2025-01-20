resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.k8s_version

  default_node_pool {
    name       = var.agent_pool_name
    vm_size    = var.agent_pool_vm_size
    node_count = var.agent_pool_count
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.azure_rbac_enabled
    admin_group_object_ids = var.admin_group_object_ids
    tenant_id              = var.tenant_id
  }

  network_profile {
    network_plugin = var.network_plugin
  }

  tags = var.tags
}

