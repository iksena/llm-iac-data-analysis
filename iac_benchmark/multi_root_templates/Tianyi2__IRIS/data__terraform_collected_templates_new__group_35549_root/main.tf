module "agartha_storage" {
  source = "./storage"

  kubernetes_storage_namespace = "agartha-storage"
  kubernetes_ingress_base_host = local.agartha_host

  s3_warehouse_bucket_name    = var.storage_s3_warehouse_bucket_name
  s3_raw_bucket_name          = var.storage_s3_raw_bucket_name
  s3_dagster_code_bucket_name = var.storage_s3_dagster_code_bucket_name
  s3_access_key               = local.storage_s3_access_key
  s3_secret_key               = local.storage_s3_secret_key

  minio_tenant_servers_num            = 4
  minio_tenant_volumes_per_server_num = 2
  minio_tenant_size_per_volume_gb     = 10

  minio_operator_resources = var.storage_minio_operator_resources
  minio_tenant_resources   = var.storage_minio_tenant_resources

  # Keycloak OAuth integration
  minio_oauth_client_id      = module.agartha_identity.keycloak_minio_client_id
  minio_oauth_client_secret  = module.agartha_identity.keycloak_minio_client_secret
  keycloak_openid_config_url = module.agartha_identity.keycloak_openid_config_url

  # TLS
  tls_certificate = file(var.tls_certificate_path)
  tls_private_key = file(var.tls_private_key_path)

  # Network policy - allow ingress from monitoring, catalog, spark, flink
  allowed_ingress_namespaces = [
    "agartha-storage",
    "agartha-monitoring",
    "agartha-catalog",
    "agartha-processing-spark",
    "agartha-processing-flink",
    "agartha-backup",
    "ingress-nginx"
  ]

  depends_on = [
    module.agartha_identity
  ]
}

module "agartha_catalog" {
  source = "./catalog"

  kubernetes_catalog_namespace = "agartha-catalog"
  kubernetes_ingress_base_host = local.agartha_host

  storage_s3_endpoint         = "http://minio.agartha-storage.svc.cluster.local"
  storage_s3_access_key       = local.storage_s3_access_key
  storage_s3_secret_key       = local.storage_s3_secret_key
  storage_s3_warehouse_bucket = var.storage_s3_warehouse_bucket_name
  catalog_postgres_password   = local.catalog_postgres_password

  nessie_postgres_resources = var.catalog_nessie_postgres_resources
  nessie_resources          = var.catalog_nessie_resources

  # TLS
  tls_certificate = file(var.tls_certificate_path)
  tls_private_key = file(var.tls_private_key_path)

  # Network policy - allow ingress from monitoring, trino, notebooks
  allowed_ingress_namespaces = [
    "agartha-catalog",
    "agartha-monitoring",
    "agartha-processing-trino",
    "agartha-notebooks",
    "ingress-nginx"
  ]

  depends_on = [
    module.agartha_storage
  ]
}

module "agartha_monitoring" {
  source = "./monitoring"

  kubernetes_monitoring_namespace = "agartha-monitoring"
  kubernetes_ingress_base_host    = local.agartha_host

  grafana_admin_password     = local.monitoring_grafana_admin_password
  prometheus_retention_days  = 15
  prometheus_storage_size_gb = 10
  grafana_storage_size_gb    = 2

  minio_namespace  = "agartha-storage"
  nessie_namespace = "agartha-catalog"
  trino_namespace  = "agartha-processing-trino"
  spark_namespace  = "agartha-processing-spark"
  flink_namespace  = "agartha-processing-flink"

  loki_storage_size_gb = 10

  prometheus_server_resources = var.monitoring_prometheus_server_resources
  grafana_resources           = var.monitoring_grafana_resources
  alertmanager_resources      = var.monitoring_alertmanager_resources
  loki_resources              = var.monitoring_loki_resources
  promtail_resources          = var.monitoring_promtail_resources

