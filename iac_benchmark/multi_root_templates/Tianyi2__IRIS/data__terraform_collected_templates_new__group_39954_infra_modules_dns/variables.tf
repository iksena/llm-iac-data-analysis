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
  default     = "192.168.1.1"
}

variable "environment" {
  description = "Environment name (e.g dev/staging/prod)"
  type        = string
}

variable "ubuntu_image" {
  description = "Ubuntu Cloud Image ID"
  type        = string
}

variable "base_domain" {
  description = "Base domain that will be serving the cluster"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^([a-zA-Z0-9][-a-zA-Z0-9]*\\.)+[a-zA-Z]{2,}$", var.base_domain)) || var.base_domain == ""
    error_message = "'base_domain' must be a valid domain name or an empty string"
  }
}

variable "subzone_records" {
  description = "Map of subzones to IPv4 addresses for explicit A records"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for ip in values(var.subzone_records) : can(cidrhost("${ip}/32", 0))])
    error_message = "All subzone_records values must be valid IPv4 addresses"
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_route53_zone_id" {
  description = "AWS Route 53 hosted zone id"
  type        = string
}


variable "aws_iam_credentials" {
  description = "AWS IAM user credentials for cert-manager"
  type = object({
    access_key_id     = string
    secret_access_key = string
  })
}


variable "ip_address" {
  description = "IP address of DNS VM instance"
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
      size         = 16
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

variable "k8s_lb_ip" {
  description = "Kubernetes load balancer IP"
  type        = string
}
