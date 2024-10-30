provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  description = "The subscription ID"
  type        = string
}

variable "staticSites_name" {
  type        = string
  default     = "azure-static-web-apps-001"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

resource "azurerm_static_web_app" "example" {
  name                = var.staticSites_name
  location            = "East Asia"
  resource_group_name = var.resource_group_name
  sku_tier            = "Free"
}
