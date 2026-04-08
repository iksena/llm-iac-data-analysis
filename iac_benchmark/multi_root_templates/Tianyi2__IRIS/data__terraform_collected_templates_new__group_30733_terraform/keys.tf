# Sauvegarde locale des clés générées
resource "local_file" "ansible_private_key" {
  content         = tls_private_key.ansible-tm.private_key_pem
  filename        = "${path.module}/keys/ansible-tm-key.pem"
  file_permission = "0600"
}

resource "local_file" "web_apache_private_key" {
  content         = tls_private_key.web-apache-tm.private_key_pem
  filename        = "${path.module}/keys/web-apache-tm-key.pem"
  file_permission = "0600"
}
