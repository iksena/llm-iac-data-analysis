# =============================================================================
# TERRAFORM VARIABLES CONFIGURATION / CONFIGURATION DES VARIABLES TERRAFORM
# =============================================================================
# This file defines all variables used in the Terraform configuration
# Ce fichier définit toutes les variables utilisées dans la configuration Terraform

# =============================================================================
# AWS API CONFIGURATION / CONFIGURATION DE L'API AWS
# =============================================================================

# AWS Access Key ID for authentication / Clé d'accès AWS pour l'authentification
variable "aws_access_key_id" {
  description = "AWS Access Key ID / Clé d'accès AWS"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.aws_access_key_id) > 0
    error_message = "AWS Access Key ID cannot be empty / AWS Access Key ID ne peut pas être vide."
  }
}

# AWS Secret Access Key for authentication / Clé secrète AWS pour l'authentification
variable "aws_secret_access_key" {
  description = "AWS Secret Access Key / Clé secrète AWS"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.aws_secret_access_key) > 0
    error_message = "AWS Secret Access Key cannot be empty / AWS Secret Access Key ne peut pas être vide."
  }
}

# AWS Region where resources will be deployed / Région AWS où les ressources seront déployées
variable "aws_region" {
  description = "AWS Region / Région AWS"
  type        = string
  default     = "eu-west-3" # Paris region / Région de Paris
}

# =============================================================================
# SSH KEY CONFIGURATION / CONFIGURATION DES CLÉS SSH
# =============================================================================

# Public SSH key file name for instance access / Nom du fichier de clé publique SSH pour l'accès aux instances
variable "ssh_name_public_key" {
  description = "Public SSH key for instance access / Clé publique SSH pour l'accès à l'instance"
  type        = string
  sensitive   = true
}

# SSH key pair name in AWS / Nom de la paire de clés SSH dans AWS
variable "ssh_key_name" {
  description = "SSH key name / Nom de la clé SSH"
  type        = string
  default     = "id_rsa"
}

# =============================================================================
# EC2 INSTANCE CONFIGURATION / CONFIGURATION DES INSTANCES EC2
# =============================================================================

# EC2 instance type (t2.micro is free tier eligible) / Type d'instance EC2 (t2.micro est éligible au niveau gratuit)
variable "instance_type" {
  description = "EC2 instance type / Type d'instance EC2"
  type        = string
  default     = "t2.micro" # Free tier eligible / Éligible niveau gratuit

  validation {
    condition     = length(var.instance_type) > 0
    error_message = "Instance type cannot be empty / Le type d'instance ne peut pas être vide."
  }
}

# EBS volume size in GB (8-20 GB for free tier) / Taille du volume EBS en Go (8-20 Go pour le niveau gratuit)
variable "disk_size" {
  description = "Disk size in GB / Taille du disque en Go"
  type        = number
  default     = 20

  validation {
    condition     = var.disk_size >= 8 && var.disk_size <= 20
    error_message = "Disk size must be between 8 and 20 GB / La taille du disque doit être entre 8 et 20 Go."
  }
}

# SSH username for remote connections / Nom d'utilisateur SSH pour les connexions distantes
variable "ssh_user" {
  description = "SSH username for remote connections / Nom d'utilisateur pour la connexion SSH"
  type        = string
  default     = "admin" # Default user for Debian AMI / Utilisateur par défaut pour l'AMI Debian

  validation {
    condition     = length(var.ssh_user) > 0
    error_message = "SSH username cannot be empty / Le nom d'utilisateur SSH ne peut pas être vide."
  }
}

# =============================================================================
# SECURITY GROUP CONFIGURATION / CONFIGURATION DU GROUPE DE SÉCURITÉ
# =============================================================================

# Security group name prefix / Préfixe du nom du groupe de sécurité
variable "aws_security_group_prefix_name" {
  description = "Security group name prefix / Préfixe du nom du groupe de sécurité"
  type        = string
  default     = "main-sg"

  validation {
    condition     = length(var.aws_security_group_prefix_name) > 0
    error_message = "Security group prefix cannot be empty / Le préfixe du nom du groupe de sécurité ne peut pas être vide."
  }
}

# Security group display name / Nom d'affichage du groupe de sécurité
variable "aws_security_name" {
  description = "Security group display name / Nom du groupe de sécurité"
  type        = string
  default     = "main-security-group"

  validation {
    condition     = length(var.aws_security_name) > 0
    error_message = "Security group name cannot be empty / Le nom du groupe de sécurité ne peut pas être vide."
  }
}

# =============================================================================
# NAMING CONFIGURATION / CONFIGURATION DU NOMMAGE
# =============================================================================

# Prefix for machine names / Préfixe pour le nom des machines
variable "name_machine_prefix" {
  description = "Prefix for machine names / Préfixe du nom de la machine"
  type        = string
  default     = "ec2-instance"
}

# Chemin vers le dossier Ansible local
variable "ansible_local_path" {
  description = "Chemin vers le dossier Ansible local"
  type        = string
  default     = "./ansible"
}
