// PVC usage collector based on df() of host mounts:
// - Runs as DaemonSet on each node (privileged, hostPath /var/lib/kubelet/pods).
// - Liste les montages CSI /var/lib/kubelet/pods/*/volumes/kubernetes.io~csi/<pvc-uid>/mount
// - Map pvc UID -> namespace/name via l’API K8s (service account token).
// - Expose des métriques Prometheus : pvc_used_bytes, pvc_capacity_bytes, pvc_available_bytes (namespace, pvc, node).
// Note : nécessite que les volumes soient montés sous le chemin kubelet par défaut.

resource "kubernetes_service_account" "pvc_usage_collector" {
  metadata {
    name      = "pvc-usage-collector"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "pvc-usage-collector"
    }
  }
}

resource "kubernetes_cluster_role" "pvc_usage_collector" {
  metadata {
    name = "pvc-usage-collector"
    labels = {
      app = "pvc-usage-collector"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims", "persistentvolumes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "pvc_usage_collector" {
  metadata {
    name = "pvc-usage-collector"
    labels = {
      app = "pvc-usage-collector"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.pvc_usage_collector.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.pvc_usage_collector.metadata[0].name
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
}

resource "kubernetes_config_map" "pvc_usage_collector" {
  metadata {
    name      = "pvc-usage-collector"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "pvc-usage-collector"
    }
  }

  data = {
    "collector.py" = <<-PY
      import os
      import glob
      import json
      import time
      import requests
      from http.server import BaseHTTPRequestHandler, HTTPServer

      NODE_NAME = os.environ.get("NODE_NAME", "")
      PORT = int(os.environ.get("PORT", "9104"))
      TOKEN_PATH = "/var/run/secrets/kubernetes.io/serviceaccount/token"
      CA_PATH = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
      API_SERVER = "https://kubernetes.default.svc"

      def load_token():
          try:
              with open(TOKEN_PATH, "r", encoding="utf-8") as f:
                  return f.read().strip()
          except FileNotFoundError:
              return None

      def fetch_pvc_map(token):
          headers = {"Authorization": f"Bearer {token}"}
          url = f"{API_SERVER}/api/v1/persistentvolumeclaims"
          try:
              resp = requests.get(url, headers=headers, verify=CA_PATH, timeout=5)
              resp.raise_for_status()
              items = resp.json().get("items", [])
          except Exception:
              return {}
          mapping = {}
          for pvc in items:
              meta = pvc.get("metadata", {})
              uid = meta.get("uid")
              name = meta.get("name")
              ns = meta.get("namespace")
              if uid and name and ns:
                  mapping[uid] = (ns, name)
          return mapping

      def list_mounts():
          pattern = "/var/lib/kubelet/pods/*/volumes/kubernetes.io~csi/*/mount"
          return glob.glob(pattern)

      def stat_path(path):
          try:
              st = os.statvfs(path)
          except Exception:
              return None
          block = st.f_frsize or st.f_bsize or 1
          total = block * st.f_blocks
          avail = block * st.f_bavail
          free = block * st.f_bfree
          used = total - free
          return used, total, avail

      def emit_metrics(out, pvc_map):
          def write_line(line):
              out.write((line + "\n").encode("utf-8"))

          write_line("# HELP pvc_used_bytes PVC used bytes")
          write_line("# TYPE pvc_used_bytes gauge")
          write_line("# HELP pvc_capacity_bytes PVC capacity bytes")
          write_line("# TYPE pvc_capacity_bytes gauge")
          write_line("# HELP pvc_available_bytes PVC available bytes")
          write_line("# TYPE pvc_available_bytes gauge")

          for path in list_mounts():
              parts = path.split("/")
              try:
                  pvc_uid = parts[-2].replace("pvc-", "")
              except Exception:
                  continue
              ns_name = pvc_map.get(pvc_uid)
              if not ns_name:
                  continue
              ns, name = ns_name
              stats = stat_path(path)
              if not stats:
                  continue
              used, total, avail = stats
              labels = f'namespace="{ns}",pvc="{name}",node="{NODE_NAME}"'
              write_line(f"pvc_used_bytes{{{labels}}} {used}")
              write_line(f"pvc_capacity_bytes{{{labels}}} {total}")
              write_line(f"pvc_available_bytes{{{labels}}} {avail}")

      class Handler(BaseHTTPRequestHandler):
          def do_GET(self):
              if self.path != "/metrics":
                  self.send_response(404)
                  self.end_headers()
                  return
              token = load_token()
              pvc_map = fetch_pvc_map(token) if token else {}
              self.send_response(200)
              self.send_header("Content-Type", "text/plain; version=0.0.4")
              self.end_headers()
              emit_metrics(self.wfile, pvc_map)

      if __name__ == "__main__":
          server = HTTPServer(("0.0.0.0", PORT), Handler)
          while True:
              try:
                  server.serve_forever()
              except Exception:
                  time.sleep(5)
    PY
  }
}

resource "kubernetes_daemonset" "pvc_usage_collector" {
  metadata {
    name      = "pvc-usage-collector"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "pvc-usage-collector"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "pvc-usage-collector"
      }
    }

    template {
      metadata {
        labels = {
          app = "pvc-usage-collector"
        }
      }

      spec {
        service_account_name            = kubernetes_service_account.pvc_usage_collector.metadata[0].name
        host_network                    = true
        host_pid                        = true
        dns_policy                      = "ClusterFirstWithHostNet"
        automount_service_account_token = true

        container {
          name  = "collector"
          image = "python:3.11-alpine"
          security_context {
            privileged = true
          }
          command = ["sh", "-c", "pip install --no-cache-dir requests && python /app/collector.py"]

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name  = "PORT"
            value = "9104"
          }

          port {
            name           = "http-metrics"
            container_port = 9104
            protocol       = "TCP"
          }

          volume_mount {
            name       = "scripts"
            mount_path = "/app"
          }
          volume_mount {
            name       = "kubelet-pods"
            mount_path = "/var/lib/kubelet/pods"
            read_only  = true
          }
        }

        volume {
          name = "scripts"
          config_map {
            name = kubernetes_config_map.pvc_usage_collector.metadata[0].name
          }
        }
        volume {
          name = "kubelet-pods"
          host_path {
            path = "/var/lib/kubelet/pods"
            type = "Directory"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pvc_usage_collector" {
  metadata {
    name      = "pvc-usage-collector"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "pvc-usage-collector"
    }
  }

  spec {
    selector = {
      app = "pvc-usage-collector"
    }
    port {
      name        = "http-metrics"
      port        = 9104
      target_port = "http-metrics"
      protocol    = "TCP"
    }
  }
}

resource "kubernetes_manifest" "pvc_usage_collector_servicemonitor" {
  count      = var.is_prod && var.enable_kube_prometheus_stack ? 1 : 0
  depends_on = [helm_release.kube_prometheus_stack]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "pvc-usage-collector"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        release = "kube-prometheus-stack"
        app     = "pvc-usage-collector"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "pvc-usage-collector"
        }
      }
      namespaceSelector = {
        matchNames = [kubernetes_namespace.monitoring.metadata[0].name]
      }
      endpoints = [
        {
          port     = "http-metrics"
          interval = "30s"
        }
      ]
    }
  }
}