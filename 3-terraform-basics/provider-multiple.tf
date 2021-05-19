# Terraform code samples for Objective 3.

# Multiple 'provider' blocks.

# Source: https://stackoverflow.com/questions/51714639/terrafrom-deploy-to-multiple-azure-subscriptions

# See also: https://www.terraform.io/docs/language/providers/configuration.html#alias-multiple-provider-configurations

# Default provider configuration.
provider "azurerm" {
  #subscription_id = "default_subscription_id"
}

# Additional provider configuration for a different subscription.
provider "azurerm" {
  alias           = "devtest"
  subscription_id = "devtest_subscription_id"
}

# Configure resource group in default subscription.

resource "azurerm_resource_group" "rg_cert_objective_three" {
  name     = "rg-sking-dev-bananas"
  location = "North Europe"
}

# And equivalent resource group in different subscription.

resource "azurerm_resource_group" "rg_cert_objective_three_devtest" {
  provider = "azurerm.devtest"
  name     = "rg-sking-dev-bananas"
  location = "North Europe"
}
