# ── main.tf ────────────────────────────────────
provider "vault" {
  address = "http://localhost:8200"
  token   = "root"
}

resource "vault_mount" "kvv2" {
  path        = var.secret_mount_path
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"

  depends_on = [ docker_container.vault ]
}

# Create a KV v2 secret backend
resource "vault_kv_secret_backend_v2" "main" {
  mount        = vault_mount.kvv2.path
  cas_required = false
  max_versions = 10
}

# Create a secret with burrito recipe
resource "vault_kv_secret_v2" "burrito_recipe" {
  mount                = vault_kv_secret_backend_v2.main.mount
  name                 = "burrito-recipe"
  data_json_wo         = jsonencode(var.burrito_recipe)
  data_json_wo_version = var.burrito_recipe_version
}

# ── variables.tf ────────────────────────────────────
variable "burrito_recipe" {
  description = "Secret information for the burrito recipe"
  type = object({
    ingredients  = string
    instructions = string
    chef_notes   = optional(string, "")
  })

  sensitive = true
  ephemeral = true
}

variable "burrito_recipe_version" {
  description = "Version of the burrito recipe secret"
  type        = number

  validation {
    condition     = var.burrito_recipe_version > 0 && var.burrito_recipe_version == floor(var.burrito_recipe_version)
    error_message = "The burrito_recipe_version must be a non-negative integer."
  }

}

variable "secret_mount_path" {
  description = "Mount path for the Vault KV v2 secret engine"
  type        = string
  default     = "secret"
}


# ── outputs.tf ────────────────────────────────────


# ── main.vault.tf ────────────────────────────────────
provider "docker" {}

resource "docker_image" "vault" {
  name         = "hashicorp/vault:1.20"
  keep_locally = true
}

resource "docker_container" "vault" {
  name  = "vault"
  image = docker_image.vault.name
  wait  = true

  ports {
    internal = 8200
    external = 8200
  }

  env = [
    "VAULT_DEV_ROOT_TOKEN_ID=root",
    "VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200"
  ]

  command = ["server", "-dev"]

  healthcheck {
    test     = ["CMD", "vault", "status", "-address=http://localhost:8200"]
    interval = "10s"
    timeout  = "5s"
    retries  = 3
  }
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = ">= 1.11.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}