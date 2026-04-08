resource "helm_release" "application" {
  depends_on = [
    data.kubernetes_namespace.namespace,
  ]

  name       = local.chart_install_name
  repository = local.repository
  chart      = local.chart_reference
  version    = var.chart_version

  namespace        = data.kubernetes_namespace.namespace.metadata[0].name
  create_namespace = false

  dependency_update = var.chart_dependency_update
  lint              = var.chart_linting_enabled
  recreate_pods     = var.chart_recreate_pods
  upgrade_install   = var.chart_upgrade_install
  replace           = var.chart_replace
  cleanup_on_fail   = var.chart_cleanup_on_fail

  set = [
    {
      name  = "engines.local.zfs.enabled"
      value = "true"
    },
    {
      name  = "engines.local.lvm.enabled"
      value = "true"
    },
    {
      name  = "loki.enabled"
      value = "false"
    },
    {
      name  = "engines.replicated.mayastor.enabled"
      value = "true"
    },
    {
      name  = "zfs-localpv.zfsNode.kubeletDir"
      value = var.kubelet_dir
    },
    {
      name  = "lvm-localpv.lvmNode.kubeletDir"
      value = var.kubelet_dir
    },
    {
      name  = "mayastor.csi.node.kubeletDir"
      value = var.kubelet_dir
    },
    {
      name  = "mayastor.etcd.replicaCount"
      value = tostring(1)
    },
    {
      name  = "mayastor.nats.cluster.replicas"
      value = tostring(1)
    },
    {
      name  = "nats.cluster.replicas"
      value = tostring(1)
    },
    {
      name  = "etcd.replicaCount"
      value = tostring(1)
    }
  ]
}
