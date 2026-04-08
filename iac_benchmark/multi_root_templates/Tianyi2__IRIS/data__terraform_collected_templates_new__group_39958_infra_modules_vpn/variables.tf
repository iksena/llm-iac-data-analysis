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

variable "ubuntu_image" {
  description = "Ubuntu Cloud Image ID"
  type        = string
}

variable "dns_name" {
  description = "VPN server dns"
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "IP adress of VPN VM"
  type        = string
}

variable "vm_config" {
  description = "Configuration for VPN node VMs"
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
    cpu = 1
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
      datastore_id = "local-lvm"
      file_format  = "raw"
      type         = "4m"
    }
    memory  = 2048
    network = "vmbr0"
  }
}
