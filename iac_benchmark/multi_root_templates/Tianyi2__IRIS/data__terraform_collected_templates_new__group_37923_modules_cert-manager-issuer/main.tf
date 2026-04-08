/*
    Issuer Let's Encrypt (prod only)
    Executed via kubectl to avoid CRD discovery issues during plan.
*/
resource "null_resource" "letsencrypt_prod" {
  count = var.is_prod ? 1 : 0

  # Force re-run on each apply to avoid drift when CRDs were missing previously
  triggers = {
    acme_email      = var.acme_email
    kubeconfig_path = var.kubeconfig_path
    force_run       = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail

      if [ -z "${var.acme_email}" ]; then
        echo "acme_email must be set for Let's Encrypt issuer" >&2
        exit 1
      fi

      echo "Waiting for cert-manager CRDs to be ready..."
      for crd in certificates.cert-manager.io certificaterequests.cert-manager.io challenges.acme.cert-manager.io orders.acme.cert-manager.io; do
        kubectl --kubeconfig="${var.kubeconfig_path}" wait --for=condition=Established crd/"$crd" --timeout=180s
      done

      echo "Applying ClusterIssuer letsencrypt-prod"
      kubectl --kubeconfig="${var.kubeconfig_path}" apply -f - <<'YAML'
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt-prod
      spec:
        acme:
          email: ${var.acme_email}
          server: https://acme-v02.api.letsencrypt.org/directory
          privateKeySecretRef:
            name: letsencrypt-prod
          solvers:
            - http01:
                ingress:
                  class: traefik
      YAML
    EOT
  }
}
