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

module "scaffold" {
  source = "../lab-7-scaffold-module"
  # Alternatively, could call the module from a remote location e.g. GitHub.
  #source    = "github.com/sking-dev/lab-7-scaffold-module"
}
