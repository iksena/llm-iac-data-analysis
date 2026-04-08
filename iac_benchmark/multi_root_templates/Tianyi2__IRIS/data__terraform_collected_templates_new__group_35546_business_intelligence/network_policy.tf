resource "kubernetes_network_policy_v1" "bi_namespace_policy" {
  metadata {
    name      = "agartha-bi-netpol"
    namespace = var.kubernetes_bi_namespace
  }

  spec {
    policy_types = ["Ingress"]

    pod_selector {
      match_labels = {}
    }

    dynamic "ingress" {
      for_each = var.allowed_ingress_namespaces
      content {
        from {
          namespace_selector {
            match_labels = {
              "kubernetes.io/metadata.name" = ingress.value
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace_v1.bi_namespace
  ]
}