  # Keycloak OAuth integration
  grafana_oauth_client_id     = module.agartha_identity.keycloak_grafana_client_id
  grafana_oauth_client_secret = module.agartha_identity.keycloak_grafana_client_secret
  keycloak_auth_url           = module.agartha_identity.keycloak_auth_url
  keycloak_token_url          = module.agartha_identity.keycloak_token_url
  keycloak_userinfo_url       = module.agartha_identity.keycloak_userinfo_url
  keycloak_jwks_url           = module.agartha_identity.keycloak_jwks_url

  # Prometheus OAuth2-Proxy integration
  prometheus_oauth_client_id     = module.agartha_identity.keycloak_prometheus_client_id
  prometheus_oauth_client_secret = module.agartha_identity.keycloak_prometheus_client_secret
  prometheus_oauth_cookie_secret = local.monitoring_prometheus_oauth_cookie_secret
  keycloak_issuer_url            = module.agartha_identity.keycloak_issuer_url

  # Alertmanager OAuth2-Proxy integration
  alertmanager_oauth_client_id     = module.agartha_identity.keycloak_alertmanager_client_id
  alertmanager_oauth_client_secret = module.agartha_identity.keycloak_alertmanager_client_secret
  alertmanager_oauth_cookie_secret = local.monitoring_alertmanager_oauth_cookie_secret

  # TLS
  tls_certificate = file(var.tls_certificate_path)
  tls_private_key = file(var.tls_private_key_path)

  # Network policy - allow ingress from itself only (monitoring primarily initiates connections)
  allowed_ingress_namespaces = [
    "agartha-monitoring",
    "ingress-nginx"
  ]

  depends_on = [
    module.agartha_identity
  ]
}

module "agartha_identity" {
  source = "./identity"

  kubernetes_identity_namespace = "agartha-identity"
  kubernetes_ingress_base_host  = local.agartha_host

  keycloak_admin_password           = local.identity_keycloak_admin_password
  keycloak_postgres_password        = local.identity_keycloak_postgres_password
  keycloak_postgres_storage_size_gb = 10
  keycloak_replicas                 = var.identity_keycloak_replicas
  keycloak_resources                = var.identity_keycloak_resources
  keycloak_postgres_resources       = var.identity_keycloak_postgres_resources

  grafana_oauth_client_secret      = local.identity_grafana_oauth_client_secret
  superset_oauth_client_secret     = local.identity_superset_oauth_client_secret
  trino_oauth_client_secret        = local.identity_trino_oauth_client_secret
  minio_oauth_client_secret        = local.identity_minio_oauth_client_secret
  jupyterhub_oauth_client_secret   = local.identity_jupyterhub_oauth_client_secret
  dagster_oauth_client_secret      = local.identity_dagster_oauth_client_secret
  prometheus_oauth_client_secret   = local.identity_prometheus_oauth_client_secret
  alertmanager_oauth_client_secret = local.identity_alertmanager_oauth_client_secret

  # TLS
  tls_certificate = file(var.tls_certificate_path)
  tls_private_key = file(var.tls_private_key_path)

  # Network policy - allow ingress from all namespaces (OAuth endpoint for all components)
  allowed_ingress_namespaces = [
    "agartha-identity",
    "agartha-storage",
    "agartha-catalog",
    "agartha-processing-spark",
    "agartha-processing-flink",
    "agartha-processing-trino",
    "agartha-monitoring",
    "agartha-notebooks",
    "agartha-orchestration",
    "agartha-bi",
    "ingress-nginx"
  ]
}

module "agartha_processing" {
  source = "./processing"

  kubernetes_processing_namespace_base = "agartha-processing"
  kubernetes_ingress_base_host         = local.agartha_host

  storage_s3_warehouse_location = "s3a://${var.storage_s3_warehouse_bucket_name}/"
  storage_s3_endpoint           = "http://minio.agartha-storage.svc.cluster.local"
  storage_s3_access_key         = local.storage_s3_access_key
  storage_s3_secret_key         = local.storage_s3_secret_key

  trino_cluster_worker_num = 2

