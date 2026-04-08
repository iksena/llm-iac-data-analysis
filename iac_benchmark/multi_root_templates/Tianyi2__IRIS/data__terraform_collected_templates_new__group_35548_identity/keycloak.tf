resource "kubernetes_secret_v1" "keycloak_database_password" {
  metadata {
    name      = "keycloak-database-password"
    namespace = local.namespace
  }

  data = {
    "password"          = var.keycloak_postgres_password
    "postgres-password" = var.keycloak_postgres_password
  }

  depends_on = [
    kubernetes_namespace_v1.identity_namespace
  ]
}

resource "kubernetes_secret_v1" "keycloak_admin_password" {
  metadata {
    name      = "keycloak-admin-password"
    namespace = local.namespace
  }

  data = {
    "admin-password" = var.keycloak_admin_password
  }

  depends_on = [
    kubernetes_namespace_v1.identity_namespace
  ]
}

resource "helm_release" "keycloak" {
  namespace  = local.namespace
  name       = "keycloak"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = "25.2.0"

  timeout = 600

  set = [
    {
      name  = "global.security.allowInsecureImages"
      value = "true"
    },
    {
      name  = "auth.adminUser"
      value = "admin"
    },
    {
      name  = "auth.existingSecret"
      value = kubernetes_secret_v1.keycloak_admin_password.metadata[0].name
    },
    {
      name  = "auth.passwordSecretKey"
      value = "admin-password"
    },
    {
      name  = "auth.createAdminUser"
      value = "true"
    },
    {
      name  = "replicaCount"
      value = tostring(var.keycloak_replicas)
    },
    {
      name  = "service.ports.http"
      value = "80"
    },
    {
      name  = "ingress.enabled"
      value = "false"
    },
    {
      name  = "ingress.hostname"
      value = local.keycloak_host
    },
    {
      name  = "ingress.ingressClassName"
      value = "nginx"
    },
    {
      name  = "ingress.pathType"
      value = "Prefix"
    },
    {
      name  = "ingress.path"
      value = "/"
    },
    {
      name  = "ingress.tls"
      value = "false"
    },
    {
      name  = "proxy"
      value = "edge"
    },
    {
      name  = "image.pullPolicy"
      value = "IfNotPresent"
    },
    {
      name  = "image.registry"
      value = "docker.io"
    },
    {
      name  = "image.repository"
      value = "bitnamilegacy/keycloak"
    },
    {
      name  = "image.tag"
      value = "26.3.3-debian-12-r0"
    },
    {
      name  = "postgresql.enabled"
      value = "true"
    },
    # NOTE: Using existingSecret here causes the Bitnami PostgreSQL subchart to mount
    # the secret as files (POSTGRES_PASSWORD_FILE) but the image v17.6 validation
    # still requires POSTGRESQL_PASSWORD env var, causing a CrashLoopBackOff.
    # Keeping inline password for the subchart; the secret resource still exists
    # for external reference.
    {
      name  = "postgresql.auth.password"
      value = var.keycloak_postgres_password
    },
    {
      name  = "postgresql.image.registry"
      value = "docker.io"
    },
    {
      name  = "postgresql.image.repository"
      value = "bitnamilegacy/postgresql"
    },
    {
      name  = "postgresql.image.tag"
      value = "17.6.0-debian-12-r0"
    },
    {
      name  = "postgresql.primary.persistence.enabled"
      value = "true"
    },
    {
      name  = "postgresql.primary.persistence.size"
      value = "${tostring(var.keycloak_postgres_storage_size_gb)}Gi"
    },
    {
      name  = "postgresql.volumePermissions.enabled"
      value = "true"
    },
    {
      name  = "postgresql.volumePermissions.image.registry"
      value = "docker.io"
    },
    {
      name  = "postgresql.volumePermissions.image.repository"
      value = "bitnamilegacy/os-shell"
    },
    {
      name  = "postgresql.volumePermissions.image.tag"
      value = "12-debian-12-r50"
    },
    {
      name  = "postgresql.primary.resources.requests.cpu"
      value = var.keycloak_postgres_resources.requests.cpu
    },
    {
      name  = "postgresql.primary.resources.requests.memory"
      value = var.keycloak_postgres_resources.requests.memory
    },
    {
      name  = "postgresql.primary.resources.limits.cpu"
      value = var.keycloak_postgres_resources.limits.cpu
    },
    {
      name  = "postgresql.primary.resources.limits.memory"
      value = var.keycloak_postgres_resources.limits.memory
    },
    {
      name  = "resources.requests.cpu"
      value = var.keycloak_resources.requests.cpu
    },
    {
      name  = "resources.requests.memory"
      value = var.keycloak_resources.requests.memory
    },
    {
      name  = "resources.limits.cpu"
      value = var.keycloak_resources.limits.cpu
    },
    {
      name  = "resources.limits.memory"
      value = var.keycloak_resources.limits.memory
    },
    # Disable keycloakConfigCli - we use native realm import instead
    {
      name  = "keycloakConfigCli.enabled"
      value = "false"
    },
    # Native realm import on startup
    {
      name  = "extraEnvVars[0].name"
      value = "KEYCLOAK_EXTRA_ARGS"
    },
    {
      name  = "extraEnvVars[0].value"
      value = "--import-realm"
    },
    # Set the hostname so Keycloak generates correct URLs in discovery docs
    {
      name  = "extraEnvVars[1].name"
      value = "KC_HOSTNAME"
    },
    {
      name  = "extraEnvVars[1].value"
      value = "https://${local.keycloak_host}"
    },
    # Trust X-Forwarded-* headers from the nginx ingress proxy
    {
      name  = "extraEnvVars[2].name"
      value = "KC_PROXY_HEADERS"
    },
    {
      name  = "extraEnvVars[2].value"
      value = "xforwarded"
    },
    {
      name  = "extraVolumes[0].name"
      value = "realm-config"
    },
    {
      name  = "extraVolumes[0].secret.secretName"
      value = kubernetes_secret_v1.keycloak_realm.metadata[0].name
    },
    {
      name  = "extraVolumeMounts[0].name"
      value = "realm-config"
    },
    {
      name  = "extraVolumeMounts[0].mountPath"
      value = "/opt/bitnami/keycloak/data/import"
    },
    {
      name  = "extraVolumeMounts[0].readOnly"
      value = "true"
    },
    # HA: Enable distributed Infinispan cache when running multiple replicas.
    # Keycloak uses JGroups/DNS_PING for peer discovery via the headless service.
    {
      name  = "cache.enabled"
      value = tostring(var.keycloak_replicas > 1)
    },
    {
      name  = "extraEnvVars[3].name"
      value = "KC_CACHE"
    },
    {
      name  = "extraEnvVars[3].value"
      value = var.keycloak_replicas > 1 ? "ispn" : "local"
    },
    {
      name  = "extraEnvVars[4].name"
      value = "KC_CACHE_STACK"
    },
    {
      name  = "extraEnvVars[4].value"
      value = "kubernetes"
    },
    # JGroups needs the namespace for DNS_PING peer discovery
    {
      name  = "extraEnvVars[5].name"
      value = "JAVA_OPTS_APPEND"
    },
    {
      name  = "extraEnvVars[5].value"
      value = "-Djgroups.dns.query=keycloak-headless.${local.namespace}.svc.cluster.local"
    },
    # PostgreSQL HA: enable read replicas when Keycloak has multiple replicas
    {
      name  = "postgresql.architecture"
      value = var.keycloak_replicas > 1 ? "replication" : "standalone"
    },
    {
      name  = "postgresql.readReplicas.replicaCount"
      value = var.keycloak_replicas > 1 ? "1" : "0"
    },
    {
      name  = "postgresql.readReplicas.resources.requests.cpu"
      value = var.keycloak_postgres_resources.requests.cpu
    },
    {
      name  = "postgresql.readReplicas.resources.requests.memory"
      value = var.keycloak_postgres_resources.requests.memory
    },
    {
      name  = "postgresql.readReplicas.resources.limits.cpu"
      value = var.keycloak_postgres_resources.limits.cpu
    },
    {
      name  = "postgresql.readReplicas.resources.limits.memory"
      value = var.keycloak_postgres_resources.limits.memory
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.identity_namespace,
    kubernetes_secret_v1.keycloak_database_password,
    kubernetes_secret_v1.keycloak_admin_password,
    kubernetes_secret_v1.keycloak_realm
  ]
}
