locals {
  grafana_secret_name = var.enable_kube_prometheus_stack ? kubernetes_secret.grafana_admin[0].metadata[0].name : ""
  is_traefik          = lower(var.ingress_class_name) == "traefik"
}

resource "helm_release" "kube_prometheus_stack" {
  count            = var.enable_kube_prometheus_stack ? 1 : 0
  name             = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  cleanup_on_fail  = true
  atomic           = true
  create_namespace = false

  set = concat([
    {
      name  = "namespaceOverride"
      value = kubernetes_namespace.monitoring.metadata[0].name
    },
    {
      name  = "crds.enabled"
      value = "true"
    },
    {
      name  = "grafana.enabled"
      value = "true"
    },
    {
      name  = "alertmanager.enabled"
      value = "false"
    },
    /*
        Persist Prometheus data (otherwise emptyDir is used and data is lost on restart).
        You can adjust storageClass if needed; default will use the cluster default SC.
    */
    {
      name  = "prometheus.prometheusSpec.retention"
      value = "15d"
    },
    {
      name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
      value = "5Gi"
    },
    {
      name  = "prometheus.prometheusSpec.resources.requests.cpu"
      value = "200m"
    },
    {
      name  = "prometheus.prometheusSpec.resources.limits.cpu"
      value = "400m"
    },
    {
      name  = "prometheus.prometheusSpec.resources.limits.memory"
      value = "1Gi"
    },
    /*
        Grafana ingress: tls + HTTP->HTTPS redirect (Traefik middleware infra-redirect-https).
        Annotations quoted as strings.
    */
    {
      name  = "grafana.ingress.enabled"
      value = "true"
    },
    {
      name  = "grafana.ingress.ingressClassName"
      value = var.ingress_class_name
    },
    {
      name  = "grafana.ingress.hosts[0]"
      value = var.grafana_host
    },
    {
      name  = "grafana.ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = var.ingress_class_name
    },
    {
      name  = "grafana.ingress.annotations.kubernetes\\.io/ingress\\.allow-http"
      value = "'true'"
    },
    /*
        Admin credentials provided via existing secret
    */
    {
      name  = "grafana.admin.existingSecret"
      value = local.grafana_secret_name
    },
    /*
        Persist Grafana data (dashboards/datasources) on a PVC.
    */
    {
      name  = "grafana.persistence.enabled"
      value = "true"
    },
    {
      name  = "grafana.persistence.size"
      value = "2Gi"
    },
    {
      name  = "grafana.persistence.accessModes[0]"
      value = "ReadWriteOnce"
    },
    {
      name  = "grafana.resources.requests.cpu"
      value = "250m"
    },
    {
      name  = "grafana.resources.limits.cpu"
      value = "500m"
    },
    {
      name  = "grafana.resources.limits.memory"
      value = "512Mi"
    },
    /*
        Default Prometheus datasource (points to the in-cluster Prometheus service).
    */
    {
      name  = "grafana.additionalDataSources[0].name"
      value = "Prometheus"
    },
    {
      name  = "grafana.additionalDataSources[0].type"
      value = "prometheus"
    },
    {
      name  = "grafana.additionalDataSources[0].access"
      value = "proxy"
    },
    {
      name  = "grafana.additionalDataSources[0].url"
      value = "http://kube-prometheus-stack-prometheus.monitoring.svc:9090"
    },
    {
      name  = "grafana.additionalDataSources[0].isDefault"
      value = "true"
    },
    /*
        Kubelet ServiceMonitor: ensure cadvisor/resource metrics (PVC usage) are scraped over HTTPS.
    */
    {
      name  = "kubelet.serviceMonitor.https"
      value = "true"
    },
    {
      name  = "kubelet.serviceMonitor.cAdvisor"
      value = "true"
    },
    {
      name  = "kubelet.serviceMonitor.resource"
      value = "true"
    },
    {
      name  = "kubelet.serviceMonitor.insecureSkipVerify"
      value = "true"
    }
    ], var.enable_tls ? [
    {
      name  = "grafana.ingress.tls[0].hosts[0]"
      value = var.grafana_host
    },
    {
      name  = "grafana.ingress.tls[0].secretName"
      value = "grafana-tls"
    }
    ] : [], var.enable_tls && var.is_prod ? [
    {
      name  = "grafana.ingress.annotations.cert-manager\\.io/cluster-issuer"
      value = "letsencrypt-prod"
    }
    ] : [], local.is_traefik ? concat([
      {
        name  = "grafana.ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.entrypoints"
        value = "web\\,websecure"
      }
      ], var.enable_tls ? [
      {
        name  = "grafana.ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
        value = "infra-redirect-https@kubernetescrd"
      },
      {
        name  = "grafana.ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.tls"
        value = "'true'"
      }
  ] : []) : [])
}
