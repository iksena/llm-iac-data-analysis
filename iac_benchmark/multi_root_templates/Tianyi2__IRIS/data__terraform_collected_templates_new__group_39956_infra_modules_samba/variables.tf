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

variable "ip_address" {
  description = "IP address of Samba VM"
  type        = string
}

variable "vm_config" {
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
    memory  = 4048
    network = "vmbr0"
  }
}

variable "guest_user" {
  description = "Samba guest user"
  type        = string
  default     = "guest"
}

variable "admin_user" {
  description = "Samba admin user"
  type        = string
  default     = "admin"
}

variable "storage_path" {
  description = "Filesystem path exported by Samba"
  type        = string
  default     = "/mnt"
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
    datastore_id = "local-lvm"
    size         = 256
    interface    = "scsi1"
    ssd          = true
    discard      = "on"
    file_format  = "raw"
  }
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
    }
  ]
}
