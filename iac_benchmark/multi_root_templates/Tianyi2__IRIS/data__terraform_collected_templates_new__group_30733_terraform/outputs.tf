# ============================================================================
# 🚀 INFORMATIONS DE DÉPLOIEMENT - INFRASTRUCTURE AWS
# ============================================================================

# ========================================
# 📊 RÉSUMÉ GLOBAL DU DÉPLOIEMENT
# ========================================
output "deployment_summary" {
  description = "Résumé complet du déploiement"
  value = {
    "🎯 Statut"              = "✅ Déploiement réussi"
    "🌍 Région AWS"          = var.aws_region
    "📅 Date de déploiement" = timestamp()
    "🏗️ Nombre d'instances"  = "2 (Ansible + Web Apache)"
    "💰 Type d'instance"     = var.instance_type
  }
}

# ========================================
# 🔧 SERVEUR ANSIBLE (ORCHESTRATION)
# ========================================
output "ansible_server_info" {
  description = "🔧 Informations complètes du serveur Ansible"
  value = {
    "📝 Nom"             = "Serveur Ansible (Orchestration)"
    "🆔 Instance ID"     = aws_instance.ansible-tm.id
    "🌐 IP Publique"     = aws_instance.ansible-tm.public_ip
    "🏠 IP Privée"       = aws_instance.ansible-tm.private_ip
    "🔗 DNS Public"      = aws_instance.ansible-tm.public_dns
    "📂 Dossier Ansible" = "/home/admin/ansible"
  }
}

# ========================================
# 🌐 SERVEUR WEB APACHE
# ========================================
output "web_server_info" {
  description = "🌐 Informations complètes du serveur Web Apache"
  value = {
    "📝 Nom"         = "Serveur Web Apache"
    "🆔 Instance ID" = aws_instance.web-apache-tm.id
    "🌐 IP Publique" = aws_instance.web-apache-tm.public_ip
    "🏠 IP Privée"   = aws_instance.web-apache-tm.private_ip
    "🔗 DNS Public"  = aws_instance.web-apache-tm.public_dns
    "🌍 URL du site" = "http://${aws_instance.web-apache-tm.public_ip}"
  }
}

# ========================================
# 🔐 COMMANDES DE CONNEXION SSH
# ========================================
output "ssh_connections" {
  description = "🔐 Commandes SSH pour se connecter aux serveurs"
  sensitive   = true
  value = {
    "🔧 Ansible Server" = "ssh -i ~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")} ${var.ssh_user}@${aws_instance.ansible-tm.public_ip}"
    "🌐 Web Server"     = "ssh -i ~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")} ${var.ssh_user}@${aws_instance.web-apache-tm.public_ip}"
  }
}

# ========================================
# 🎯 LIENS RAPIDES D'ACCÈS
# ========================================
output "quick_access_links" {
  description = "🎯 Liens rapides pour accéder aux services"
  value = {
    "🌍 Site Web Apache"    = "http://${aws_instance.web-apache-tm.public_ip}"
    "📊 Console AWS EC2"    = "https://console.aws.amazon.com/ec2/v2/home?region=${var.aws_region}#Instances:sort=instanceId"
    "📋 Inventaire Ansible" = "/home/admin/ansible/host.ini"
    "📖 Playbook Ansible"   = "/home/admin/ansible/playbook.yml"
  }
}

# ========================================
# ⚡ COMMANDES UTILES
# ========================================
output "useful_commands" {
  description = "⚡ Commandes utiles pour la gestion"
  value = {
    "🔄 Relancer Ansible"  = "cd /home/admin/ansible && ansible-playbook -i host.ini playbook.yml"
    "📊 Statut Apache"     = "sudo systemctl status apache2"
    "🔄 Redémarrer Apache" = "sudo systemctl restart apache2"
    "📝 Logs Apache"       = "sudo tail -f /var/log/apache2/access.log"
    "🧹 Détruire infra"    = "terraform destroy"
  }
}

# ========================================
# 📈 INFORMATIONS TECHNIQUES
# ========================================
output "technical_details" {
  description = "📈 Détails techniques de l'infrastructure"
  value = {
    "🔒 Security Group"     = aws_security_group.main.name
    "🌐 VPC"                = aws_security_group.main.vpc_id
    "🔑 Clé SSH principale" = aws_key_pair.main.key_name
    "🔑 Clé Ansible"        = aws_key_pair.ansible-tm.key_name
    "🔑 Clé Web Apache"     = aws_key_pair.web-apache-tm.key_name
    "💾 Taille disque"      = "${var.disk_size} GB"
    "🏷️ Tags déployés"      = "Name, Type"
  }
}

