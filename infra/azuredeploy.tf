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
  default     = "azure-static-web-app"
}
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}
variable "location" {
  description = "The location for the resource group"
  type        = string
}
variable "sku_tier" {
  description = "The SKU tier for the static web app"
  type        = string
}

resource "azurerm_static_web_app" "example" {
  name                = var.staticSites_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_tier            = var.sku_tier
}
