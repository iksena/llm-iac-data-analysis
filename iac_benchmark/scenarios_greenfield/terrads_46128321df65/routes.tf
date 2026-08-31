# Dublin - eu-west-1
resource "aws_route" "public_igw_route_dub" {
  for_each = {
    for idx, route in local.rt_routes_map_dub : idx => route
    if route.route_target == "igw" && route.route_region == "eu-west-1"
  }
  provider               = aws.dublin
  route_table_id         = aws_route_table.public_dub[each.value.rt_key].id
  destination_cidr_block = each.value.route_cidr
  gateway_id             = aws_internet_gateway.igw_dub[each.value.vpc_key].id
}

resource "aws_route" "public_eni_route_dub" {
  for_each = {
    for idx, route in local.flattened_rt_routes_ec2_dub : route.route_name => route
    if route.route_target == "eni" && route.ec2_eni_route == true
  }
  provider               = aws.dublin
  route_table_id         = aws_route_table.public_dub[each.value.rt_key].id
  destination_cidr_block = each.value.route_cidr
  network_interface_id   = aws_instance.ec2_dub[each.value.ec2_key].primary_network_interface_id
}

# Virginia - us-east-1
resource "aws_route" "public_igw_route_vir" {
  for_each = {
    for idx, route in local.rt_routes_map_vir : idx => route
    if route.route_target == "igw" && route.route_region == "us-east-1"
  }
  provider               = aws.virginia
  route_table_id         = aws_route_table.public_vir[each.value.rt_key].id
  destination_cidr_block = each.value.route_cidr
  gateway_id             = aws_internet_gateway.igw_vir[each.value.vpc_key].id
}

resource "aws_route" "public_eni_route_vir" {
  for_each = {
    for idx, route in local.flattened_rt_routes_ec2_vir : route.route_name => route
    if route.route_target == "eni" && route.ec2_eni_route == true
  }
  provider               = aws.virginia
  route_table_id         = aws_route_table.public_vir[each.value.rt_key].id
  destination_cidr_block = each.value.route_cidr
  network_interface_id   = aws_instance.ec2_vir[each.value.ec2_key].primary_network_interface_id
}

# Mumbai - ap-south-1
resource "aws_route" "public_igw_route_mum" {
  for_each = {
    for idx, route in local.rt_routes_map_mum : idx => route
    if route.route_target == "igw" && route.route_region == "ap-south-1"
  }
  provider               = aws.mumbai
  route_table_id         = aws_route_table.public_mum[each.value.rt_key].id
  destination_cidr_block = each.value.route_cidr
  gateway_id             = aws_internet_gateway.igw_mum[each.value.vpc_key].id
}

resource "aws_route" "public_eni_route_mum" {
  for_each = {
    for idx, route in local.flattened_rt_routes_ec2_mum : route.route_name => route
    if route.route_target == "eni" && route.ec2_eni_route == true
  }
  provider               = aws.mumbai
  route_table_id         = aws_route_table.public_mum[each.value.rt_key].id
  destination_cidr_block = each.value.route_cidr
  network_interface_id   = aws_instance.ec2_mum[each.value.ec2_key].primary_network_interface_id
}