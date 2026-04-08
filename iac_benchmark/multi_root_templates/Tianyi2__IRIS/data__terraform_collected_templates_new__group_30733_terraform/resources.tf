# =============================================================================
# EC2 INSTANCES AND TLS KEYS / INSTANCES EC2 ET CLÉS TLS
# =============================================================================
# This file defines:
# - Ansible control server with automation tools
# - Web server running Apache2
# - TLS private keys for secure inter-server communication
#
# Ce fichier définit :
# - Serveur de contrôle Ansible avec outils d'automatisation
# - Serveur web exécutant Apache2
# - Clés privées TLS pour la communication sécurisée inter-serveurs
# =============================================================================

# =============================================================================
# ANSIBLE CONTROL SERVER / SERVEUR DE CONTRÔLE ANSIBLE
# =============================================================================

# Ansible control server for infrastructure automation
# Serveur de contrôle Ansible pour l'automatisation de l'infrastructure
resource "aws_instance" "ansible-tm" {
  ami                    = data.aws_ami.main.id         # Latest Debian 12 AMI / Dernière AMI Debian 12
  instance_type          = var.instance_type            # Instance type from variables / Type d'instance depuis les variables
  key_name               = aws_key_pair.main.key_name   # Main SSH key for access / Clé SSH principale pour l'accès
  vpc_security_group_ids = [aws_security_group.main.id] # Security group for network access / Groupe de sécurité pour l'accès réseau

  # EBS root volume configuration / Configuration du volume racine EBS
  root_block_device {
    volume_type = "gp3"         # General Purpose SSD v3 / SSD polyvalent v3
    volume_size = var.disk_size # Size from variables / Taille depuis les variables
    encrypted   = true          # Encrypt volume for security / Chiffrer le volume pour la sécurité
  }

  # Instance tags for identification / Tags d'instance pour l'identification
  tags = {
    Name = "${var.name_machine_prefix}-ansible-tm"
    Type = "ansible-tm"
  }

  # Cloud-init configuration to add Ansible's SSH key
  # Configuration cloud-init pour ajouter la clé SSH d'Ansible
  user_data = <<-EOF
    #cloud-config
    ssh_authorized_keys:
      - ${tls_private_key.ansible-tm.public_key_openssh}
  EOF

  # Install Ansible and configure SSH keys for web server access
  # Installation d'Ansible et configuration des clés SSH pour l'accès au serveur web
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",                                                                         # Update package lists / Mise à jour des listes de paquets
      "sudo apt-get install -y ansible",                                                                # Install Ansible automation tool / Installation de l'outil d'automatisation Ansible
      "echo '${tls_private_key.web-apache-tm.public_key_openssh}' >> /home/admin/.ssh/authorized_keys", # Add web server key / Ajouter la clé du serveur web
      "mkdir -p /home/admin/ansible",                                                                   # Create Ansible directory / Créer le répertoire Ansible
      "mkdir -p /home/admin/.ssh",                                                                      # Ensure SSH directory exists / S'assurer que le répertoire SSH existe
      "echo '${tls_private_key.web-apache-tm.private_key_pem}' > /home/admin/.ssh/web-apache-tm-key",   # Save web server private key / Sauvegarder la clé privée du serveur web
      "chmod 600 /home/admin/.ssh/web-apache-tm-key",                                                   # Secure key permissions / Sécuriser les permissions de la clé
      "chown admin:admin /home/admin/.ssh/web-apache-tm-key",                                           # Set correct ownership / Définir la propriété correcte
      "chown admin:admin /home/admin/ansible"                                                           # Set directory ownership / Définir la propriété du répertoire
    ]

    # SSH connection configuration for provisioner
    # Configuration de connexion SSH pour le provisioner
    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")}")
      host        = self.public_ip
    }
  }

  # Copy dynamically generated Ansible inventory with correct IPs
  # Copie de l'inventaire Ansible généré dynamiquement avec les bonnes IPs
  provisioner "file" {
    content = templatefile("${path.module}/ansible/host.ini.tpl", {
      web_apache_ip = aws_instance.web-apache-tm.public_ip
    })
    destination = "/home/admin/ansible/host.ini"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")}")
      host        = self.public_ip
    }
  }

  # Copy Ansible playbook for Apache installation
  # Copie du playbook Ansible pour l'installation d'Apache
  provisioner "file" {
    source      = "${path.module}/ansible/playbook.yml"
    destination = "/home/admin/ansible/playbook.yml"

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")}")
      host        = self.public_ip
    }
  }

  # Execute Ansible playbook to configure web server
  # Exécution du playbook Ansible pour configurer le serveur web
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/admin/ansible/*.yml",          # Make playbooks executable / Rendre les playbooks exécutables
      "chown -R admin:admin /home/admin/ansible",    # Set correct ownership / Définir la propriété correcte
      "ls -la /home/admin/ansible",                  # List files for verification / Lister les fichiers pour vérification
      "cd /home/admin/ansible",                      # Change to Ansible directory / Changer vers le répertoire Ansible
      "sleep 30",                                    # Wait for web server to be ready / Attendre que le serveur web soit prêt
      "ansible-playbook -i host.ini playbook.yml -v" # Run playbook with verbose output / Exécuter le playbook avec sortie détaillée
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")}")
      host        = self.public_ip
    }
  }

  # Ensure dependencies are created first / S'assurer que les dépendances sont créées en premier
  depends_on = [tls_private_key.ansible-tm, tls_private_key.web-apache-tm, aws_instance.web-apache-tm]
}

# =============================================================================
# TLS KEYS FOR ANSIBLE SERVER / CLÉS TLS POUR LE SERVEUR ANSIBLE
# =============================================================================

# Generate private key for Ansible server authentication
# Génération de la clé privée pour l'authentification du serveur Ansible
resource "tls_private_key" "ansible-tm" {
  algorithm = "RSA"
  rsa_bits  = 2048 # Standard RSA key size / Taille de clé RSA standard
}

# Create AWS key pair for Ansible server
# Création de la paire de clés AWS pour le serveur Ansible
resource "aws_key_pair" "ansible-tm" {
  key_name   = "ansible-tm-key"
  public_key = tls_private_key.ansible-tm.public_key_openssh
}

# =============================================================================
# WEB SERVER INSTANCE / INSTANCE DU SERVEUR WEB
# =============================================================================

# Apache web server instance
# Instance du serveur web Apache
resource "aws_instance" "web-apache-tm" {
  ami                    = data.aws_ami.main.id         # Latest Debian 12 AMI / Dernière AMI Debian 12
  instance_type          = var.instance_type            # Instance type from variables / Type d'instance depuis les variables
  key_name               = aws_key_pair.main.key_name   # Main SSH key for access / Clé SSH principale pour l'accès
  vpc_security_group_ids = [aws_security_group.main.id] # Security group for web traffic / Groupe de sécurité pour le trafic web

  # EBS root volume configuration / Configuration du volume racine EBS
  root_block_device {
    volume_type = "gp3"         # General Purpose SSD v3 / SSD polyvalent v3
    volume_size = var.disk_size # Size from variables / Taille depuis les variables
    encrypted   = true          # Encrypt volume for security / Chiffrer le volume pour la sécurité
  }

  # Cloud-init configuration to add web server's SSH key
  # Configuration cloud-init pour ajouter la clé SSH du serveur web
  user_data = <<-EOF
    #cloud-config
    ssh_authorized_keys:
      - ${tls_private_key.web-apache-tm.public_key_openssh}
  EOF

  # Allow Ansible server to connect via SSH
  # Permettre au serveur Ansible de se connecter via SSH
  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.ansible-tm.public_key_openssh}' >> /home/admin/.ssh/authorized_keys" # Add Ansible's public key / Ajouter la clé publique d'Ansible
    ]

    # SSH connection configuration for provisioner
    # Configuration de connexion SSH pour le provisioner
    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")}")
      host        = self.public_ip
    }
  }

  # Instance tags for identification / Tags d'instance pour l'identification
  tags = {
    Name = "${var.name_machine_prefix}-web-apache-tm"
    Type = "web-apache-tm"
  }

  # Ensure TLS keys are created first / S'assurer que les clés TLS sont créées en premier
  depends_on = [tls_private_key.ansible-tm, tls_private_key.web-apache-tm]
}

# =============================================================================
# TLS KEYS FOR WEB SERVER / CLÉS TLS POUR LE SERVEUR WEB
# =============================================================================

# Generate private key for web server authentication
# Génération de la clé privée pour l'authentification du serveur web
resource "tls_private_key" "web-apache-tm" {
  algorithm = "RSA"
  rsa_bits  = 2048 # Standard RSA key size / Taille de clé RSA standard
}

# Create AWS key pair for web server
# Création de la paire de clés AWS pour le serveur web
resource "aws_key_pair" "web-apache-tm" {
  key_name   = "web-apache-tm-key"
  public_key = tls_private_key.web-apache-tm.public_key_openssh
}
