/*
    Velero Schedule pour le namespace n8n (sauvegarde quotidienne)
*/
resource "kubernetes_manifest" "n8n_velero_schedule" {
  count = var.enable_velero ? 1 : 0

  manifest = {
    apiVersion = "velero.io/v1"
    kind       = "Schedule"
    metadata = {
      name      = "n8n-daily"
      namespace = var.velero_namespace
      labels = {
        app = "n8n"
      }
    }
    spec = {
      schedule = "0 3 * * *"
      template = {
        ttl = "168h"
        includedNamespaces = [
          kubernetes_namespace.n8n.metadata[0].name,
        ]
      }
    }
  }
}
