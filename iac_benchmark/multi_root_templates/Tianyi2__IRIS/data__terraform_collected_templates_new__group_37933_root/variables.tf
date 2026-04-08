variable "do_token" {}

variable "ovh_endpoint" {
  type        = string
  description = "Endpoint OVH (ex: ovh-eu)"
}

variable "ovh_application_key" {
  type        = string
  sensitive   = true
  description = "OVH application key (external-dns)"
}

variable "ovh_application_secret" {
  type        = string
  sensitive   = true
  description = "OVH application secret (external-dns)"
}

variable "ovh_consumer_key" {
  type        = string
  sensitive   = true
  description = "OVH consumer key (external-dns)"
}

variable "app_env" {
  type        = string
  default     = "prod"
  description = "Environnement (prod = DOKS, dev = cluster local via kubeconfig, ex: docker-desktop)"
  validation {
    condition     = contains(["prod", "dev"], var.app_env)
    error_message = "app_env doit être 'prod' ou 'dev'."
  }
}

/* Root domains per environment */
variable "root_domain_prod" {
  type        = string
  default     = "fullfrontend.be"
  description = "Root domain in prod"
}

variable "root_domain_dev" {
  type        = string
  default     = "fullfrontend.kube"
  description = "Root domain in dev"
}

variable "enable_monitoring" {
  type        = bool
  default     = true
  description = "Activer le module monitoring (kube-prometheus-stack/Grafana)"
}

variable "enable_registry" {
  type        = bool
  default     = true
  description = "Déployer le module registry (zot) si true"
}

variable "enable_twenty_worker" {
  type        = bool
  default     = false
  description = "Démarrer le conteneur worker de Twenty (yarn worker:prod) si true"
}

# N8N (base de données Postgres externe)
variable "enable_n8n" {
  type        = bool
  default     = true
  description = "Déployer n8n (Helm) si true"
}

variable "enable_twenty" {
  type        = bool
  default     = false
  description = "Déployer Twenty (server + worker) si true"
}

variable "enable_sentry" {
  type        = bool
  default     = false
  description = "Déployer Sentry (self-hosted) si true"
}

variable "twenty_host" {
  type        = string
  default     = ""
  description = "FQDN pour l’ingress Twenty (ex: crm.example.com). Vide = dérivé du root_domain."
}

variable "sentry_host" {
  type        = string
  default     = ""
  description = "FQDN pour l’ingress Sentry (ex: sentry.example.com). Vide = dérivé du root_domain."
}

variable "twenty_tls_secret_name" {
  type        = string
  default     = "twenty-tls"
  description = "Secret TLS pour l’ingress Twenty"
}

variable "twenty_image" {
  type        = string
  default     = "twentycrm/twenty:latest"
  description = "Image Twenty"
}

variable "twenty_db_port" {
  type        = number
  default     = 5432
  description = "Port Postgres pour Twenty"
}

variable "twenty_app_secret" {
  type        = string
  default     = ""
  sensitive   = true
  description = "APP_SECRET pour Twenty (string aléatoire, stable pour JWT/crypto)"
}

variable "n8n_db_port" {
  type        = number
  default     = 5432
  description = "Port Postgres partagé pour n8n"
}

variable "n8n_chart_version" {
  type        = string
  default     = ""
  description = "Version du chart n8n (vide = dernière)"
}

variable "n8n_encryption_key" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Clé de chiffrement n8n (N8N_ENCRYPTION_KEY) ; si vide, le module doit en recevoir une via tfvars"
}

variable "n8n_enable_redis" {
  type        = bool
  default     = true
  description = "Déployer un Redis dédié pour la queue n8n (chart officiel redis)"
}

variable "n8n_redis_port" {
  type        = number
  default     = 6379
  description = "Port Redis externe pour la queue n8n"
}

variable "n8n_redis_db" {
  type        = number
  default     = 0
  description = "Index de DB Redis pour la queue n8n"
}

variable "n8n_redis_password" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Mot de passe Redis externe pour la queue n8n"
  validation {
    condition     = !var.n8n_enable_redis || length(var.n8n_redis_password) > 0
    error_message = "n8n_redis_password doit être renseigné si n8n_enable_redis=true."
  }
}

variable "n8n_redis_storage_size" {
  type        = string
  default     = "1Gi"
  description = "Taille du PVC Redis pour la queue n8n"
}

# WordPress (MariaDB externe)
variable "wp_tls_secret_name" {
  type        = string
  default     = "wordpress-tls"
  description = "Secret TLS pour l’ingress WordPress"
}

