# ConfigMap for example notebooks
resource "kubernetes_config_map_v1" "jupyterhub_examples" {
  metadata {
    name      = "jupyterhub-examples"
    namespace = local.namespace
    labels    = local.jupyterhub_labels
  }

  data = {
    "getting_started.ipynb" = file("${path.module}/examples/getting_started.ipynb")
  }

  depends_on = [kubernetes_namespace_v1.notebooks_namespace]
}

# Service account for JupyterHub
resource "kubernetes_service_account_v1" "jupyterhub" {
  metadata {
    name      = "jupyterhub"
    namespace = local.namespace
    labels    = local.jupyterhub_labels
  }

  depends_on = [kubernetes_namespace_v1.notebooks_namespace]
}

# Role for JupyterHub to manage user pods
resource "kubernetes_role_v1" "jupyterhub" {
  metadata {
    name      = "jupyterhub"
    namespace = local.namespace
    labels    = local.jupyterhub_labels
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "persistentvolumeclaims", "secrets", "services"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["get", "list", "watch", "create", "patch"]
  }

  depends_on = [kubernetes_namespace_v1.notebooks_namespace]
}

# RoleBinding for JupyterHub
resource "kubernetes_role_binding_v1" "jupyterhub" {
  metadata {
    name      = "jupyterhub"
    namespace = local.namespace
    labels    = local.jupyterhub_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.jupyterhub.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.jupyterhub.metadata[0].name
    namespace = local.namespace
  }

  depends_on = [
    kubernetes_role_v1.jupyterhub,
    kubernetes_service_account_v1.jupyterhub
  ]
}

# JupyterHub Helm release
resource "helm_release" "jupyterhub" {
  name       = "jupyterhub"
  namespace  = local.namespace
  repository = "https://hub.jupyter.org/helm-chart"
  chart      = "jupyterhub"
  version    = "3.3.8"

  values = [
    templatefile("${path.module}/templates/jupyterhub_values.tftpl", {
      oauth_secret_name             = kubernetes_secret_v1.jupyterhub_oauth_secret.metadata[0].name
      jupyterhub_host               = local.jupyterhub_host
      keycloak_auth_url             = var.keycloak_auth_url
      keycloak_token_url            = var.keycloak_token_url
      keycloak_userinfo_url         = var.keycloak_userinfo_url
      singleuser_image_name         = split(":", var.jupyterhub_singleuser_image)[0]
      singleuser_image_tag          = length(split(":", var.jupyterhub_singleuser_image)) > 1 ? split(":", var.jupyterhub_singleuser_image)[1] : "latest"
      singleuser_cpu_limit          = replace(var.jupyterhub_singleuser_cpu_limit, "m", "") / 1000
      singleuser_memory_limit_bytes = replace(var.jupyterhub_singleuser_memory_limit, "i", "")
      storage_size_gb               = var.jupyterhub_storage_size_gb
      nessie_uri                    = var.nessie_uri
      trino_host                    = var.trino_host
      trino_port                    = var.trino_port
      hub_resources                 = var.jupyterhub_hub_resources
      proxy_resources               = var.jupyterhub_proxy_resources
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.notebooks_namespace,
    kubernetes_config_map_v1.jupyterhub_examples,
    kubernetes_role_binding_v1.jupyterhub,
    kubernetes_secret_v1.jupyterhub_oauth_secret
  ]
}