  spark_operator_resources                    = var.processing_spark_operator_resources
  flink_operator_resources                    = var.processing_flink_operator_resources
  trino_coordinator_resources                 = var.processing_trino_coordinator_resources
  trino_worker_resources                      = var.processing_trino_worker_resources
  trino_coordinator_graceful_shutdown_seconds = var.processing_trino_coordinator_graceful_shutdown_seconds
  trino_worker_graceful_shutdown_seconds      = var.processing_trino_worker_graceful_shutdown_seconds

  # Keycloak OAuth integration
  trino_oauth_client_id        = module.agartha_identity.keycloak_trino_client_id
  trino_oauth_client_secret    = module.agartha_identity.keycloak_trino_client_secret
  keycloak_issuer_url          = module.agartha_identity.keycloak_issuer_url
  keycloak_auth_url            = module.agartha_identity.keycloak_auth_url
  keycloak_token_url           = module.agartha_identity.keycloak_token_url
  keycloak_jwks_url            = module.agartha_identity.keycloak_jwks_url
  keycloak_userinfo_url        = module.agartha_identity.keycloak_userinfo_url
  trino_internal_shared_secret = local.processing_trino_internal_shared_secret

  # TLS
  tls_certificate = file(var.tls_certificate_path)
  tls_private_key = file(var.tls_private_key_path)

  # Network policies - allow ingress from specific namespaces
  spark_allowed_ingress_namespaces = [
    "agartha-processing-spark",
    "agartha-monitoring",
    "agartha-orchestration"
  ]

  flink_allowed_ingress_namespaces = [
    "agartha-processing-flink",
    "agartha-monitoring",
    "agartha-orchestration"
  ]

  trino_allowed_ingress_namespaces = [
    "agartha-processing-trino",
    "agartha-monitoring",
    "agartha-notebooks",
    "agartha-bi",
    "agartha-orchestration",
    "ingress-nginx"
  ]

  depends_on = [
    module.agartha_monitoring,
    module.agartha_identity
  ]
}

module "business_intelligence" {
  source = "./business_intelligence"

  kubernetes_bi_namespace      = "agartha-bi"
  kubernetes_ingress_base_host = local.agartha_host

  superset_node_replica_num   = 1
  superset_worker_replica_num = 1

  superset_node_resources           = var.bi_superset_node_resources
  superset_worker_resources         = var.bi_superset_worker_resources
  superset_postgres_resources       = var.bi_superset_postgres_resources
  superset_redis_resources          = var.bi_superset_redis_resources
  superset_postgres_storage_size_gb = var.bi_superset_postgres_storage_size_gb
  superset_redis_storage_size_gb    = var.bi_superset_redis_storage_size_gb

  # Keycloak OAuth integration
  superset_oauth_client_id     = module.agartha_identity.keycloak_superset_client_id
  superset_oauth_client_secret = module.agartha_identity.keycloak_superset_client_secret
  keycloak_auth_url            = module.agartha_identity.keycloak_auth_url
  keycloak_token_url           = module.agartha_identity.keycloak_token_url
  keycloak_issuer_url          = module.agartha_identity.keycloak_issuer_url
  keycloak_jwks_url            = module.agartha_identity.keycloak_jwks_url
  keycloak_api_base_url        = module.agartha_identity.keycloak_api_base_url

  # TLS
  tls_certificate = file(var.tls_certificate_path)
  tls_private_key = file(var.tls_private_key_path)

  # Network policy - allow ingress from monitoring only
  allowed_ingress_namespaces = [
    "agartha-bi",
    "agartha-monitoring",
    "ingress-nginx"
  ]

  depends_on = [
    module.agartha_processing,
    module.agartha_identity
  ]
}

module "agartha_orchestration" {
  source = "./orchestration"

  kubernetes_orchestration_namespace = "agartha-orchestration"
  kubernetes_ingress_base_host       = local.agartha_host

  storage_s3_warehouse_location = "s3a://${var.storage_s3_warehouse_bucket_name}/"
  storage_s3_endpoint           = "http://minio.agartha-storage.svc.cluster.local"
  storage_s3_access_key         = local.storage_s3_access_key
  storage_s3_secret_key         = local.storage_s3_secret_key

