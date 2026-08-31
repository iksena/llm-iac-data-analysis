output "lightsail_instances" {
  value = { for v in aws_lightsail_instance.this : v.name => {
    id                 = v.id
    arn                = v.arn
    created_at         = v.created_at
    ipv6_addresses     = v.ipv6_addresses
    private_ip_address = v.private_ip_address
    public_ip_address  = v.public_ip_address
    username           = v.username
    tags               = v.tags_all
    }
  }

  description = "The created Lightsail instances."
}

output "static_ips" {
  value = { for v in aws_lightsail_static_ip.this : v.name => {
    arn        = v.arn
    ip_address = v.ip_address
    }
  }

  description = "The list of static ips."
}

output "key_pair" {
  value = try(aws_lightsail_key_pair.this[0].id, null)
}

output "key_pair_public" {
  value = try(aws_lightsail_key_pair.this[0].public_key, "")
}
