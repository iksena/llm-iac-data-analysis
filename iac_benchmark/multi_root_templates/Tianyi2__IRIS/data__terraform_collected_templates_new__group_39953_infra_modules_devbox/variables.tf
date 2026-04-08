variable "proxmox_endpoint" {
  description = "Proxmox host endpoint"
  type        = string
}

variable "proxmox_node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "cluster_network_gateway" {
  description = "The IP network gateway of the cluster nodes"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g dev/staging/prod)"
  type        = string
}

variable "arch_image" {
  description = "Arch Linux Image ID"
  type        = string
}

variable "ip_address" {
  description = "IP address of devbox VM"
  type        = string
}

variable "vm_config" {
  description = "Configuration for devbox VM"
  type = object({
    cpu = number
    disk = object({
      datastore_id = string
      interface    = string
      iothread     = bool
      ssd          = bool
      discard      = string
      size         = number
      file_format  = string
    })
    efi_disk = object({
      datastore_id = string
      file_format  = string
      type         = string
    })
    memory  = number
    network = string
  })
  default = {
    cpu = 2
    disk = {
      datastore_id = "local-lvm"
      interface    = "scsi0"
      iothread     = true
      ssd          = true
      discard      = "on"
      size         = 32
      file_format  = "raw"
    }
    efi_disk = {
      datastore_id = "local"
      file_format  = "raw"
      type         = "4m"
    }
    memory  = 4048
    network = "vmbr0"
  }
}

variable "admin_user" {
  description = "devbox admin user"
  type        = string
  default     = "admin"
}

variable "samba_host" {
  description = "Samba host for devbox mounts"
  type        = string
}

variable "samba_username" {
  description = "Samba username for devbox mounts"
  type        = string
}

variable "samba_password" {
  description = "Samba password for devbox mounts"
  type        = string
  sensitive   = true
}

variable "samba_mounts" {
  description = "Samba shares to mount under /mnt/{name}"
  type = list(object({
    name  = string
    share = string
  }))
  default = []
}
