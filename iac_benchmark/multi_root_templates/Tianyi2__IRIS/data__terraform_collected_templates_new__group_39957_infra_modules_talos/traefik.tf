locals {
  traefik = {
    username      = "admin"
    password      = random_password.traefik_dashboard.result
    dashboard_dns = "traefik.${var.base_domain}"

    repository = "https://traefik.github.io/charts/"
    chart      = "traefik"
    version    = "34.1.0"
    namespace  = "traefik"
  }
  traefik_crds = {
    repository = "https://traefik.github.io/charts/"
    chart      = "traefik-crds"
    version    = "1.2.0"
  }
}

resource "random_password" "traefik_dashboard" {
  length  = 16
  special = true
}

data "helm_template" "traefik_crds" {
  name       = "traefik-crds"
  repository = local.traefik_crds.repository
  chart      = local.traefik_crds.chart
  version    = local.traefik_crds.version

  namespace    = local.traefik.namespace
  kube_version = var.k8s_version

}


data "helm_template" "traefik" {
  name       = "traefik"
  repository = local.traefik.repository
  chart      = local.traefik.chart
  version    = local.traefik.version

  namespace    = local.traefik.namespace
  kube_version = var.k8s_version

  values = [
    templatefile("${path.module}/templates/traefik.yaml.tmpl", {
      lb_ip         = var.k8s_lb_ip,
      dashboard_dns = local.traefik.dashboard_dns,
      username      = local.traefik.username,
      password      = local.traefik.password
    })
  ]
}
