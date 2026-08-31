# Add route for traffic to get back to GCP

# resource "hcp_hvn_route" "gcp" {
#   for_each         = toset(var.gcp_subnets)
#   hvn_link         = local.hcp_hvn_self_link
#   hvn_route_id     = "hcp-to-${replace(split("/", each.value)[0], ".", "-")}"
#   destination_cidr = each.value
#   target_link      = hcp_aws_transit_gateway_attachment.this.self_link
# }