variable "wp_db_port" {
  type        = number
  default     = 3306
  description = "Port MariaDB pour WordPress"
}

variable "wp_replicas" {
  type        = number
  default     = 1
  description = "Réplicas WordPress"
}

variable "wp_storage_size" {
  type        = string
  default     = "2Gi"
  description = "Taille du PVC WordPress"
}

variable "wp_image" {
  type        = string
  default     = "wordpress:6.9-php8.2-apache"
  description = "Image WordPress (officielle, non Bitnami)"
}

variable "wp_cache" {
  type        = bool
  default     = true
  description = "Activer WP_CACHE"
}

variable "wpms_on" {
  type        = bool
  default     = true
  description = "Activer WPMS_ON (WP Mail SMTP)"
}

variable "wp_hsts_max_age" {
  type        = number
  default     = 31536000
  description = "Max-age HSTS (secondes)"
}

variable "wp_hsts_preload" {
  type        = bool
  default     = true
  description = "Activer le flag HSTS preload"
}

variable "wp_security_txt" {
  type        = string
  default     = ""
  description = "Contenu du security.txt (vide = valeur par defaut)"
}

variable "wp_humans_txt" {
  type        = string
  default     = ""
  description = "Contenu du humans.txt (vide = valeur par defaut)"
}

variable "wp_security_contact_email" {
  type        = string
  default     = ""
  description = "Email de contact security.txt (vide = auto via security@host)"
}

variable "wp_security_txt_sig" {
  type        = string
  default     = ""
  description = "Contenu ASCII armored du security.txt.sig"
}

variable "wp_security_txt_signature_url" {
  type        = string
  default     = ""
  description = "URL du security.txt.sig (vide = https://<host>/security.txt.sig si sig presente)"
}

variable "wp_as3_provider" {
  type        = string
  default     = "do"
  description = "Provider pour AS3CF (ex: do)"
}

variable "wp_as3_access_key" {
  type        = string
  default     = ""
  description = "Access key pour AS3CF"
  sensitive   = true
}

variable "wp_as3_secret_key" {
  type        = string
  default     = ""
  description = "Secret key pour AS3CF"
  sensitive   = true
}

variable "wp_mail_from" {
  type        = string
  default     = ""
  description = "Adresse expéditeur pour WP Mail SMTP"
}

variable "wp_mail_from_name" {
  type        = string
  default     = ""
  description = "Nom expéditeur pour WP Mail SMTP"
}

variable "wp_smtp_host" {
  type        = string
  default     = ""
  description = "Host SMTP pour WP Mail SMTP"
}

variable "wp_smtp_port" {
  type        = string
  default     = "465"
  description = "Port SMTP pour WP Mail SMTP"
}

variable "wp_smtp_ssl" {
  type        = string
  default     = "ssl"
  description = "Mode SSL/TLS pour WP Mail SMTP ('', 'ssl', 'tls')"
}

variable "wp_smtp_auth" {
  type        = bool
  default     = true
  description = "Activer l'auth SMTP"
}

variable "wp_smtp_user" {
  type        = string
  default     = ""
  description = "Utilisateur SMTP"
}

variable "wp_smtp_pass" {
  type        = string
  default     = ""
  description = "Mot de passe SMTP"
  sensitive   = true
}

variable "wp_lang" {
  type        = string
  default     = "fr_FR"
  description = "Langue WordPress (constante WPLANG)"
}

# Nextcloud (Postgres externe)
variable "nextcloud_tls_secret_name" {
  type        = string
  default     = "nextcloud-tls"
  description = "Secret TLS pour l’ingress Nextcloud"
}

variable "nextcloud_db_port" {
  type        = number
  default     = 5432
  description = "Port Postgres pour Nextcloud"
}

variable "nextcloud_replicas" {
  type        = number
  default     = 1
  description = "Réplicas Nextcloud"
}

variable "nextcloud_storage_size" {
  type        = string
  default     = "50Gi"
  description = "Taille du PVC Nextcloud"
}

variable "nextcloud_chart_version" {
  type        = string
  default     = ""
  description = "Version du chart Nextcloud (vide = dernière)"
}

# Monitoring / Grafana
variable "grafana_admin_user" {
  type        = string
  default     = "admin"
  description = "Utilisateur admin Grafana"
}

variable "grafana_admin_password" {
  type        = string
  default     = ""
  description = "Mot de passe admin Grafana"
  sensitive   = true
}

