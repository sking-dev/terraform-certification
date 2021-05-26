resource "azurerm_resource_group" "webapps" {
  name     = "rg-sking-dev-lab4-webapps"
  location = var.location
  tags     = var.tags
}

################

resource "random_string" "webapprnd" {
  length  = 8
  lower   = true
  number  = true
  upper   = false
  special = false
}

################

resource "azurerm_app_service_plan" "free" {
  count = length(var.webapplocations)
  #name                = "plan-free-${var.location}"
  name = "plan-free-${var.webapplocations[count.index]}"
  #location            = var.location
  location            = var.webapplocations[count.index]
  resource_group_name = azurerm_resource_group.webapps.name
  tags                = azurerm_resource_group.webapps.tags

  kind     = "Linux"
  reserved = true
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "citadel" {
  count = length(var.webapplocations)
  #name                = "webapp-${random_string.webapprnd.result}-${var.location}"
  name = "webapp-${random_string.webapprnd.result}-${var.webapplocations[count.index]}"
  #location            = var.location
  location            = var.webapplocations[count.index]
  resource_group_name = azurerm_resource_group.webapps.name
  tags                = azurerm_resource_group.webapps.tags

  #app_service_plan_id = azurerm_app_service_plan.free.id
  app_service_plan_id = element(azurerm_app_service_plan.free.*.id, count.index)
}

################

output "webapp_ids" {
  description = "The IDs of the deployed Web Apps."
  value       = azurerm_app_service.citadel.*.id
}
