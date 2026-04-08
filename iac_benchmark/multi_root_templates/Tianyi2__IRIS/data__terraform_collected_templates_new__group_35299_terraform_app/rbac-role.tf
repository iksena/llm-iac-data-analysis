resource "kubernetes_cluster_role" "alb_ingress_controller" {
  metadata {
    name = "alb-ingress-controller"

    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  rule {
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
  }
}

resource "kubernetes_cluster_role_binding" "alb_ingress_controller" {
  metadata {
    name = "alb-ingress-controller"

    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "alb-ingress-controller"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "alb-ingress-controller"
  }
}

resource "kubernetes_service_account" "alb_ingress_controller" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }
}

