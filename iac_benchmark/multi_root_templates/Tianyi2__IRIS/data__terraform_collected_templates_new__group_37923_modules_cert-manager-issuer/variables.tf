variable "is_prod" {
  type        = bool
  description = "Prod toggle (Issuer only created in prod)"
}

variable "acme_email" {
  type        = string
  default     = ""
  description = "Email ACME pour Let's Encrypt"
}

variable "kubeconfig_path" {
  type        = string
  description = "Chemin du kubeconfig"
}
