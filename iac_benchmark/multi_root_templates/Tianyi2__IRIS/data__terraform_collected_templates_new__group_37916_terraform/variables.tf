variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-north1"
}

variable zone {
  description = "Zone"
  default     = "europe-north1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable "app_count" {
  default     = 1
  description = "Backend application instance count"
}

variable "app_name" {
  default = {
    "0" = "reddit-app"
    "1" = "reddit-app2"
  }
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
