locals {
  resource_prefix       = lower("${var.env}-${var.location}")
  resource_short_prefix = replace(local.resource_prefix, "/[^a-zA-Z0-9]/", "")
}


resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_prefix}-rg"
  location = var.location
}

module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_address_space  = var.vnet_address_space
  vnet_name           = "${local.resource_prefix}-vnet"
  subnet_name         = "${local.resource_prefix}-subnet"
  subnet_cidr         = var.subnet_cidr

}

# module "security" {
#   source              = "./modules/security"
#   nsg_name            = "${local.resource_prefix}-nsg"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   vnet_name           = module.network.vnet_name
#   subnet_name         = module.network.subnet_name

#   # Add necessary role assignments, NSG rules, etc.
# }

module "k8s" {
  source              = "./modules/k8s"
  count               = var.deploy_k8s ? 1 : 0
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  cluster_name        = "${local.resource_prefix}-cluster"
  dns_prefix          = "${local.resource_short_prefix}-aks"
  k8s_version         = var.k8s_version
  agent_pool_name     = var.agent_pool_name
  agent_pool_vm_size  = var.agent_pool_vm_size
  agent_pool_count    = var.agent_pool_count
  network_plugin      = var.network_plugin
  tenant_id           = var.tenant_id

  # Security integrations
  #role_assignments = module.security.role_assignments
}
