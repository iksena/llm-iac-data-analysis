module "tags" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/tags?ref=TF/helpers/tags/vALPHA_0.0.1"

  project     = var.project
  client      = var.client
  owner       = var.owner
  environment = var.environment
  additional_tags = {
    "Purpose" = "Proof of Concept"
  }
}

module "virtual_network" {
  source = "../../../terraform-modules/azure/virtual-network"

  name           = var.name
  resource_group = var.resource_group
  address_space  = ["10.0.0.0/16"]
  dns_servers    = ["10.0.0.4", "10.0.0.5"]
  tags           = module.tags.tags
}

module "app_gw_subnet" {
  source = "../../../terraform-modules/azure/subnet"

  name           = "${var.name}-app-gw"
  resource_group = var.resource_group

  virtual_network_name = module.virtual_network.virtual_network_name
  address_prefixes     = ["10.0.3.0/24"]

  tags = module.tags.tags
}

module "apim_subnet" {
  source = "../../../terraform-modules/azure/subnet"

  name           = "${var.name}-apim"
  resource_group = var.resource_group

  virtual_network_name = module.virtual_network.virtual_network_name
  address_prefixes     = ["10.0.2.0/24"]

  tags = module.tags.tags
}

module "api" {
  source = "../../../terraform-modules/azure/api-management-service"

  name           = var.name
  resource_group = var.resource_group

  publisher_email = var.publisher_email
  publisher_name  = var.publisher_name

  sku       = var.sku
  sku_count = var.sku_count

  // API Config
  api_revision  = "1"
  api_path      = "myapi"
  api_protocols = ["https"]

  # API Definition
  api_import_content_format = var.api_import_content_format
  api_import_content_path   = file("${path.root}/${var.api_import_content_path}")

  # APP Insights
  app_insights_type = "web"

  tags = module.tags.tags
}


