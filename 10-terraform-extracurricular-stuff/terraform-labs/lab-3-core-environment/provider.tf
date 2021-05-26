# https://archive.azurecitadel.com/automation/terraform/lab3/ # Build a core environment

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
