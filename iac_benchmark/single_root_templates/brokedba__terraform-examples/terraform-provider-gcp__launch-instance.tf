# ── variables.tf ────────────────────────────────────
# GCP Service account region and authentication 
# variable "prefix" {
#  description = "The prefix used for all resources in this example"
#}
variable  "gcp_credentials"{
  description = "default location of your service account json key file"
  default = "~/gcp-key.json"
}

variable "project" {
  default = "playground-s-11-f538d00c"   # Change ME
}
variable "region" {
    default = "us-east1"
}

variable "zone" {
    default = "us-east1-b"
}
# VPC INFO
    variable "vnet_name" {
      default = "Terravpc"
    }
    
    variable "subnet-02_cidr" {
      default = "192.168.0.0/16"
    }

# SUBNET INFO
    variable "subnet_name"{
      default = "terrasub" 
      }

    variable "subnet_cidr"{
      default = "192.168.10.0/24"
      } 
  variable "firewall_name" {
    default = "terra_fw"
  }

 
variable "subnetwork_project" {
  description = "The project that subnetwork belongs to"
  default     = ""
}

variable "instances_name" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  default     = "terravm"
}

variable "admin" {
  description = "OS user"
  default  = "centos"
}

# VNIC INFO
        variable "private_ip" {
        default = "192.168.10.51"
      }
      
# BOOT INFO      
  # user data
variable "user_data" { 
  default = "./cloud-init/centos_userdata.txt"
  }     

 


variable "hostname" {
  description = "Hostname of instances"
  default     = "terrahost.brokedba.com"
}
  

# COMPUTE INSTANCE INFO

      variable "instance_name" {
        default = "TerraCompute"
      }


      variable "osdisk_size" {
        default = "30"
      }
      variable "vm_type" {   # gcloud compute machine-types list --filter="zone:us-east1-b and name:e2-micro"
        default = "e2-micro" #"f1-micro"
      }
variable "OS" {     # gcloud compute images list --filter=name:ubuntu
  description = "the selected ami based OS"
  default       = "CENTOS7" 
}

variable  "os_image" {
  default = {
    CENTOS7 = {
           name = "centos-cloud/centos-7"
          
        },
    RHEL7  =  {
          name = "rhel-cloud/rhel-7"
    
        },
    WINDOWS    =  {
       
        },
    SUSE       =  {
          name = "suse-cloud/sles-15"
 
        },
    UBUNTU       =  {
          name = "ubuntu-os-cloud/ubuntu-2004-lts"
  
        }

       }
     }  



# ── outputs.tf ────────────────────────────────────
output "vpc_name" {
  description = "The Name of the newly created vpc"
  value       = google_compute_network.terra_vpc.name
}
#output "vpc_id" {
#      description = "id of created vpc. "
#      value       = google_compute_network.terra_vpc.id
#    } 
    
output "Subnet_Name" {
      description = "Name of created vpc's Subnet. "
      value       =  google_compute_subnetwork.terra_sub.name
    }
output "Subnet_id" {
      description = "id of created vpc. "
      value       = google_compute_subnetwork.terra_sub.id
    }
output "Subnet_CIDR" {
      description = "cidr block of vpc's Subnet. "
      value       = google_compute_subnetwork.terra_sub.ip_cidr_range
    }

output "fire_wall_rules" {
      description = "Shows ingress rules of the Security group "
     value       = google_compute_firewall.web-server.allow
}         
    
##  INSTANCE OUTPUT

      output "instance_name" {
        description = " id of created instances. "
        value       = google_compute_instance.terra_instance.name
      }

      output "hostname" {
        description = " id of created instances. "
        value       = google_compute_instance.terra_instance.hostname
      }
      
      output "private_ip" {
        description = "Private IPs of created instances. "
        value       = google_compute_instance.terra_instance.network_interface.0.network_ip
      }
      
      output "public_ip" {
        description = "Public IPs of created instances. "
        value       = google_compute_instance.terra_instance.network_interface.0.access_config.0.nat_ip
      }

 output "SSH_Connection" {
     value      = format("ssh connection to instance  ${var.instance_name} ==> sudo ssh -i ~/id_rsa_gcp  ${var.admin}@%s",google_compute_instance.terra_instance.network_interface.0.access_config.0.nat_ip)
}

  
  
    

