# Portions Copyright (c) Microsoft Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# resource "null_resource" "git_clone" {
#   provisioner "local-exec" {
#     command = "git clone https://github.com/microsoft/virtualnodesOnAzureContainerInstances.git ${path.module}"
#   }
#   # source = "git::https://github.com/microsoft/virtualnodesOnAzureContainerInstances.git"
# }

data "azurerm_kubernetes_cluster" "credentials" {
  name                = var.aks_cluster_name
  resource_group_name = var.aks_resource_group_name

  depends_on = [
    var.aks_cluster_name
  ]
}

resource "azurerm_user_assigned_identity" "vn2_node_pool_identity" {
  name                = "${var.aks_cluster_name}-vn2-identity"
  location            = var.region_vn2
  resource_group_name = var.vn2_resource_group_name
}

resource "azurerm_role_assignment" "vn2_node_pool_mi" {
  scope                = data.azurerm_kubernetes_cluster.credentials.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.vn2_node_pool_identity.principal_id
}

provider "helm" {
  debug = true
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "virtual_node" {
  count = length(var.containers)

  name             = "${var.containers[count.index].name}-vn2"
  repository       = "https://microsoft.github.io/virtualnodesOnAzureContainerInstances"
  chart            = "virtualnode"
  create_namespace = true
  timeout          = 600
  atomic           = count.index == 0 ? false : true

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  set {
    name  = "namespace"
    value = "${var.containers[count.index].name}-vn2"
  }

  set {
    name  = "admissionControllerReplicaCount"
    value = count.index == 0 ? 1 : 0
  }

  set {
    name  = "nodeLabels"
    value = "container-image=${var.containers[count.index].name}"
  }

  set {
    name  = "aciResourceGroupName"
    value = var.vn2_resource_group_name
  }

  set {
    name  = "standbyPool.ccePolicy"
    value = var.containers[count.index].ccepolicy
  }
}
