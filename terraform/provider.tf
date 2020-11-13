provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = ">2.5.0"
  features {}
}
terraform {
  backend "azurerm" {}
}