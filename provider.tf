terraform {
  backend "azurerm" {
    resource_group_name   = "sa"
    storage_account_name  = "tstate7379"
    container_name        = "tstate"
    key                   = "terraform.tstate"
    access_key = "+eXiuZ+6vJcrWpNeQ81qW96CxLb1dJrf+GQpCj0nXeij6gz0XSdSBxkZr5vOowQZEtGnY//MnJci6WggXRfPqw=="
  }
}

# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}
