# https://archive.azurecitadel.com/automation/terraform/lab1/ # Intro to workflow and HCL
# https://archive.azurecitadel.com/automation/terraform/lab2/ # Variables

# Code modified as required for later Terraform version.
# Commented-out lines and blocks left in place to illustrate evolution of code as labs progress.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.60.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# resource "azurerm_resource_group" "cert-lab" {
#   name     = "rg-sking-dev-lab1"
#   location = "North Europe"
#   tags = {
#     environment = "training"
#   }
# }

resource "azurerm_resource_group" "cert-lab" {
  #name     = "rg-sking-dev-lab2"
  name = var.rg
  #location = "North Europe"
  location = var.location
  # tags = {
  #   environment = "training"
  # }
  tags = var.tags
}

resource "random_string" "rnd" {
  #length  = 8
  length  = 4
  number  = true
  lower   = false
  upper   = false
  special = false
}

resource "azurerm_storage_account" "cert-lab" {
  #name                     = "saterraformcertlab1"
  #name                     = "saterraformcertlab2"
  #name                = "${var.tags["source"]}satfcertlab2"
  name                = "${var.tags["source"]}satfcertlab2${random_string.rnd.result}"
  resource_group_name = azurerm_resource_group.cert-lab.name
  #location                 = "northeurope"
  location                 = azurerm_resource_group.cert-lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = azurerm_resource_group.cert-lab.tags
}
