provider "kubectl" {
  load_config_file = true
  config_path = kind_cluster.dev-cluster.kubeconfig_path
}
provider "kubernetes" {
  config_path = kind_cluster.dev-cluster.kubeconfig_path
}

data "http" "kind_ingress_http" {
  url = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml"
}

data "kubectl_file_documents" "nginx_yaml_files" {
  content = data.http.kind_ingress_http.response_body
}

resource "kubernetes_namespace" "nginx_namespace" {
    metadata {
      name = "ingress-nginx"
    }
    depends_on = [ kind_cluster.dev-cluster, data.kubectl_file_documents.nginx_yaml_files ]
}
resource "kubectl_manifest" "nginx_manifest" {
  provider = kubectl
  for_each = data.kubectl_file_documents.nginx_yaml_files.manifests
  yaml_body = each.value
  wait = true
  depends_on = [ kubernetes_namespace.nginx_namespace ]
}