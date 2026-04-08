resource "kubectl_manifest" "scheduled_backup" { # We want to use kubectl_manifest here as kubernetes_manifest fails to plan before crd's exist.
  for_each = var.scheduled_backups

  depends_on = [
    data.kubernetes_namespace.namespace,
    helm_release.application
  ]

  wait = true

  yaml_body = yamlencode(
    {
      apiVersion    = "velero.io/v1"
      kind          = "Schedule"
      metadata      = {
        name        = each.key
        namespace   = data.kubernetes_namespace.namespace.metadata[0].name
        labels      = merge(
          var.scheduled_backup_common_labels,
          lookup(each.value, "schedule_labels", {})
        )
        annotations = merge(
          var.scheduled_backup_common_annotations,
          lookup(each.value, "schedule_annotations", {})
        )
      }
      spec = {
        schedule                = join(" ", each.value.schedule)
        template                = {
          ttl                     = lookup(each.value, "ttl_minutes", null) != null ? "${each.value.ttl_minutes}m" : null
          includedNamespaces      = lookup(each.value, "included_namespaces", ["*"])
          excludedNamespaces      = lookup(each.value, "excluded_namespaces", [])
          includedResources       = lookup(each.value, "included_resources", ["*"])
          excludedResources       = lookup(each.value, "excluded_resources", [])
          includeClusterResources = lookup(each.value, "include_cluster_resources", null)
          storageLocation         = lookup(each.value, "storage_location", local.backup_storage_location_name)
          labelSelector           = {
            matchLabels             = lookup(each.value, "selected_labels", {})
          }
        }
      }
    }
  )
}
