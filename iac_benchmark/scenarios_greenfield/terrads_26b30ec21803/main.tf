provider "aws" {
	region = local.hcp_region
	default_tags {
   tags = {
		 owner       = var.owner
		 se-region   = var.se-region
		 purpose     = var.purpose
     ttl         = var.ttl
		 terraform   = var.terraform
		 hc-internet-facing = var.hc-internet-facing
	 }
 }
}

locals {
	hcp_account_id = data.terraform_remote_state.terraform-hcp-core.outputs.aws_account_id
	hcp_region = data.terraform_remote_state.terraform-hcp-core.outputs.hcp_hvn_region
	hcp_hvn_id = data.terraform_remote_state.terraform-hcp-core.outputs.hcp_hvn_id
	hcp_hvn_self_link = data.terraform_remote_state.terraform-hcp-core.outputs.hcp_hvn_self_link
	default_route_table_id = data.terraform_remote_state.aws-core.outputs.default_route_table_id
	private_route_table_ids = data.terraform_remote_state.aws-core.outputs.private_route_table_ids
	public_route_table_ids = data.terraform_remote_state.aws-core.outputs.public_route_table_ids
	private_subnet_ids = data.terraform_remote_state.aws-core.outputs.private_subnets
	public_subnet_ids = data.terraform_remote_state.aws-core.outputs.public_subnets
	vpc_id = data.terraform_remote_state.aws-core.outputs.vpc_id
}

resource "aws_ec2_transit_gateway" "this" {
	amazon_side_asn = 65001
	auto_accept_shared_attachments = "enable"
	default_route_table_association = "enable"
	default_route_table_propagation = "enable"
	vpn_ecmp_support = "enable"
	dns_support = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "private_subnets" {
	subnet_ids         = local.private_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = local.vpc_id
}

resource "aws_route" "default" {
	depends_on = [
		aws_ec2_transit_gateway_vpc_attachment.private_subnets
	]
	transit_gateway_id = aws_ec2_transit_gateway.this.id
	destination_cidr_block = "172.25.16.0/20"
	route_table_id = local.default_route_table_id
}

resource "aws_route" "private" {
	for_each = toset(local.private_route_table_ids)
	depends_on = [
		aws_ec2_transit_gateway_vpc_attachment.private_subnets
	]
	transit_gateway_id = aws_ec2_transit_gateway.this.id
	destination_cidr_block = "172.25.16.0/20"
	route_table_id = each.value
}

resource "aws_route" "public" {
	for_each = toset(local.public_route_table_ids)
	depends_on = [
		aws_ec2_transit_gateway_vpc_attachment.private_subnets
	]
	transit_gateway_id = aws_ec2_transit_gateway.this.id
	destination_cidr_block = "172.25.16.0/20"
	route_table_id = each.value
}

resource "aws_ram_resource_share" "this" {
  name                      = "hcp-hvn-resource-share"
  allow_external_principals = true
}

resource "aws_ram_principal_association" "this" {
  resource_share_arn = aws_ram_resource_share.this.arn
  principal          = local.hcp_account_id
}

resource "aws_ram_resource_association" "this" {
  resource_share_arn = aws_ram_resource_share.this.arn
  resource_arn       = aws_ec2_transit_gateway.this.arn
}

resource "hcp_aws_transit_gateway_attachment" "this" {
  depends_on = [
    aws_ram_principal_association.this,
    aws_ram_resource_association.this,
  ]

  hvn_id                        = local.hcp_hvn_id
  transit_gateway_attachment_id = "hcp-tgw-attachment"
  transit_gateway_id            = aws_ec2_transit_gateway.this.id
  resource_share_arn            = aws_ram_resource_share.this.arn

}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  transit_gateway_attachment_id = hcp_aws_transit_gateway_attachment.this.provider_transit_gateway_attachment_id
}

resource "hcp_hvn_route" "route" {
	for_each = toset(var.aws_subnets)
  hvn_link         = local.hcp_hvn_self_link
  hvn_route_id     = "hcp-to-${replace(split("/", each.value)[0], ".", "-")}"
  destination_cidr = each.value
  target_link      = hcp_aws_transit_gateway_attachment.this.self_link
}

resource "aws_security_group" "hcp_vault" {
	name        = "hcp vault"
  description = "Permit access to Vault on HCP"
  vpc_id      = local.vpc_id
}

resource "aws_security_group" "hcp_consul" {
	name        = "hcp consul"
  description = "Permit access to and from Consul on HCP"
  vpc_id      = local.vpc_id
}

# resource "aws_security_group" "permit_self" {
# 	name        = "permit self"
#   description = "Permit access between members of this security group"
#   vpc_id      = local.vpc_id
# }

# ## Rules for permit_self
# resource "aws_security_group_rule" "allow_self_ingress" {
#   description       = "Allow members of this security group ingress communication to each other over all ports"
#   protocol          = "-1"
#   security_group_id = aws_security_group.hcp.id
#   self              = true
#   from_port         = 0
#   to_port           = 0
#   type              = "ingress"
# }

# resource "aws_security_group_rule" "allow_self_egress" {
#   description       = "Allow members of this security group egress communication to each other over all ports"
#   protocol          = "-1"
#   security_group_id = aws_security_group.hcp.id
#   from_port         = 0
#   to_port           = 0
#   type              = "egress"
# }