  dagster_webserver_replica_num               = 1
  dagster_postgres_password                   = local.orchestration_dagster_postgres_password
  dagster_postgres_storage_size_gb            = var.orchestration_dagster_postgres_storage_size_gb
  dagster_user_code_deployments               = var.orchestration_dagster_user_code_deployments
  dagster_code_bucket                         = var.storage_s3_dagster_code_bucket_name
  dagster_run_coordinator_max_concurrent_runs = 10

  spark_namespace = "agartha-processing-spark"
  flink_namespace = "agartha-processing-flink"

  # Keycloak OAuth integration
  dagster_oauth_client_id     = module.agartha_identity.keycloak_dagster_client_id
  dagster_oauth_client_secret = module.agartha_identity.keycloak_dagster_client_secret
  dagster_oauth_cookie_secret = local.orchestration_dagster_oauth_cookie_secret
  keycloak_issuer_url         = module.agartha_identity.keycloak_issuer_url
  keycloak_auth_url           = module.agartha_identity.keycloak_auth_url
  keycloak_token_url          = module.agartha_identity.keycloak_token_url
  keycloak_jwks_url           = module.agartha_identity.keycloak_jwks_url

  # TLS
  tls_certificate = file(var.tls_certificate_path)
  tls_private_key = file(var.tls_private_key_path)

  # Network policy - allow ingress from monitoring only
  allowed_ingress_namespaces = [
    "agartha-orchestration",
    "agartha-monitoring",
    "ingress-nginx"
  ]

  depends_on = [
    module.agartha_processing,
    module.agartha_identity
  ]
}

module "agartha_notebooks" {
  source = "./notebooks"

  kubernetes_notebooks_namespace = "agartha-notebooks"
  kubernetes_ingress_base_host   = local.agartha_host

  nessie_uri = "http://nessie.agartha-catalog.svc.cluster.local:19120/iceberg"
  trino_host = "trino.agartha-processing-trino.svc.cluster.local"
  trino_port = 8080

  jupyterhub_storage_size_gb = 10

  jupyterhub_hub_resources   = var.notebooks_jupyterhub_hub_resources
  jupyterhub_proxy_resources = var.notebooks_jupyterhub_proxy_resources

  # Keycloak OAuth
  jupyterhub_oauth_client_id     = module.agartha_identity.keycloak_jupyterhub_client_id
  jupyterhub_oauth_client_secret = module.agartha_identity.keycloak_jupyterhub_client_secret
  keycloak_auth_url              = module.agartha_identity.keycloak_auth_url
  keycloak_token_url             = module.agartha_identity.keycloak_token_url
  keycloak_userinfo_url          = module.agartha_identity.keycloak_userinfo_url

  # TLS
  tls_certificate = file(var.tls_certificate_path)
  tls_private_key = file(var.tls_private_key_path)

  # Network policy - allow ingress from monitoring only
  allowed_ingress_namespaces = [
    "agartha-notebooks",
    "agartha-monitoring",
    "ingress-nginx"
  ]

  depends_on = [
    module.agartha_storage,
    module.agartha_catalog,
    module.agartha_processing,
    module.agartha_identity
  ]
}

module "agartha_backup" {
  source = "./backup"

  kubernetes_backup_namespace = "agartha-backup"

  s3_endpoint           = "http://minio.agartha-storage.svc.cluster.local"
  s3_access_key         = local.storage_s3_access_key
  s3_secret_key         = local.storage_s3_secret_key
  s3_backup_bucket_name = var.backup_s3_bucket_name

  backup_schedule       = var.backup_schedule
  backup_retention_days = var.backup_retention_days

  backup_namespaces = [
    "agartha-storage",
    "agartha-catalog",
    "agartha-monitoring",
    "agartha-identity",
    "agartha-processing-spark",
    "agartha-processing-flink",
    "agartha-processing-trino",
    "agartha-notebooks",
    "agartha-orchestration",
    "agartha-bi",
    "agartha-backup"
  ]

  # Network policy - allow ingress from monitoring and self
  allowed_ingress_namespaces = [
    "agartha-backup",
    "agartha-monitoring"
  ]

  depends_on = [
    module.agartha_storage
  ]
}