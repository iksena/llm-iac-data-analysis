variable "namespace" {
  type        = string
  default     = "ffe-website"
  description = "Namespace K8S pour ffe-website"
}

variable "host" {
  type        = string
  description = "FQDN ingress pour WordPress"
}

variable "tls_secret_name" {
  type        = string
  description = "Secret TLS pour l’ingress WordPress"
}

variable "ingress_class_name" {
  type        = string
  description = "IngressClassName (ex: traefik en prod, nginx en dev)"
}

variable "enable_tls" {
  type        = bool
  default     = true
  description = "Activer TLS/cert-manager pour l'ingress WordPress"
}

variable "db_host" {
  type        = string
  description = "Hôte MariaDB externe pour WordPress"
}

variable "db_port" {
  type        = number
  default     = 3306
  description = "Port MariaDB"
}

variable "db_name" {
  type        = string
  description = "Nom de base MariaDB"
}

variable "db_user" {
  type        = string
  description = "Utilisateur MariaDB"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Mot de passe MariaDB"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Nombre de replicas de WordPress"
}

variable "storage_size" {
  type        = string
  description = "Taille du PVC pour WordPress"
}

variable "image" {
  type        = string
  description = "Image WordPress (officielle, non Bitnami)"
}

variable "as3_provider" {
  type        = string
  default     = "do"
  description = "Provider pour AS3CF (ex: do)"
}

variable "as3_access_key" {
  type        = string
  default     = ""
  description = "Access key pour AS3CF"
  sensitive   = true
}

variable "as3_secret_key" {
  type        = string
  default     = ""
  description = "Secret key pour AS3CF"
  sensitive   = true
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

variable "mail_from" {
  type        = string
  default     = ""
  description = "Adresse expéditeur pour WP Mail SMTP"
}

variable "mail_from_name" {
  type        = string
  default     = ""
  description = "Nom expéditeur pour WP Mail SMTP"
}

variable "smtp_host" {
  type        = string
  default     = ""
  description = "Host SMTP pour WP Mail SMTP"
}

variable "smtp_port" {
  type        = string
  default     = "465"
  description = "Port SMTP pour WP Mail SMTP"
}

variable "smtp_ssl" {
  type        = string
  default     = "ssl"
  description = "Mode SSL/TLS pour WP Mail SMTP ('', 'ssl', 'tls')"
}

variable "smtp_auth" {
  type        = bool
  default     = true
  description = "Activer l'auth SMTP"
}

variable "smtp_user" {
  type        = string
  default     = ""
  description = "Utilisateur SMTP"
}

variable "smtp_pass" {
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

variable "dockerhub_user" {
  type        = string
  default     = ""
  description = "Utilisateur Docker Hub (pull image privée)"
}

variable "dockerhub_pat" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Token/pat Docker Hub (pull image privée)"
}

variable "dockerhub_email" {
  type        = string
  default     = ""
  description = "Email Docker Hub (optionnel pour le secret dockerconfigjson)"
}

variable "velero_namespace" {
  type        = string
  default     = "infra"
  description = "Namespace où tourne Velero (pour créer le Schedule)"
}

variable "enable_velero" {
  type        = bool
  default     = true
  description = "Activer la création du Schedule Velero (désactiver si Velero n'est pas déployé)"
}
