##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "zones" {
  value = {
    for v in aws_route53_zone.this :
    v.name => {
      id           = v.zone_id
      arn          = v.arn
      name         = v.name
      name_servers = v.name_servers
    }
  }
}

output "resolver_rules" {
  value = {
    inbound = {
      for rr in aws_route53_resolver_rule.inbound_rules :
      rr.name => {
        id                   = rr.id
        arn                  = rr.arn
        domain_name          = rr.domain_name
        rule_type            = rr.rule_type
        resolver_endpoint_id = rr.resolver_endpoint_id
        target_ip            = rr.target_ip
      }
    }
  }
}

output "custom_resolver_rules" {
  value = {
    inbound = {
      for rr in aws_route53_resolver_rule.custom_inbound_rules :
      rr.name => {
        id                   = rr.id
        arn                  = rr.arn
        domain_name          = rr.domain_name
        rule_type            = rr.rule_type
        resolver_endpoint_id = rr.resolver_endpoint_id
        target_ip            = rr.target_ip
      }
    }
  }
}

output "resolver_rules_associations" {
  value = {
    for rra in aws_route53_resolver_rule_association.inbound_rules :
    rra.name => {
      id               = rra.id
      resolver_rule_id = rra.resolver_rule_id
      vpc_id           = rra.vpc_id
    }
  }
}

output "resolver_endpoints" {
  value = {
    inbound = {
      for re in module.resolver_endpoint_in :
      re.route53_resolver_endpoint_id => {
        id                  = re.route53_resolver_endpoint_id
        arn                 = re.route53_resolver_endpoint_arn
        host_vpc_id         = re.route53_resolver_endpoint_host_vpc_id
        security_groups_ids = re.route53_resolver_endpoint_security_group_ids
        ip_addresses        = re.route53_resolver_endpoint_ip_addresses
      }
    }
    outbound = {
      for re in module.resolver_endpoint_out :
      re.route53_resolver_endpoint_id => {
        id                  = re.route53_resolver_endpoint_id
        arn                 = re.route53_resolver_endpoint_arn
        host_vpc_id         = re.route53_resolver_endpoint_host_vpc_id
        security_groups_ids = re.route53_resolver_endpoint_security_group_ids
        ip_addresses        = re.route53_resolver_endpoint_ip_addresses
      }
    }
  }
}

output "ram" {
  value = {
    custom_rules_resource_shares = {
      for rs in aws_ram_resource_share.custom_inbound_rules :
      rs.name => {
        id                        = rs.id
        arn                       = rs.arn
        allow_external_principals = rs.allow_external_principals
      }
    }
    custom_rules_principal_associations = {
      for pa in aws_ram_principal_association.custom_inbound_rules :
      pa.id => {
        principal          = pa.principal
        resource_share_arn = pa.resource_share_arn
      }
    }
    resource_shares = {
      for rs in aws_ram_resource_share.inbound_rules :
      rs.name => {
        id                        = rs.id
        arn                       = rs.arn
        allow_external_principals = rs.allow_external_principals
      }
    }
    resource_associations = {
      for ra in aws_ram_resource_association.inbound_rules :
      ra.id => {
        resource_arn       = ra.resource_arn
        resource_share_arn = ra.resource_share_arn
      }
    }
    principal_associations = {
      for pa in aws_ram_principal_association.inbound_rules :
      pa.id => {
        principal          = pa.principal
        resource_share_arn = pa.resource_share_arn
      }
    }
  }
}

output "dns_vpc" {
  value = {
    vpc_id         = var.vpc_id
    vpc_region     = data.aws_region.current.id
    vpc_cidr_block = var.vpc_cidr_block
    subnet_ids     = var.subnet_ids
  }
}

output "vpc_association_auth" {
  value = {
    for k, v in local.private_zones :
    k => {
      id         = aws_route53_vpc_association_authorization.vpc_association[k].id
      zone_id    = aws_route53_vpc_association_authorization.vpc_association[k].zone_id
      vpc_id     = aws_route53_vpc_association_authorization.vpc_association[k].vpc_id
      vpc_region = aws_route53_vpc_association_authorization.vpc_association[k].vpc_region
    }
    if var.dns_vpc.vpc_id != ""
  }
}