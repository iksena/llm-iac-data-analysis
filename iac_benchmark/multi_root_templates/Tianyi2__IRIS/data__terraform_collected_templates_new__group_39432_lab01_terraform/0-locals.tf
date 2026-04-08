locals {
  env = "dev"
  region = "eastasia"
  resource_group_name = "rg-${local.env}-${local.region}-tfaks"
  aks_name = "aks-by-tf"
  aks_version = "1.28.3"
}