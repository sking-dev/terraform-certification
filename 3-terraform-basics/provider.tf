# Terraform code samples for Objective 3.

# The 'provider' block.

# Source: https://github.com/terraform-providers/terraform-provider-azurerm

# Configure the Microsoft Azure Provider
# NOTE: There are no required arguments for the 'feature' block.
#     : See <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#features> for the optional arguments.
provider "azurerm" {
  features {}

  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

  # subscription_id = "..."
  # client_id       = "..."
  # client_secret   = "..."
  # tenant_id       = "..."
}

################

# The 'required_providers' block.

# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.59.0"
    }
  }
}
