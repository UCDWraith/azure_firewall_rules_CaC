# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.96.0"
    }
  }

  backend "azurerm" {
    # intentionally blank
  }
}

provider "azurerm" {
  # subscription_id = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"        # Set this to the subscription of your firewall policy in a CAF example most likely it will be your Connectivity Subscription ID.
  features {}
}
