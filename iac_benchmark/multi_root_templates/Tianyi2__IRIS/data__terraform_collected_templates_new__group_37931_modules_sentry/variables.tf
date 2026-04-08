variable "namespace" {
  type        = string
  default     = "sentry"
  description = "Namespace K8S pour Sentry"
}

variable "host" {
  type        = string
  description = "FQDN pour Sentry (ex: sentry.<root_domain>)"
}

variable "tls_secret_name" {
  type        = string
  default     = "sentry-tls"
  description = "Secret TLS pour l'ingress Sentry"
}

variable "ingress_class_name" {
  type        = string
  default     = "traefik"
  description = "IngressClassName (traefik prod, nginx dev)"
}

variable "enable_tls" {
  type        = bool
  default     = true
  description = "Activer TLS/cert-manager pour l'ingress Sentry"
}

variable "chart_version" {
  type        = string
  default     = ""
  description = "Version du chart Helm Sentry (vide = dernière)"
}

variable "admin_email" {
  type        = string
  default     = ""
  description = "Email admin Sentry"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Mot de passe admin Sentry"
}

variable "enable_velero" {
  type        = bool
  default     = true
  description = "Activer la création du Schedule Velero pour Sentry"
}

variable "velero_namespace" {
  type        = string
  default     = "velero"
  description = "Namespace Velero (pour le Schedule)"
}
