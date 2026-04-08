locals {
  cluster_endpoint = "https://${var.k8s_vip}:6443"
  common_machine_config = {
    machine = {
      install = {
        image = "factory.talos.dev/installer/${talos_image_factory_schematic.common.id}:${var.talos_version}"
      }
      features = {
        # see https://www.talos.dev/v1.8/talos-guides/network/host-dns/
        hostDNS = {
          enabled              = true
          forwardKubeDNSToHost = true
        }
      }
      kubelet = {
        extraArgs = {
          rotate-server-certificates = true
        }
      }
    }
  }
  control_node_machine_config = {
    machine = {
      network = {
        interfaces = [
          # see https://www.talos.dev/v1.8/talos-guides/network/vip/
          {
            interface = "eth0"
            vip = {
              ip = var.k8s_vip
            }
          }
        ]
      }
    }
    cluster = {
      apiServer = {
        admissionControl = [{
          name = "PodSecurity"
          configuration = {
            apiVersion = "pod-security.admission.config.k8s.io/v1beta1"
            kind       = "PodSecurityConfiguration"
            exemptions = {
              namespaces = ["traefik", "longhorn-system"]
            }
          }
        }]
      }
      extraManifests = [
        "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
        "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml",
        "https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml",
        "https://github.com/cert-manager/cert-manager/releases/download/v${local.cert_manager.version}/cert-manager.crds.yaml",
        "https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v${local.nvidia_device_plugin.version}/deployments/static/nvidia-device-plugin.yml"
      ]
      inlineManifests = [
        {
          name = "metallb"
          contents = templatefile("${path.module}/templates/metallb.yaml.tmpl", {
            cidr_pool = ["${var.k8s_lb_ip}/32"]
          })
        },
        {
          name     = "cert-manager"
          contents = data.helm_template.cert_manager.manifest
        },
        {
          name = "cert-manager-issuer"
          contents = templatefile("${path.module}/templates/cert-manager.yaml.tmpl", {
            acme_server           = var.acme_server
            acme_email            = var.acme_email
            aws_region            = var.aws_region
            aws_access_key_id     = var.aws_iam_credentials.access_key_id
            aws_secret_access_key = var.aws_iam_credentials.secret_access_key
            hosted_zone_id        = var.aws_route53_zone_id
            issuer_name           = local.cert_manager.issuer_name
          })
        },
        {
          name = "traefik-namespace"
          contents = templatefile("${path.module}/templates/namespace.yaml.tmpl", {
            namespace = local.traefik.namespace
          })
        },
        {
          name     = "traefik-crds"
          contents = data.helm_template.traefik_crds.manifest
        },
        {
          name     = "traefik"
          contents = data.helm_template.traefik.manifest
        },
        {
          name = "longhorn-namespace"
          contents = templatefile("${path.module}/templates/namespace.yaml.tmpl", {
            namespace = local.longhorn.namespace
          })
        },
        {
          name     = "longhorn"
          contents = data.helm_template.longhorn.manifest
        },
        {
          name = "nvidia-device-plugin"
          contents = templatefile("${path.module}/templates/nvidia-device-plugin.yaml.tmpl", {
            version = local.nvidia_device_plugin.version
          })
        },
        {
          name     = "nvidia"
          contents = file("${path.module}/templates/nvidia.yaml")
        }
      ]
    }
  }
  worker_node_machine_config = {
    machine = {
      kubelet = {
        extraMounts = [
          {
            destination = "/var/lib/longhorn"
            type        = "bind"
            source      = "/var/lib/longhorn"
            options = [
              "rbind",
              "rshared",
              "rw",
            ]
          },
        ]
      }
    }
  }
  gpu_node_machine_config = {
    machine = {
      nodeLabels = {
        "nvidia.com/gpu.present" = true
      }
      install = {
        image = "factory.talos.dev/installer/${talos_image_factory_schematic.gpu.id}:${var.talos_version}"
      }
      features = {
        # see https://www.talos.dev/v1.8/talos-guides/network/host-dns/
        hostDNS = {
          enabled              = true
          forwardKubeDNSToHost = true
        }
      }
      kubelet = {
        extraArgs = {
          rotate-server-certificates = true
        }
      }
      sysctls = {
        "net.core.bpf_jit_harden" = 1
      }
      kernel = {
        modules = [
          {
            name = "nvidia"
          },
          {
            name = "nvidia_uvm"
          },
          {
            name = "nvidia_drm"
          },
          {
            name = "nvidia_modeset"
          }
        ]
      }
    }
  }
}

