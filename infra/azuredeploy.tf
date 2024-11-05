provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  type        = string
}
variable "staticSites_name" {
  type        = string
}
variable "resource_group_name" {
  type        = string
}
variable "location" {
  type        = string
}
variable "sku_tier" {
  type        = string
}

resource "azurerm_static_web_app" "example" {
  name                = var.staticSites_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_tier            = var.sku_tier
}
