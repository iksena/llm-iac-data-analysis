# ── main.tf ────────────────────────────────────
terraform {
  required_version = ">= 0.11.11"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

provider "vault" {
  address = "${var.vault_addr}"
}

data "vault_generic_secret" "azure_credentials" {
  path = "secret/${var.vault_user}/azure/credentials"
}

provider "azurerm" {
  subscription_id = "${data.vault_generic_secret.azure_credentials.data["subscription_id"]}"
  tenant_id       = "${data.vault_generic_secret.azure_credentials.data["tenant_id"]}"
  client_id       = "${data.vault_generic_secret.azure_credentials.data["client_id"]}"
  client_secret   = "${data.vault_generic_secret.azure_credentials.data["client_secret"]}"
}

# Azure Resource Group
resource "azurerm_resource_group" "k8sexample" {
  name     = "${var.resource_group_name}"
  location = "${var.azure_location}"
}

# Azure Container Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "k8sexample" {
  name = "${var.vault_user}-k8sexample-cluster"
  location = "${azurerm_resource_group.k8sexample.location}"
  resource_group_name = "${azurerm_resource_group.k8sexample.name}"
  dns_prefix = "${var.dns_prefix}"
  kubernetes_version = "${var.k8s_version}"

  linux_profile {
    admin_username = "${var.admin_user}"
    ssh_key {
      key_data = "${chomp(tls_private_key.ssh_key.public_key_openssh)}"
    }
  }

  agent_pool_profile {
    name       = "${var.agent_pool_name}"
    count      =  "${var.agent_count}"
    os_type    = "${var.os_type}"
    os_disk_size_gb = "${var.os_disk_size}"
    vm_size    = "${var.vm_size}"
  }

  service_principal {
    client_id     = "${data.vault_generic_secret.azure_credentials.data["client_id"]}"
    client_secret = "${data.vault_generic_secret.azure_credentials.data["client_secret"]}"
  }

  tags {
    Environment = "${var.environment}"
  }
}


# ── variables.tf ────────────────────────────────────
variable "resource_group_name" {
  description = "Azure Resource Group Name"
}

variable "azure_location" {
  description = "Azure Location, e.g. North Europe"
  default = "East US"
}

variable "dns_prefix" {
  description = "DNS prefix for your cluster"
}

variable "k8s_version" {
  description = "Version of Kubernetes to use"
  default = "1.12.7"
}

variable "admin_user" {
  description = "Administrative username for the VMs"
  default = "azureuser"
}

variable "agent_pool_name" {
  description = "Name of the K8s agent pool"
  default = "default"
}

variable "agent_count" {
  description = "Number of agents to create"
  default = 1
}

variable "vm_size" {
  description = "Azure VM type"
  default = "Standard_D2"
}

variable "os_type" {
  description = "OS type for agents: Windows or Linux"
  default = "Linux"
}

variable "os_disk_size" {
  description = "OS disk size in GB"
  default = "30"
}

variable "environment" {
  description = "value passed to Environment tag and used in name of Vault k8s auth backend in the associated k8s-vault-config workspace"
  default = "aks-dev"
}

variable "vault_user" {
  description = "Vault userid: determines location of secrets and affects path of k8s auth backend that is created in the associated k8s-vault-config workspace"
}

variable "vault_addr" {
  description = "Address of Vault server including port that is used in the associated k8s-vault-config and k8s-services workspaces"
}


# ── outputs.tf ────────────────────────────────────
output "private_key_pem" {
  value = "${chomp(tls_private_key.ssh_key.private_key_pem)}"
}

output "k8s_id" {
  value = "${azurerm_kubernetes_cluster.k8sexample.id}"
}

output "k8s_endpoint" {
  value = "${azurerm_kubernetes_cluster.k8sexample.fqdn}"
}

output "k8s_master_auth_client_certificate" {
  value = "${azurerm_kubernetes_cluster.k8sexample.kube_config.0.client_certificate}"
}

output "k8s_master_auth_client_key" {
  value = "${azurerm_kubernetes_cluster.k8sexample.kube_config.0.client_key}"
}

output "k8s_master_auth_cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.k8sexample.kube_config.0.cluster_ca_certificate}"
}

output "environment" {
  value = "${var.environment}"
}

output "vault_user" {
  value = "${var.vault_user}"
}

output "vault_addr" {
  value = "${var.vault_addr}"
}
