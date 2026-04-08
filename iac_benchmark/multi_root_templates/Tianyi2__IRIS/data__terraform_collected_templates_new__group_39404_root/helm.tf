provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config_path)
  }
}

resource "helm_release" "helm_argo" {
  chart = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  name = "argocd"
  version = "5.51.4"
  namespace = "gitops"
  create_namespace = true

  set {
    name = "server.ingress.enabled"
    value = "true"
  }
  set {
     name = "configs.params.server\\.insecure"
     value = "true"
  }
  set {
    name = "server.ingress.hosts"
    value = join("", ["{", var.argocd_hostname, "}"])
  }
  set {
    name = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(var.argocd_admin_pass)
  }
  depends_on = [ kubectl_manifest.nginx_manifest ]
}

// adding all the declartive argocd in the argo-apps folder to the cluster
resource "kubectl_manifest" "argocd_apps" {
  provider = kubectl
  for_each = fileset(path.module,"argo-apps/*.yaml")
  yaml_body = file("${path.module}/${each.key}")
  wait = true
  depends_on = [ helm_release.helm_argo ]
}
