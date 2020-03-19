provider "azurerm" {
    features {}
}

locals {
    app_name = "temp"
    resource_group_name = "rg-${local.app_name}-temp-001"
    service_plan_name = "sp-${local.app_name}"
    app_service_name = "azapp-${local.app_name}"
    count = 10
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location = "East Us"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  count = local.count
  name                = "${local.service_plan_name}-${count.index}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}


resource "azurerm_app_service" "app_service" {
  count = local.count
  name                = "${local.app_service_name}-${count.index}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan[count.index].id
}