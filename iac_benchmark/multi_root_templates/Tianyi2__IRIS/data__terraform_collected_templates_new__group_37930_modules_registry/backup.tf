/*
    Velero schedule scoped to the registry namespace.
*/
resource "kubernetes_manifest" "registry_backup" {
  count = var.enable_velero ? 1 : 0

  manifest = {
    apiVersion = "velero.io/v1"
    kind       = "Schedule"
    metadata = {
      name      = "registry-daily"
      namespace = var.velero_namespace
      labels = {
        "app.kubernetes.io/name"       = "velero"
        "app.kubernetes.io/component"  = "backup"
        "app.kubernetes.io/part-of"    = "registry"
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    spec = {
      schedule = "15 2 * * *"
      template = {
        ttl                = "720h"
        includedNamespaces = ["registry"]
      }
    }
  }
}
