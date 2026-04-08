# Patch CoreDNS to resolve external Keycloak hostname within the cluster
# This allows services like MinIO to fetch OIDC configuration that contains
# external URLs, by rewriting DNS queries to the internal service

resource "kubernetes_config_map_v1" "coredns_override" {
  metadata {
    name      = "coredns"
    namespace = "kube-system"
  }

  data = {
    "Corefile" = <<-EOF
      .:53 {
          log
          errors
          health {
             lameduck 5s
          }
          ready
          kubernetes cluster.local in-addr.arpa ip6.arpa {
             pods insecure
             fallthrough in-addr.arpa ip6.arpa
             ttl 30
          }
          prometheus :9153
          hosts {
             192.168.49.1 host.minikube.internal
             fallthrough
          }
          rewrite name ${local.keycloak_host} ingress-nginx-controller.ingress-nginx.svc.cluster.local
          forward . /etc/resolv.conf {
             max_concurrent 1000
          }
          cache 30 {
             disable success cluster.local
             disable denial cluster.local
          }
          loop
          reload
          loadbalance
      }
    EOF
  }

  lifecycle {
    # Ignore changes to other fields that might be managed by minikube/kubernetes
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels,
    ]
  }
}
