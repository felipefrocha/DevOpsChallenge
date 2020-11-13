
resource "azurerm_app_service_plan" "main" {
  name                = "${var.project}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true
  //  maximum_elastic_worker_count = 4
  //  per_site_scaling             = true

  sku {
    tier = var.size_app.tier
    size = var.size_app.size
    //    capacity = 4
  }
}

resource "azurerm_app_service" "main" {
  count               = length(var.image_name)
  name                = format("app-%s-%s-%s", var.project, element(var.image_name.*.name, count.index), var.environment)
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.main.id

  enabled = true

  https_only = true
  site_config {
    linux_fx_version  = format("DOCKER|%s/%s:%s", var.username, element(var.image_name.*.image, count.index),terraform.workspace)
    http2_enabled     = true
    health_check_path = element(var.image_name.*.health, count.index)
    always_on         = true
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false",
    # "DOCKER_REGISTRY_SERVER_USERNAME"     = var.username,
    # "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.password,
    # "DOCKER_REGISTRY_SERVER_URL"          = "https://docker.io"
    "WEBSITES_PORT"                       = element(var.image_name.*.port, count.index)
  }
}