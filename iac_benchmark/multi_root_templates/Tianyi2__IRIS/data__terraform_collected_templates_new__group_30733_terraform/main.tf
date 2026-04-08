# =============================================================================
# MAIN TERRAFORM CONFIGURATION / CONFIGURATION PRINCIPALE TERRAFORM
# =============================================================================
# This file contains the main infrastructure components:
# - SSH key generation and management
# - Security groups configuration
# - AMI data source for Debian 12
#
# Ce fichier contient les composants principaux de l'infrastructure :
# - Génération et gestion des clés SSH
# - Configuration des groupes de sécurité
# - Source de données AMI pour Debian 12
# =============================================================================

# =============================================================================
# SSH KEY GENERATION / GÉNÉRATION DES CLÉS SSH
# =============================================================================

# Generate main SSH private key (4096 bits for enhanced security)
# Génération de la clé SSH privée principale (4096 bits pour une sécurité renforcée)
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096 # Higher bit count for better security / Nombre de bits plus élevé pour une meilleure sécurité
}

# Create AWS key pair from local public key file
# Création de la paire de clés AWS à partir du fichier de clé publique local
resource "aws_key_pair" "main" {
  key_name   = var.ssh_key_name
  public_key = file("~/.ssh/${var.ssh_name_public_key}")
}

# =============================================================================
# SECURITY GROUP CONFIGURATION / CONFIGURATION DU GROUPE DE SÉCURITÉ
# =============================================================================

# Main security group allowing SSH, HTTP, HTTPS and ICMP traffic
# Groupe de sécurité principal autorisant le trafic SSH, HTTP, HTTPS et ICMP
resource "aws_security_group" "main" {
  name_prefix = var.aws_security_group_prefix_name
  description = "Restricted SSH access, HTTP and HTTPS and ICMP open from internet"

  # SSH access (port 22) - Consider restricting to specific IPs in production
  # Accès SSH (port 22) - Considérer la restriction à des IPs spécifiques en production
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all - modify for production / Ouvert à tous - modifier pour la production
  }

  # HTTP access (port 80) for web server
  # Accès HTTP (port 80) pour le serveur web
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access (port 443) for secure web traffic
  # Accès HTTPS (port 443) pour le trafic web sécurisé
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP (ping) for network diagnostics
  # ICMP (ping) pour les diagnostics réseau
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  # Autoriser tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.aws_security_name
  }
}

# =============================================================================
# AMI DATA SOURCE / SOURCE DE DONNÉES AMI
# =============================================================================

# Fetch the latest Debian 12 AMI from official Debian account
# Récupération de la dernière AMI Debian 12 du compte officiel Debian
data "aws_ami" "main" {
  most_recent = true
  owners      = ["136693071363"] # Official Debian account / Compte officiel Debian

  # Filter for Debian 12 AMD64 images
  # Filtre pour les images Debian 12 AMD64
  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  # Ensure HVM virtualization type for better performance
  # Assurer le type de virtualisation HVM pour de meilleures performances
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}




