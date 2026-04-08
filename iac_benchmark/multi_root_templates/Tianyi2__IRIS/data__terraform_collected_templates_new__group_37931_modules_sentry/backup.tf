/*
    Velero schedule scoped to the sentry namespace.
*/
resource "kubernetes_manifest" "sentry_backup" {
  count = var.enable_velero ? 1 : 0

  manifest = {
    apiVersion = "velero.io/v1"
    kind       = "Schedule"
    metadata = {
      name      = "sentry-daily"
      namespace = var.velero_namespace
      labels = {
        "app.kubernetes.io/name"       = "velero"
        "app.kubernetes.io/component"  = "backup"
        "app.kubernetes.io/part-of"    = "sentry"
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    spec = {
      schedule = "35 2 * * *"
      template = {
        ttl                = "720h"
        includedNamespaces = [var.namespace]
      }
    }
  }
}
