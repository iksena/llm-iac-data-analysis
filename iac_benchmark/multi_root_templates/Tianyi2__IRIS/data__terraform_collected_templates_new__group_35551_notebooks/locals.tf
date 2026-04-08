locals {
  namespace = var.kubernetes_notebooks_namespace

  jupyterhub_labels = {
    "app.kubernetes.io/name"       = "jupyterhub"
    "app.kubernetes.io/component"  = "notebooks"
    "app.kubernetes.io/managed-by" = "terraform"
  }

  jupyterhub_host = "jupyterhub.${var.kubernetes_ingress_base_host}"
}
