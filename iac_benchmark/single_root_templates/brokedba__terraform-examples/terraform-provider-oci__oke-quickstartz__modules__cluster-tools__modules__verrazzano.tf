# ── main.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Verrazzano Operator Helm Chart

resource "helm_release" "v8o_operator" {
  name      = "verrazzano-operator"
  chart     = "${path.module}/charts/verrazzano-operator"
  namespace = var.chart_namespace

  set {
    name  = "issuer.email"
    value = var.ingress_email_issuer
  }

}


# ── variables.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Cert Manager variables
variable "chart_namespace" {
  default = "cert-manager"
}
variable "chart_repository" {
  default = "https://charts.jetstack.io"
}
variable "chart_version" {
  default = "1.9.1"
}
variable "ingress_email_issuer" {
  default     = "no-reply@example.cloud"
  description = "You must replace this email address with your own. The certificate provider will use this to contact you about expiring certificates, and issues related to your account."
}

# ── providers.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

terraform {
  required_version = ">= 1.1"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2"
      # https://registry.terraform.io/providers/hashicorp/helm/
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4"
      # https://registry.terraform.io/providers/hashicorp/tls/
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
      # https://registry.terraform.io/providers/hashicorp/local/
    }
  }
}