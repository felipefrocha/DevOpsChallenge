locals {
  environment = {
    dev = "dev"
    hml = "hml"
    prd = "prd"
  }
  profile_select = contains(keys(local.environment), terraform.workspace) ? terraform.workspace : "default"
  workspace      = local.environment[local.profile_select]

  config = {
    dev = {
      app = {
        plan_size = {
          tier = "Basic"
          size = "B2"
        }
        services = [
          {
            name   = "niboapi"
            image  = "niboapi"
            port   = 5000
            health = format("/%s", terraform.workspace)
          }
        ]
      }
    }
    prd = {
      app = {
        plan_size = {
          tier = "Standard"
          size = "S2"
        }
        services = [
          {
            name   = "niboapi"
            image  = "niboapi"
            port   = 5000
            health = format("/%s", terraform.workspace)
          }
        ]
    } }
  }
  config_app = lookup(local.config[local.workspace], "app")
  num_snet   = 0
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-npfiemg-${local.workspace}"
  location = var.region
}


module "apsrv" {
  source              = "./modules/app_service"
  docker_username     = var.docker_username
  environment         = local.workspace
  image_name          = local.config_app.services
  location            = azurerm_resource_group.rg.location
  project             = var.project
  resource_group_name = azurerm_resource_group.rg.name
  password            = var.docker_passwd
  username            = var.docker_username
  size_app            = local.config_app.plan_size
}

