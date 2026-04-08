variable "api_token" {
  description = "DigitalOcean API token. Patched by PrimusRedir config()."
  type        = string
  default     = "DO-API-KEY"
}

variable "wireguard_private_key" {
  description = "WireGuard server private key (list containing one key). Patched by PrimusRedir gen_conf()."
  type        = list(string)
  default     = ["SERVER-PRIVATE-KEY"] # Placeholder string inside the list
}

variable "pubkeys" {
  description = "List of WireGuard client public keys. Placeholder patched by PrimusRedir gen_conf()."
  type        = list(string)
  default     = ["CLIENT-PUB-KEY"]
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API key. Patched by PrimusRedir config()."
  default     = "CLOUDFLARE-API-KEY"
}

variable "ssh_public_key_content" {
  description = "Content of the SSH public key for VPS access. Patched by PrimusRedir gen_conf()."
  type        = string
  default     = "SSH-PUBLIC-KEY-CONTENT-PLACEHOLDER"
}


