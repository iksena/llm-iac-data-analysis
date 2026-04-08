variable "namespace" {
  type        = string
  default     = "twenty"
  description = "Namespace K8S pour Twenty"
}

variable "host" {
  type        = string
  description = "FQDN ingress pour Twenty"
}

variable "tls_secret_name" {
  type        = string
  description = "Secret TLS pour l’ingress Twenty"
}

variable "ingress_class_name" {
  type        = string
  description = "IngressClassName (traefik prod, nginx dev)"
}

variable "enable_twenty_worker" {
  type        = bool
  default     = false
  description = "Démarrer le conteneur worker (yarn worker:prod) si true"
}

variable "enable_tls" {
  type        = bool
  default     = true
  description = "Activer TLS/cert-manager pour Twenty"
}

variable "image" {
  type        = string
  description = "Image Twenty"
}

variable "db_host" {
  type        = string
  description = "Host Postgres pour Twenty"
}

variable "db_port" {
  type        = number
  description = "Port Postgres pour Twenty"
}

variable "db_name" {
  type        = string
  description = "Nom de DB Postgres pour Twenty"
}

variable "db_user" {
  type        = string
  description = "Utilisateur DB Postgres pour Twenty"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Mot de passe DB Postgres pour Twenty"
}

variable "app_secret" {
  type        = string
  sensitive   = true
  description = "APP_SECRET Twenty (string aléatoire et stable)"
}

variable "enable_velero" {
  type        = bool
  default     = true
  description = "Activer le Schedule Velero pour le namespace Twenty"
}

variable "velero_namespace" {
  type        = string
  default     = "velero"
  description = "Namespace Velero (pour le Schedule)"
}
