/*
 * Copyright (C) 2019 Risk Focus, Inc. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

resource "kubernetes_service_account" "eks_admin" {
  metadata {
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "eks_admin_cluster_admin" {
  depends_on = [
    kubernetes_service_account.eks_admin,
  ]

  metadata {
    name = "cluster-admin-kube-system-eks-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

resource "null_resource" "gp2" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl patch --kubeconfig ${var.config_output_path}/kubeconfig_${var.project_prefix}-eks-cluster storageclass gp2 -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
EOT

  }
}