# ── compute.tf ────────────────────────────────────
 provider "google" {
    credentials = file(var.gcp_credentials)
    project = var.project 
    region  = var.region
    zone    = var.zone
  }
#####################  
# PROJECT DATA SOURCE
#####################

data "google_client_config" "current" {

}
#variable "project_id" {
#  default = data.google_client_config.current.project 
#}
#############
# Instances
#############

 resource "google_compute_instance" "terra_instance" {
  name     = var.instances_name
  hostname = var.hostname
  project  = data.google_client_config.current.project
  zone     = var.zone 
  machine_type = var.vm_type
  
  metadata = {
   ssh-keys = "${var.admin}:${file("~/id_rsa_gcp.pub")}"   # Change Me
    startup-script        = ("${file(var.user_data)}")
  #  startup-script-custom = "stdlib::info Hello World"
  }
  network_interface {
    network            = google_compute_network.terra_vpc.self_link
    subnetwork         = google_compute_subnetwork.terra_sub.self_link
    subnetwork_project = data.google_client_config.current.project 
    network_ip         = var.private_ip
  access_config {
      // Include this section to give the VM an external ip address
   }
 }
 
  depends_on = [data.google_client_config.current]
######################
# IMAGE
######################
 
  boot_disk {
    initialize_params {
      image = var.os_image[var.OS].name      #"debian-cloud/debian-9"
    }
  }
 # scratch_disk {
  #  interface = "SCSI"
  #}

scheduling {
  on_host_maintenance = "MIGRATE"
  automatic_restart   =  true
}


# service account
  service_account {
    scopes = ["https://www.googleapis.com/auth/compute.readonly"]
  }
 tags = ["web-server"]
} 
 
######################
# ADDRESS
######################
# Reserving a static internal IP address 
resource "google_compute_address" "internal_reserved_subnet_ip" {
  name         = "internal-address"
  subnetwork   = google_compute_subnetwork.terra_sub.id
  address_type = "INTERNAL"
  address      = var.private_ip
  region       = var.region
}

#resource "google_compute_address" "static" {
#  name = "ipv4-address"
#}
 
  
output "ip" {
 value = google_compute_instance.terra_instance.network_interface.0.access_config.0.nat_ip
}

  
  






# ── vpc.tf ────────────────────────────────────
############################
# SERVICE ACCOUNT (OPTIONAL)
############################
# Note: The user running terraform needs to have the IAM Admin role assigned to them before you can do this.
# resource "google_service_account" "instance_admin" { 
#  account_id   = "instance-admin"
#  display_name = "instance s-account"
#  }
# resource "google_project_iam_binding" "instance_sa_iam" {
#  project = data.google_client_config.current.project # < PROJECT ID>
#  role    = "roles/compute.instanceAdmin.v1"
#  members = [
#    "serviceAccount:${google_service_account.instance_admin.email}"
#  ]

#################
# VPC
#################

resource "google_compute_network" "terra_vpc" {
    project   = data.google_client_config.current.project 
    name = "terra-vpc"
    auto_create_subnetworks = false
    mtu                     = 1460 
    }

#################
# SUBNET
#################
resource "google_compute_subnetwork" "terra_sub" {
  name          = "terra-sub"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.terra_vpc.name
  description   = "This is a custom subnet "
  private_ip_google_access = "true"
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }   

    secondary_ip_range {
                range_name    = "subnet-01-secondary-01"
                ip_cidr_range = "192.168.64.0/24"
            }
        

}
######################
# Firewall
######################    
# web network tag
resource "google_compute_firewall" "web-server" {
  project     = data.google_client_config.current.project  # you can Replace this with your project ID in quotes var.project_id
  name        = "allow-http-rule"
  network     = google_compute_network.terra_vpc.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["80","22","443","3389"]
         }
   source_ranges = ["0.0.0.0/0"]
   target_tags = ["web-server"]
    timeouts {}
}

output "project" {
  value = "${data.google_client_config.current.project}"
}