## Rules for Consul
resource "aws_security_group_rule" "allow_serf_udp_ingress" {
  description       = "Allow serf access ingress over udp from HCP"
  protocol          = "udp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks       = ["172.25.16.0/20"]
  from_port         = 8301
  to_port           = 8301
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_serf_tcp_ingress" {
  description       = "Allow serf access ingress over tcp from HCP"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks       = ["172.25.16.0/20"]
  from_port         = 8301
  to_port           = 8301
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_serf_udp_self_ingress" {
  description       = "Allow members of this security group ingress communication serf over udp"
  protocol          = "udp"
  security_group_id = aws_security_group.hcp_consul.id
	self  						= true
  from_port         = 8301
  to_port           = 8301
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_serf_tcp_self_ingress" {
  description       = "Allow members of this security group ingress communication serf over tcp"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	self  						= true
  from_port         = 8301
  to_port           = 8301
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_serf_udp_self_egress" {
  description       = "Allow members of this security group egress communication serf over udp"
  protocol          = "udp"
  security_group_id = aws_security_group.hcp_consul.id
	self  						= true
  from_port         = 8301
  to_port           = 8301
  type              = "egress"
}

resource "aws_security_group_rule" "allow_serf_tcp_self_egress" {
  description       = "Allow members of this security group egress communication serf over tcp"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	self  						= true
  from_port         = 8301
  to_port           = 8301
  type              = "egress"
}

resource "aws_security_group_rule" "allow_http_egress" {
  description       = "Allow members of this security group egress communication to HCP over http"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks       = ["172.25.16.0/20"]
  from_port         = 80
  to_port           = 80
  type              = "egress"
}

resource "aws_security_group_rule" "allow_https_egress" {
  description       = "Allow members of this security group egress communication to HCP over https"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks       = ["172.25.16.0/20"]
  from_port         = 443
  to_port           = 443
  type              = "egress"
}

resource "aws_security_group_rule" "allow_consul_rpc_egress" {
  description       = "Allow members of this security group egress communication to Consul over rpc"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks       = ["172.25.16.0/20"]
  from_port         = 8300
  to_port           = 8300
  type              = "egress"
}

resource "aws_security_group_rule" "allow_serf_udp_egress" {
  description       = "Allow members of this security group egress communication to Consul serf over tcp"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks       = ["172.25.16.0/20"]
  from_port         = 8301
  to_port           = 8301
  type              = "egress"
}

resource "aws_security_group_rule" "allow_serf_tcp_egress" {
  description       = "Allow members of this security group egress communication to Consul serf over udp"
  protocol          = "udp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks       = ["172.25.16.0/20"]
  from_port         = 8301
  to_port           = 8301
  type              = "egress"
}

resource "aws_security_group_rule" "allow_https_self_egress" {
	description       = "Allow members of this security group egress communication to HCP over https"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "allow_https_self_ingress" {
	description       = "Allow members of this security group egress communication to HCP over https"
  protocol          = "tcp"
  security_group_id = aws_security_group.hcp_consul.id
	cidr_blocks = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "ingress"
}

## Vault Rules
resource "aws_security_group_rule" "allow_vault_egress" {
  description       = "Allow members of this security group egress communication to Consul serf over udp"
  protocol          = "udp"
  security_group_id = aws_security_group.hcp_vault.id
	cidr_blocks       = ["172.25.16.0/20"]
  from_port         = 8200
  to_port           = 8200
  type              = "egress"
}


# resource "aws_security_group" "hcp" {
# 	name        = "hcp access"
#   description = "Permit access to Vault and Consul on HCP"
#   vpc_id      = local.vpc_id
# 	egress = [
#     {
# 			description = "vault"
#       from_port        = 8200
#       to_port          = 8200
#       protocol         = "tcp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = false
#     },
# 		{
# 			description = "consul"
# 			from_port        = 8300
#       to_port          = 8300
#       protocol         = "tcp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = false
# 		},
# 		{
# 			description = "consul"
# 			from_port        = 8301
#       to_port          = 8301
#       protocol         = "tcp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = true
# 		},
# 		{
# 			description = "consul"
# 			from_port        = 8301
#       to_port          = 8301
#       protocol         = "udp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = true
# 		},
# 		{
# 			description = "consul"
# 			from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = false
# 		},
# 		{
# 			description = "consul"
# 			from_port        = 443
#       to_port          = 443
#       protocol         = "tcp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = false
# 		},
# 		{
# 			description = "consul"
#       from_port        = 53
#       to_port          = 53
#       protocol         = "udp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = false
#     }
#   ]
# 	ingress = [
# 		{
# 			description = "consul"
#       from_port        = 8301
#       to_port          = 8301
#       protocol         = "udp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = true
# 		},
# 		{
# 			description = "consul"
#       from_port        = 8301
#       to_port          = 8301
#       protocol         = "tcp"
#       cidr_blocks      = ["172.25.16.0/20"]
# 			ipv6_cidr_blocks = []
# 			security_groups = []
# 			prefix_list_ids = []
# 			self = true
# 		}
# 	]
# }