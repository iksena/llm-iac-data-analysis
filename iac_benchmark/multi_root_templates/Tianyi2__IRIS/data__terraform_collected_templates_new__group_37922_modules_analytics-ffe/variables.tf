variable "namespace" {
  type        = string
  default     = "analytics"
  description = "Namespace K8S pour les web-analytics"
}

variable "host" {
  type        = string
  description = "FQDN ingress pour l’analytics"
}

variable "tls_secret_name" {
  type        = string
  description = "Secret TLS pour l’ingress analytics"
}

variable "domains" {
  type        = list(string)
  description = "Liste des domaines à pré-créer dans Vince"
}

variable "admin_username" {
  type        = string
  description = "Compte admin initial Vince"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Mot de passe admin Vince"
}

variable "chart_version" {
  type        = string
  default     = ""
  description = "Version du chart Helm Vince (vide = dernière)"
}

variable "vince_image" {
  type        = string
  default     = "ghcr.io/vinceanalytics/vince:v1.7.1"
  description = "Image Vince (pin recommandée pour déploiements reproductibles)"
}

variable "storage_size" {
  type        = string
  default     = "5Gi"
  description = "Taille du PVC pour les données analytics"
}

variable "storage_class_name" {
  type        = string
  default     = ""
  description = "StorageClass pour le PVC analytics (vide = storageclass par défaut)"
}

variable "ingress_class_name" {
  type        = string
  description = "IngressClassName (ex: traefik en prod, nginx en dev)"
}

variable "enable_tls" {
  type        = bool
  default     = true
  description = "Activer TLS/cert-manager pour l'ingress analytics"
}

variable "enable_velero" {
  type        = bool
  default     = true
  description = "Activer le Schedule Velero pour le namespace analytics"
}

variable "velero_namespace" {
  type        = string
  default     = "velero"
  description = "Namespace Velero (pour le Schedule)"
}
