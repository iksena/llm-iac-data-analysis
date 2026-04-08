locals {
  namespace     = var.kubernetes_identity_namespace
  keycloak_host = "keycloak.${var.kubernetes_ingress_base_host}"
}
