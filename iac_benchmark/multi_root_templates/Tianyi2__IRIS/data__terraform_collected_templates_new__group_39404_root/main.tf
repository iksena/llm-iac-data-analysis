provider "kind" {
}

resource "kind_cluster" "dev-cluster" {
  name = var.cluster_name
  wait_for_ready = true
  kubeconfig_path = pathexpand(var.kube_config_path)
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
          role = "control-plane"
          image = "kindest/node:v1.27.1"
          kubeadm_config_patches = [
            <<-EOT
              kind: InitConfiguration
              nodeRegistration:
                kubeletExtraArgs:
                  node-labels: "ingress-ready=true"
            EOT
          ]
          extra_port_mappings {
            container_port = 80
            host_port      = 80
            listen_address = "0.0.0.0"
          }
          extra_port_mappings {
            container_port = 443
            host_port      = 443
            listen_address = "0.0.0.0"
          }
      }
    node {
      role = "worker"
      image = "kindest/node:v1.27.1"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.27.1"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.27.1"
    }
  }
}