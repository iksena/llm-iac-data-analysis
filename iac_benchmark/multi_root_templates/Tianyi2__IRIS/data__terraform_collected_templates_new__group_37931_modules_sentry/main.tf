locals {
  sentry_scheme = var.enable_tls ? "https" : "http"
  sentry_url    = format("%s://%s", local.sentry_scheme, var.host)
}

resource "helm_release" "sentry" {
  name         = "sentry"
  namespace    = kubernetes_namespace.sentry.metadata[0].name
  repository   = "https://sentry-kubernetes.github.io/charts"
  chart        = "sentry"
  version      = var.chart_version != "" ? var.chart_version : null
  force_update = true

  cleanup_on_fail = true
  atomic          = true

  set = concat([
    { name = "system.url", value = local.sentry_url },
    { name = "system.adminEmail", value = var.admin_email },

    { name = "ingress.enabled", value = true },
    { name = "ingress.ingressClassName", value = var.ingress_class_name },
    { name = "ingress.hostname", value = var.host },
    { name = "ingress.pathRules.traefik[0].path", value = "/api/store" },
    { name = "ingress.pathRules.traefik[0].service", value = "relay" },
    { name = "ingress.pathRules.traefik[1].path", value = "/api/{[1-9][0-9]*}/{(.*)}" },
    { name = "ingress.pathRules.traefik[1].service", value = "relay" },
    { name = "ingress.pathRules.traefik[2].path", value = "/api/0/relays/{(.*)}" },
    { name = "ingress.pathRules.traefik[2].service", value = "relay" },
    { name = "ingress.pathRules.traefik[3].path", value = "/" },
    { name = "ingress.pathRules.traefik[3].service", value = "web" },
    ], var.enable_tls ? [
    { name = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.entrypoints", value = "web,websecure" },
    { name = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.tls", value = "true" },
    { name = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares", value = "infra-redirect-https@kubernetescrd" },
    { name = "ingress.annotations.cert-manager\\.io/cluster-issuer", value = "letsencrypt-prod" },
    { name = "ingress.tls[0].secretName", value = var.tls_secret_name },
    { name = "ingress.tls[0].hosts[0]", value = var.host },
  ] : [])

  set_sensitive = [
    {
      name  = "user.password"
      value = var.admin_password
    }
  ]
}
