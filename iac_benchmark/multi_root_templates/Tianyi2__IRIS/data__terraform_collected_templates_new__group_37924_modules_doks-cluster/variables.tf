variable "region" {
  type        = string
  description = "DigitalOcean Kubernetes region"
}

variable "name" {
  type        = string
  description = "K8S Cluster name"
}

variable "node_size" {
  type        = string
  description = "K8S cluster Droplet nodes size"
}

variable "pool_min_count" {
  type        = number
  description = "K8S cluster minimal nodes count"
}

variable "pool_max_count" {
  type        = number
  description = "K8S cluster maximal nodes count"
}

variable "project_name" {
  type        = string
  default     = "Full Front-End"
  description = "Nom du projet DigitalOcean"
}

variable "project_description" {
  type        = string
  default     = "Web stack for Website and Automation"
  description = "Description du projet DigitalOcean"
}

variable "project_environment" {
  type        = string
  default     = "Production"
  description = "Environnement du projet DigitalOcean"
}

variable "project_purpose" {
  type        = string
  default     = "Website or blog"
  description = "Purpose du projet DigitalOcean"
}

variable "write_kubeconfig" {
  type        = bool
  default     = true
  description = "Ecrire le kubeconfig du cluster sur disque"
}
