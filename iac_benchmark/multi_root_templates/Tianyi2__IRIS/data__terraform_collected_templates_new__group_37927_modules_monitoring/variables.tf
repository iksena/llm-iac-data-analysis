variable "is_prod" {
  type        = bool
  description = "True en prod (déploie la stack kube-prometheus)"
}

variable "ingress_class_name" {
  type        = string
  description = "IngressClassName pour Grafana (traefik en prod, nginx en dev)"
}

variable "enable_tls" {
  type        = bool
  default     = true
  description = "Activer TLS/annotations cert-manager sur l'ingress Grafana"
}

variable "enable_kube_prometheus_stack" {
  type        = bool
  default     = true
  description = "Déployer kube-prometheus-stack (monitoring/alerting)"
}

variable "grafana_host" {
  type        = string
  description = "FQDN pour Grafana (ingress kube-prometheus-stack)"
}

variable "grafana_admin_user" {
  type        = string
  description = "Login administrateur Grafana"
}

variable "grafana_admin_password" {
  type        = string
  description = "Mot de passe administrateur Grafana"
  sensitive   = true
}