resource "talos_machine_secrets" "cluster" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "control" {
  cluster_name       = var.cluster_name
  machine_type       = "controlplane"
  cluster_endpoint   = local.cluster_endpoint
  talos_version      = var.talos_version
  kubernetes_version = var.k8s_version
  machine_secrets    = talos_machine_secrets.cluster.machine_secrets
  examples           = false
  docs               = false
  config_patches = [
    yamlencode(local.common_machine_config),
    yamlencode(local.control_node_machine_config),
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name       = var.cluster_name
  machine_type       = "worker"
  cluster_endpoint   = local.cluster_endpoint
  talos_version      = var.talos_version
  kubernetes_version = var.k8s_version
  machine_secrets    = talos_machine_secrets.cluster.machine_secrets
  config_patches = [
    yamlencode(local.common_machine_config),
    yamlencode(local.worker_node_machine_config),
  ]
}

data "talos_machine_configuration" "gpu" {
  cluster_name       = var.cluster_name
  machine_type       = "worker"
  cluster_endpoint   = local.cluster_endpoint
  talos_version      = var.talos_version
  kubernetes_version = var.k8s_version
  machine_secrets    = talos_machine_secrets.cluster.machine_secrets
  config_patches = [
    yamlencode(local.gpu_node_machine_config),
    yamlencode(local.worker_node_machine_config)
  ]
}

data "talos_client_configuration" "talos" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.cluster.client_configuration
  endpoints            = [for node in local.control_nodes : node.address]
}

resource "talos_cluster_kubeconfig" "talos" {
  client_configuration = talos_machine_secrets.cluster.client_configuration
  endpoint             = var.k8s_vip
  node                 = local.control_nodes[0].address
  depends_on = [
    talos_machine_bootstrap.talos,
  ]
}

resource "talos_machine_configuration_apply" "control" {
  count                       = var.vm_config["control"].count
  client_configuration        = talos_machine_secrets.cluster.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control.machine_configuration
  endpoint                    = local.control_nodes[count.index].address
  node                        = local.control_nodes[count.index].address
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = local.control_nodes[count.index].name
        }
      }
    })
  ]
  depends_on = [
    proxmox_virtual_environment_vm.talos_control_plane,
  ]
}

// see https://registry.terraform.io/providers/siderolabs/talos/0.6.1/docs/resources/machine_configuration_apply
resource "talos_machine_configuration_apply" "worker" {
  count                       = var.vm_config["worker"].count
  client_configuration        = talos_machine_secrets.cluster.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  endpoint                    = local.worker_nodes[count.index].address
  node                        = local.worker_nodes[count.index].address
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = local.worker_nodes[count.index].name
        }
      }
    }),
  ]
  depends_on = [
    proxmox_virtual_environment_vm.talos_worker,
  ]
}

resource "talos_machine_configuration_apply" "gpu" {
  count                       = 1
  client_configuration        = talos_machine_secrets.cluster.client_configuration
  machine_configuration_input = data.talos_machine_configuration.gpu.machine_configuration
  endpoint                    = local.gpu_node.address
  node                        = local.gpu_node.address
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = local.gpu_node.name
        }
      }
    }),
    file("${path.module}/templates/nvidia-default-runtimeclass.yaml")
  ]
  depends_on = [
    proxmox_virtual_environment_vm.talos_gpu,
  ]
}

resource "talos_machine_bootstrap" "talos" {
  client_configuration = talos_machine_secrets.cluster.client_configuration
  endpoint             = local.control_nodes[0].address
  node                 = local.control_nodes[0].address
  depends_on = [
    talos_machine_configuration_apply.control
  ]
}
