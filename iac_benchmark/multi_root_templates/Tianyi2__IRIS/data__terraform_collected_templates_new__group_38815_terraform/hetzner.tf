# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key for server access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "ducklake-deployment-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "hcloud_primary_ip" "ducklake_postgres" {
  name          = "ducklake_postgres"
  location      = "nbg1"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
}

resource "hcloud_server" "ducklake-postgres" {
  name        = "ducklake-postgres"
  image       = "ubuntu-24.04"
  server_type = "cx23" # Use "cx33" if unavailable
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.default.id]
  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.ducklake_postgres.id
    ipv6_enabled = false
  }
}
