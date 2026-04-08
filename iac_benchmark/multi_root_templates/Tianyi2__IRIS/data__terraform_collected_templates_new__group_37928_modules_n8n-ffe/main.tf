locals {
  redis_hostname = var.enable_redis ? "n8n-redis-master" : ""
  use_queue      = var.enable_redis
}

resource "helm_release" "n8n" {
  name         = "n8n"
  namespace    = kubernetes_namespace.n8n.metadata[0].name
  repository   = "https://community-charts.github.io/helm-charts"
  chart        = "n8n"
  version      = var.chart_version != "" ? var.chart_version : null
  force_update = true

  cleanup_on_fail = true
  atomic          = true

  set = concat([
    # DB Config
    { name = "db.type", value = "postgresdb" },
    { name = "externalPostgresql.host", value = var.db_host },
    { name = "externalPostgresql.port", value = var.db_port },
    { name = "externalPostgresql.database", value = var.db_name },
    { name = "externalPostgresql.username", value = var.db_user },
    { name = "externalPostgresql.existingSecret", value = kubernetes_secret.n8n_external_postgres.metadata[0].name },


    # Ingress config
    { name = "ingress.enabled", value = true },
    { name = "ingress.className", value = var.ingress_class_name },
    { name = "ingress.hosts[0].host", value = var.host },
    { name = "ingress.hosts[0].paths[0].path", value = "/" },
    { name = "ingress.hosts[0].paths[0].pathType", value = "Prefix" },
    { name = "ingress.hosts[1].host", value = var.webhook_host },
    { name = "ingress.hosts[1].paths[0].path", value = "/" },
    { name = "ingress.hosts[1].paths[0].pathType", value = "Prefix" },
    { name = "ingress.annotations.kubernetes\\.io/ingress\\.allow-http", value = "'true'" },
    { name = "webhook.url", value = format("%s://%s", var.enable_tls ? "https" : "http", var.webhook_host) },

    # Main node config
    { name = "main.persistence.enabled", value = true },
    { name = "main.persistence.accessMode", value = "ReadWriteOnce" },
    { name = "main.persistence.volumeName", value = "n8n-main-data" },
    { name = "main.persistence.size", value = "5Gi" },
    { name = "main.resources.requests.cpu", value = "250m" },
    { name = "main.resources.limits.cpu", value = "500m" },
    { name = "main.resources.limits.memory", value = "512Mi" },
    { name = "main.livenessProbe.initialDelaySeconds", value = 30 },
    { name = "main.livenessProbe.timeoutSeconds", value = 5 },
    { name = "main.livenessProbe.periodSeconds", value = 15 },
    { name = "main.livenessProbe.failureThreshold", value = 6 },
    { name = "main.readinessProbe.initialDelaySeconds", value = 20 },
    { name = "main.readinessProbe.timeoutSeconds", value = 5 },
    { name = "main.readinessProbe.periodSeconds", value = 10 },
    { name = "main.readinessProbe.failureThreshold", value = 6 },


    # Worker Config (queue mode si Redis externe renseigné)
    { name = "worker.mode", value = local.use_queue ? "queue" : "regular" },
    { name = "worker.count", value = 1 },
    { name = "worker.waitMainNodeReady.enabled", value = true },
    { name = "webhook.mode", value = local.use_queue ? "queue" : "regular" },

    # Image
    { name = "image.pullPolicy", value = "Always" },

    # Webhooks config
    //{ name = "webhook.mode", value = "regular" },
    //{ name = "webhook.count", value = 1 },
    //{ name = "webhook.waitMainNodeReady.enabled", value = true },

    # Redis config
    { name = "redis.enabled", value = false },


    # Misc
    { name = "serviceMonitor.enabled", value = true },
    { name = "encryptionKey", value = var.encryption_key },
    { name = "db.logging.enabled", value = true },
    { name = "db.logging.options", value = "error" },
    { name = "db.logging.maxQueryExecutionTime", value = 5000 },
    { name = "main.extraEnvVars.N8N_BLOCK_ENV_ACCESS_IN_NODE", value = "false" },
    { name = "main.extraEnvVars.N8N_GIT_NODE_DISABLE_BARE_REPOS", value = "true" },
    { name = "main.extraEnvVars.N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE", value = true },
    { name = "main.extraEnvVars.N8N_COMMUNITY_PACKAGES_ENABLED", value = true },
    ], var.enable_tls ? [
    { name = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.entrypoints", value = "web\\,websecure" },
    { name = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares", value = "infra-redirect-https@kubernetescrd" },
    { name = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.tls", value = "'true'" },
    { name = "ingress.annotations.cert-manager\\.io/cluster-issuer", value = "letsencrypt-prod" },
    { name = "ingress.tls[0].hosts[0]", value = var.host },
    { name = "ingress.tls[0].hosts[1]", value = var.webhook_host },
    { name = "ingress.tls[0].secretName", value = var.tls_secret_name },
    ] : [], local.use_queue ? [
    { name = "externalRedis.host", value = local.redis_hostname },
    { name = "externalRedis.port", value = var.redis_port },
    { name = "externalRedis.database", value = var.redis_db },
  ] : [])

  set_sensitive = local.use_queue ? [
    {
      name  = "externalRedis.password"
      value = var.redis_password
    }
  ] : []
}

/*
    Redis externe dédié à la queue n8n (chart officiel redis)
*/
resource "helm_release" "redis" {
  count      = var.enable_redis ? 1 : 0
  name       = "n8n-redis"
  namespace  = kubernetes_namespace.n8n.metadata[0].name
  repository = "https://charts.redis.io/"
  chart      = "redis"

  cleanup_on_fail = true
  atomic          = true

  set = [
    { name = "architecture", value = "standalone" },
    { name = "auth.enabled", value = true },
    { name = "master.persistence.enabled", value = true },
    { name = "master.persistence.size", value = var.redis_storage_size },
    { name = "master.resources.requests.cpu", value = "100m" },
    { name = "master.resources.limits.cpu", value = "300m" },
    { name = "master.resources.limits.memory", value = "512Mi" }
  ]

  set_sensitive = [
    {
      name  = "auth.password"
      value = var.redis_password
    }
  ]
}
