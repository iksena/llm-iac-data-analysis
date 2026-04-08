provider "digitalocean" {
  token = var.api_token
}

# Add a random suffix to the SSH key name for uniqueness in DigitalOcean
resource "random_id" "ssh_key_name_suffix" {
  byte_length = 4
}

# New SSH Key resource using the public key content from variable
resource "digitalocean_ssh_key" "primus_redir_key" {
  name       = "primusredir-key-${random_id.ssh_key_name_suffix.hex}"
  public_key = var.ssh_public_key_content
}


# Droplet
resource "digitalocean_droplet" "redirector" {
  image              = "ubuntu-24-04-x64"
  name               = "C2-Redirector"
  region             = "FRA1"
  size               = "s-1vcpu-1gb"
  monitoring         = true
  private_networking = true
  ssh_keys = [digitalocean_ssh_key.primus_redir_key.id]


  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/primus_redir_id_rsa")
    host        = digitalocean_droplet.redirector.ipv4_address
    }

  provisioner "file" {
    source      = "redir"
    destination = "/opt/redir"
  }


  provisioner "remote-exec" {
  inline = [
    "sed -i -r 's/^#.*_forward.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf",
    "sed -i -r 's/^#.*[.]forward.*/net.ipv6.conf.all.forwarding=1/' /etc/sysctl.conf",
    "sysctl -p",
    "echo 1 > /proc/sys/net/ipv4/ip_forward",
    "echo 1 > /proc/sys/net/ipv6/conf/all/forwarding"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /opt/redir/http_script.sh",
      "bash /opt/redir/http_script.sh",
      "sleep 5",
      "/bin/bash -c 'cd /opt/redir && nohup screen -S Caddy -dm docker-compose up'",
      "sleep 1"
      
    ]

  }

  provisioner "file" {
  content = local.server_template
  destination = "/etc/wireguard/wg0.conf"
  }


  provisioner "remote-exec" {
    inline = [
      "systemctl enable wg-quick@wg0",
      "systemctl start wg-quick@wg0",
      "sleep 1"
    ]
}
    
}

output "droplet_ip_address" {
  value = digitalocean_droplet.redirector.ipv4_address
}

resource "digitalocean_firewall" "redirector" {
  name = "22-80-443-51820"

  droplet_ids = [digitalocean_droplet.redirector.id]

    inbound_rule {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0", "::/0"]
  }

    inbound_rule {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
  }

    inbound_rule {
    protocol         = "udp"
    port_range       = "51820"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

    inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

      
}


data "cloudflare_zone" "this" {
  filter = {
    name = "DOMAIN"
  }
}

resource "cloudflare_dns_record" "foobar" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "SUB"
  type    = "A"
  content = digitalocean_droplet.redirector.ipv4_address
  proxied = false
  ttl = 1
}

output "record" {
  value = "${cloudflare_dns_record.foobar.name}.${data.cloudflare_zone.this.name}"
}


