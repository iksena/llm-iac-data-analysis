resource "local_file" "kubeconfig" {
  depends_on = [digitalocean_kubernetes_cluster.k8s]
  count      = var.write_kubeconfig ? 1 : 0
  content    = resource.digitalocean_kubernetes_cluster.k8s.kube_config[0].raw_config
  filename   = "${path.root}/.kube/config"
}