# Analytics (vince – https://www.vinceanalytics.com)
variable "analytics_tls_secret_name" {
  type        = string
  default     = "analytics-tls"
  description = "Secret TLS pour l’ingress analytics"
}

variable "analytics_domains" {
  type        = list(string)
  default     = []
  description = "Liste des domaines à ajouter par défaut dans Vince (traqués). Vide = root_domain."
}

variable "analytics_admin_username" {
  type        = string
  default     = "admin"
  description = "Compte admin initial pour Vince"
}

variable "analytics_admin_password" {
  type        = string
  default     = ""
  description = "Mot de passe admin Vince"
  sensitive   = true
}

variable "analytics_chart_version" {
  type        = string
  default     = ""
  description = "Version du chart Helm Vince (vide = dernière)"
}

# Sentry (self-hosted)
variable "sentry_tls_secret_name" {
  type        = string
  default     = "sentry-tls"
  description = "Secret TLS pour l’ingress Sentry"
}

variable "sentry_chart_version" {
  type        = string
  default     = ""
  description = "Version du chart Helm Sentry (vide = dernière)"
}

variable "sentry_admin_email" {
  type        = string
  default     = ""
  description = "Email admin Sentry (vide = auto via ops@<root_domain>)"
}

variable "sentry_admin_password" {
  type        = string
  default     = ""
  description = "Mot de passe admin Sentry"
  sensitive   = true
  validation {
    condition     = !var.enable_sentry || length(var.sentry_admin_password) > 0
    error_message = "sentry_admin_password doit être renseigné si enable_sentry=true."
  }
}

# Postgres (data)
variable "postgres_image" {
  type        = string
  default     = "postgres:16-alpine"
  description = "Image Postgres (officielle)"
}

variable "postgres_storage_size" {
  type        = string
  default     = "5Gi"
  description = "Taille du volume Postgres"
}

variable "postgres_root_password" {
  type        = string
  default     = ""
  description = "Mot de passe superuser Postgres"
  sensitive   = true
  validation {
    condition     = length(var.postgres_root_password) > 0
    error_message = "postgres_root_password must be set (non-empty)."
  }
}

variable "postgres_app_credentials" {
  type = list(object({
    name     = string
    db_name  = string
    user     = string
    password = string
  }))
  default     = []
  description = "Liste des DB/users Postgres par application"
}

# MariaDB (data)
variable "mariadb_image" {
  type        = string
  default     = "mariadb:11.4"
  description = "Image MariaDB (officielle)"
}

variable "mariadb_storage_size" {
  type        = string
  default     = "5Gi"
  description = "Taille du volume MariaDB"
}

variable "mariadb_root_password" {
  type        = string
  default     = ""
  description = "Mot de passe root MariaDB"
  sensitive   = true
  validation {
    condition     = length(var.mariadb_root_password) > 0
    error_message = "mariadb_root_password must be set (non-empty)."
  }
}

variable "mariadb_app_credentials" {
  type = list(object({
    name     = string
    db_name  = string
    user     = string
    password = string
  }))
  default     = []
  description = "Liste des DB/users MariaDB par application"
}

# DigitalOcean Kubernetes Cluster
variable "doks_region" {
  type        = string
  default     = "fra1"
  description = "DigitalOcean Kubernetes region"
}

variable "doks_name" {
  type        = string
  default     = "ffe-k8s"
  description = "K8S Cluster name"
}

variable "create_doks_cluster" {
  type        = bool
  default     = false
  description = "Créer le cluster DOKS (mettre false si le cluster existe déjà et qu’on veut uniquement provisionner K8s/Helm)"
}

variable "doks_node_size" {
  type        = string
  default     = "s-1vcpu-2gb"
  description = "K8S cluster Droplet nodes size"
}

# Velero (Spaces S3 pour backups)
variable "velero_bucket" {
  type        = string
  default     = "velero-backups-ffe"
  description = "Bucket Spaces pour Velero en prod (DO Spaces)"
}

# Cert-manager / ACME
variable "acme_email" {
  type        = string
  default     = ""
  description = "Email pour Let's Encrypt (ex: ops@example.com). Vide = pas d'Issuer créé."
}

# Ingress TLS toggle (HTTPS/cert-manager)
variable "enable_tls" {
  type        = bool
  default     = true
  description = "Activer TLS/redirect HTTPS sur les ingresses (mettre false si DNS non prêt ou en dev)"
}

variable "enable_velero" {
  type        = bool
  default     = true
  description = "Déployer Velero et les ressources liées (schedules, node-agent)."
}

