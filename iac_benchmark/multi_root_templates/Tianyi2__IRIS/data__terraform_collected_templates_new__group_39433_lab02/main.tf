# terraform {
#   # 使用远程 Cloud 后端
#   cloud {
#     organization = "DevOpsCoach"
#     workspaces {
#       name = "aks-labs"
#     }
#   }
# }
provider "azurerm" {
  features {}
  # 下面的配置允许 Terraform 以您的身份与 Azure API 进行交互，从而管理您的资源。
  # 从 CLI 的环境变量中取得这些实际的数值
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

resource "azurerm_resource_group" "example" {
  name     = "${local.prefix}-rg"
  location = local.location
}