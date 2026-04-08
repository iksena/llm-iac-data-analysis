
module "roles" {
  # source = "../../../../sergelogvinov/terraform-proxmox-kubernetes-roles"
  source = "github.com/sergelogvinov/terraform-proxmox-kubernetes-roles"

  tokens = true
}