variable "enable_waf" {
  type        = bool
  default     = true
  description = "Activer le WAF (ModSecurity + OWASP CRS) via Traefik"
}

variable "waf_plugin_module" {
  type        = string
  default     = "github.com/acouvreur/traefik-modsecurity-plugin"
  description = "Module Traefik plugin pour le WAF"
}

variable "waf_plugin_version" {
  type        = string
  default     = "v1.3.0"
  description = "Version du plugin WAF Traefik"
}

variable "waf_modsecurity_image" {
  type        = string
  default     = "owasp/modsecurity-crs:apache"
  description = "Image ModSecurity CRS (Apache)"
}

variable "waf_dummy_image" {
  type        = string
  default     = "nginx:alpine"
  description = "Image du backend dummy (WAF upstream)"
}

variable "waf_max_body_size" {
  type        = number
  default     = 10485760
  description = "Max body size pour le WAF (bytes)"
}

variable "waf_timeout_ms" {
  type        = number
  default     = 2000
  description = "Timeout WAF (ms)"
}

variable "extra_domain_filters" {
  type        = list(string)
  default     = ["perinatalite.be", "cloud.perinatalite.be"]
  description = "Domaines additionnels gérés par external-dns (ex: perinatalite.be, cloud.perinatalite.be)"
}

variable "velero_s3_url" {
  type        = string
  default     = "https://fra1.digitaloceanspaces.com"
  description = "Endpoint Spaces (ex: https://fra1.digitaloceanspaces.com)"
}

variable "velero_access_key" {
  type        = string
  default     = ""
  description = "Access key Spaces pour Velero"
  sensitive   = true
  validation {
    condition     = var.app_env != "prod" || length(var.velero_access_key) > 0
    error_message = "velero_access_key must be set in prod."
  }
}

variable "velero_secret_key" {
  type        = string
  default     = ""
  description = "Secret key Spaces pour Velero"
  sensitive   = true
  validation {
    condition     = var.app_env != "prod" || length(var.velero_secret_key) > 0
    error_message = "velero_secret_key must be set in prod."
  }
}

variable "minio_access_key" {
  type        = string
  default     = ""
  description = "Access key dédiée MinIO (dev)"
  sensitive   = true
  validation {
    condition     = var.app_env != "dev" || length(var.minio_access_key) > 0
    error_message = "minio_access_key must be set in dev."
  }
}

variable "minio_secret_key" {
  type        = string
  default     = ""
  description = "Secret key dédiée MinIO (dev)"
  sensitive   = true
  validation {
    condition     = var.app_env != "dev" || length(var.minio_secret_key) > 0
    error_message = "minio_secret_key must be set in dev."
  }
}

# Storage class pour les PVC (utile en dev docker-desktop)
variable "storage_class_name" {
  type        = string
  default     = ""
  description = "StorageClass pour les PVC (vide = utiliser la valeur par défaut du cluster)"
}

# Docker Hub (pull images privées)
variable "dockerhub_user" {
  type        = string
  default     = ""
  description = "Utilisateur Docker Hub (pour images privées)"
}

variable "dockerhub_pat" {
  type        = string
  default     = ""
  description = "Token/pat Docker Hub (pour images privées)"
  sensitive   = true
}

variable "dockerhub_email" {
  type        = string
  default     = ""
  description = "Email Docker Hub (optionnel, pour le secret dockerconfigjson)"
}

# Registry (zot) privé
variable "registry_htpasswd" {
  type        = string
  default     = ""
  description = "Entrée htpasswd (ex: user:$2y$... bcrypted) pour l'accès au registre privé"
  sensitive   = true
}

variable "registry_storage_backend" {
  type        = string
  default     = "local"
  description = "Backend du registre: local (PVC) ou s3 (Spaces/MinIO)"
}

variable "registry_s3_endpoint" {
  type        = string
  default     = ""
  description = "Endpoint S3 pour le registre (ex: https://nyc3.digitaloceanspaces.com ou http://minio.data.svc.cluster.local:9000)"
}

variable "registry_s3_region" {
  type        = string
  default     = ""
  description = "Région S3 (ex: nyc3)"
}

variable "registry_s3_bucket" {
  type        = string
  default     = ""
  description = "Bucket S3 utilisé par le registre"
}

variable "registry_s3_access_key" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Access key S3 (Spaces/MinIO)"
}

variable "registry_s3_secret_key" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Secret key S3 (Spaces/MinIO)"
}

variable "registry_s3_secure" {
  type        = bool
  default     = true
  description = "true si endpoint HTTPS, false si MinIO HTTP"
}
