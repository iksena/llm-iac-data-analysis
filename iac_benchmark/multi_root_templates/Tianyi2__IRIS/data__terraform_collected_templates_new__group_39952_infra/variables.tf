variable "proxmox_endpoint" {
  description = "Proxmox host endpoint"
  type        = string
}

variable "proxmox_primary_node" {
  description = "Proxmox primary node name"
  type        = string
}

variable "proxmox_secondary_node" {
  description = "Proxmox rimary node name"
  type        = string
}

variable "proxmox_storage_node" {
  description = "Proxmox node used for storage services (e.g. Samba)"
  type        = string
}

variable "base_domain" {
  description = "Base domain that will be serving the cluster"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^([a-zA-Z0-9][-a-zA-Z0-9]*\\.)+[a-zA-Z]{2,}$", var.base_domain)) || var.base_domain == ""
    error_message = "'base_domain' must be a valid domain name or an empty string."
  }
}

variable "dns_subzone_records" {
  description = "Map of DNS subzones to IPv4 addresses for explicit A records"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for ip in values(var.dns_subzone_records) : can(cidrhost("${ip}/32", 0))])
    error_message = "All dns_subzone_records values must be valid IPv4 addresses"
  }
}


variable "acme_email" {
  description = "Email to use for ACME registration"
  type        = string
}

variable "acme_server" {
  description = "ACME server URL to use for certificate issuance"
  default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
  type        = string
}



variable "cluster_name" {
  description = "Cluster name"
  type        = string
}



variable "cluster_ip_range" {
  description = "Range of IPs available for cluster VMs in CIDR format"
  type        = string

  validation {
    condition     = can(cidrhost(var.cluster_ip_range, 1))
    error_message = "cluster_ip_range must be a valid CIDR range"
  }

  validation {
    condition     = can(cidrhost(var.cluster_ip_range, var.talos_vm_config.control.count + var.talos_vm_config.worker.count + 4))
    error_message = "'cluster_ip_range' does not have enough usable IPs for the configuration"
  }
}



variable "cluster_network_gateway" {
  description = "The IP network gateway of the cluster nodes"
  type        = string
  default     = "192.168.1.1"
}


variable "environment" {
  description = "Environment name (e.g dev/staging/prod)"
  type        = string
}

variable "talos_version" {
  description = "Version of Talos to deploy"
  type        = string
  default     = "v1.9.5"
}

variable "k8s_version" {
  type        = string
  description = "Version of Kubenetes to deploy"
  default     = "1.32.1"
  validation {
    condition     = can(regex("^\\d+(\\.\\d+)+", var.k8s_version))
    error_message = "must be a version number"
  }
}

variable "talos_vm_config" {
  description = "Configuration for worker and control node VMs"
  type = map(object({
    count = number
    cpu   = number
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
  }))
}

variable "talos_gpu_vm_config" {
  description = "Configuration for GPU node VMs"
  type = object({
    enabled = bool
    cpu     = number
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
    hostpci = object({
      device = string
      id     = string
      pcie   = bool
    })
    memory  = number
    network = string
  })
}

variable "ubuntu_version" {
  description = "Version of Ubuntu to deploy for VPN/DNS/Samba VMs"
  type        = string
  default     = "24.04"
}

variable "arch_version" {
  description = "Version of Arch Linux to deploy for Devbox VM"
  type        = string
  default     = "latest"
}

variable "vpn_vm_config" {
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

variable "dns_vm_config" {
  description = "Configuration for DNS node VMs"
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

variable "samba_vm_config" {
  description = "Configuration for Samba VM"
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
    memory  = 4096
    network = "vmbr0"
  }
}

variable "samba_guest_user" {
  description = "Samba guest user"
  type        = string
  default     = "guest"
}

variable "samba_admin_user" {
  description = "Samba admin user"
  type        = string
  default     = "admin"
}

variable "samba_storage_path" {
  description = "Filesystem path exported by Samba"
  type        = string
  default     = "/mnt"
}

variable "samba_directories" {
  description = "Directories to expose via Samba under the storage path"
  type = list(object({
    name   = string
    public = bool
  }))
  default = [
    {
      name   = "public"
      public = true
    },
    {
      name   = "private"
      public = false
    },
    {
      name   = "backups"
      public = false
    }
  ]
}

variable "samba_data_disk" {
  description = "Data disk configuration for Samba storage"
  type = object({
    datastore_id = string
    size         = number
    interface    = string
    ssd          = bool
    discard      = string
    file_format  = string
  })
  default = {
    datastore_id = "data-lvm"
    size         = 4000
    interface    = "scsi1"
    ssd          = true
    discard      = "on"
    file_format  = "raw"
  }
}

variable "devbox_vm_config" {
  description = "Configuration for Dev VM"
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
      datastore_id = "data-lvm"
      interface    = "scsi0"
      iothread     = true
      ssd          = true
      discard      = "on"
      size         = 120
      file_format  = "raw"
    }
    efi_disk = {
      datastore_id = "local"
      file_format  = "raw"
      type         = "4m"
    }
    memory  = 4096
    network = "vmbr0"
  }
}

variable "devbox_admin_user" {
  description = "Devbox admin user"
  type        = string
  default     = "admin"
}
