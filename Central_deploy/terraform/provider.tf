terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.16"
    }
  }

  backend "azurerm" {
    resource_group_name  = "infrastructure"
    storage_account_name = "filingcabinet"
    container_name       = "terraform-state"
    key                  = ""
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}