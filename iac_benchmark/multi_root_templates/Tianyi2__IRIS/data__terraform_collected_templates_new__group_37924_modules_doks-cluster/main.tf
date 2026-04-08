data "digitalocean_kubernetes_versions" "current" {}

/*
    DOKS cluster with autoscaling node pool
    Attached to DO project
*/
resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = var.name
  region  = var.region
  version = data.digitalocean_kubernetes_versions.current.latest_version

  maintenance_policy {
    start_time = "03:00"
    day        = "sunday"
  }

  node_pool {
    name       = "default"
    size       = var.node_size
    auto_scale = true
    min_nodes  = var.pool_min_count
    max_nodes  = var.pool_max_count
  }

}

resource "digitalocean_project" "ffe_project" {
  name        = var.project_name
  description = var.project_description
  environment = var.project_environment
  purpose     = var.project_purpose
  resources   = [resource.digitalocean_kubernetes_cluster.k8s.urn]
}