# ========================================
# 🎉 MESSAGE DE SUCCÈS
# ========================================
output "success_message" {
  description = "🎉 Message de succès du déploiement"
  sensitive   = true
  value       = <<-EOT

  ╔══════════════════════════════════════════════════════════════╗
  ║                    🎉 DÉPLOIEMENT RÉUSSI ! 🎉                 ║
  ╠══════════════════════════════════════════════════════════════╣
  ║                                                              ║
  ║  ✅ Votre infrastructure AWS est opérationnelle !            ║
  ║                                                              ║
  ║  🌍 Accédez à votre site web :                              ║
  ║     http://${aws_instance.web-apache-tm.public_ip}                                    ║
  ║                                                              ║
  ║  🔧 Connectez-vous au serveur Ansible :                     ║
  ║     ssh -i ~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")} admin@${aws_instance.ansible-tm.public_ip}     ║
  ║                                                              ║
  ║  💡 Consultez la documentation complète dans le README.md   ║
  ║                                                              ║
  ║  🧹 N'oubliez pas de détruire les ressources après test :   ║
  ║     terraform destroy                                        ║
  ║                                                              ║
  ╚══════════════════════════════════════════════════════════════╝

  EOT
}

# ========================================
# 🔍 OUTPUTS INDIVIDUELS (pour scripts)
# ========================================
# Outputs pour la machine ansible-tm
output "ansible-tm_instance_id" {
  description = "ID de l'instance ansible-tm"
  value       = aws_instance.ansible-tm.id
}

output "ansible-tm_public_ip" {
  description = "Adresse IP publique de l'instance ansible-tm"
  value       = aws_instance.ansible-tm.public_ip
}

output "ansible-tm_private_ip" {
  description = "Adresse IP privée de l'instance ansible-tm"
  value       = aws_instance.ansible-tm.private_ip
}

output "ansible-tm_public_dns" {
  description = "DNS public de l'instance ansible-tm"
  value       = aws_instance.ansible-tm.public_dns
}

# Commandes de connexion SSH
output "ssh_connection_ansible-tm" {
  description = "Commande pour se connecter en SSH à la machine ansible-tm"
  sensitive   = true
  value       = "ssh -i '~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")}' ${var.ssh_user}@${aws_instance.ansible-tm.public_ip}"
}

# Résumé de la machine ansible-tm
# Outputs pour la machine ansible-tm
output "web-apache-tm_instance_id" {
  description = "ID de l'instance web-apache-tm"
  value       = aws_instance.web-apache-tm.id
}

output "web-apache-tm_public_ip" {
  description = "Adresse IP publique de l'instance web-apache-tm"
  value       = aws_instance.web-apache-tm.public_ip
}

output "web-apache-tm_private_ip" {
  description = "Adresse IP privée de l'instance web-apache-tm"
  value       = aws_instance.web-apache-tm.private_ip
}

output "web-apache-tm_public_dns" {
  description = "DNS public de l'instance web-apache-tm"
  value       = aws_instance.web-apache-tm.public_dns
}

# Commandes de connexion SSH
output "ssh_connection_web-apache-tm" {
  description = "Commande pour se connecter en SSH à la machine web-apache-tm"
  sensitive   = true
  value       = "ssh -i '~/.ssh/${replace(var.ssh_name_public_key, ".pub", "")}' ${var.ssh_user}@${aws_instance.web-apache-tm.public_ip}"
}



# Résumé de toutes les machines
output "machines_summary" {
  description = "Résumé de toutes les machines créées"
  value = {
    ansible-tm = {
      id         = aws_instance.ansible-tm.id
      public_ip  = aws_instance.ansible-tm.public_ip
      private_ip = aws_instance.ansible-tm.private_ip
      type       = "ansible-tm"
    },
    web-apache-tm = {
      id         = aws_instance.web-apache-tm.id
      public_ip  = aws_instance.web-apache-tm.public_ip
      private_ip = aws_instance.web-apache-tm.private_ip
      type       = "web-apache-tm"
    }
  }
}

# ========================================
# 📱 ACCÈS MOBILE
# ========================================
output "mobile_access" {
  description = "🔗 Accès mobile avec QR code"
  value = {
    "📱 URL pour QR code" = "http://${aws_instance.web-apache-tm.public_ip}"
    "💡 Conseil"          = "Générez un QR code avec: qrencode -t PNG -o site.png 'http://${aws_instance.web-apache-tm.public_ip}'"
  }
}
