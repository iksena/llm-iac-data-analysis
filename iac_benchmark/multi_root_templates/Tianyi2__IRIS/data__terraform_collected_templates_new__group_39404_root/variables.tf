variable "cluster_name" {
    type = string
    description = "the name of the main cluster"
    default = "dev-cluster"
}

variable "kube_config_path" {
  type = string
  description = "the path of the kubeconfig"
  default = "~/.kube/config"
}

variable "argocd_admin_pass" {
  type = string
  default = "admin"
}

variable "argocd_hostname" {
  type = string
  description = "the url of the argocd"
  default = "argocd.dev.devandshell.com"
}