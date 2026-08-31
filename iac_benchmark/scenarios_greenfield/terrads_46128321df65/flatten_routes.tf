# Dublin - eu-west-1
locals {

  # Assign an index to route tables
  rt_dub_index = {
    for k in sort(keys(aws_route_table.public_dub)) : k => {
      id     = aws_route_table.public_dub[k].id
      index  = index(sort(keys(aws_route_table.public_dub)), k)
      az     = try(regex(".*(eu-west-1[abcd])", k)[0], "default-value-or-empty-string")
      vpc_id = aws_route_table.public_dub[k].vpc_id
    }
  }

  # Flatten route tables and routes
  flattened_rt_routes_dub = local.rt_dub_index != null ? flatten([
    for rt_key, rt in local.rt_dub_index : [
      for route_key, route in local.public_routes[var.environment] : merge(
        rt,
        {
          vpc_id       = rt.vpc_id
          vpc_key      = route[1]
          rt_key       = rt_key
          route_key    = route_key
          route_region = route[0]
          route_target = route[2]
          route_cidr   = route[3]
          az           = rt.az
        }
      )
      if route[0] == "eu-west-1"
    ]
  ]) : []

  # Convert to maps with readable, immutable keys
  rt_routes_map_dub = {
    for idx, route in local.flattened_rt_routes_dub : "${route.rt_key}-${route.route_key}" => route
  }

  # Flatted route tables, routes & ec2 instances so we can send a route to the ENI
  flattened_rt_routes_ec2_dub = length(local.rt_dub_index) > 0 ? flatten([
    for rt_key, rt in local.flattened_rt_routes_dub : [
      for ec2_key, ec2 in local.ec2_map : {
        rt_key        = rt.rt_key
        rt_index      = rt.index
        route_key     = rt.route_key
        route_name    = "${rt.route_key}-${rt.az}-${ec2_key}"
        route_target  = rt.route_target
        route_cidr    = rt.route_cidr
        az            = rt.az
        ec2_index     = ec2.index
        ec2_key       = ec2_key
        ec2_az        = ec2.az
        ec2_eni_route = try(ec2.eni_route, null)
      }
      if ec2.index == rt.index
    ]
  ]) : []
}

# Virginia - us-east-1
locals {

  # Assign an index to route tables
  rt_vir_index = {
    for k in sort(keys(aws_route_table.public_vir)) : k => {
      id     = aws_route_table.public_vir[k].id
      index  = index(sort(keys(aws_route_table.public_vir)), k)
      az     = try(regex(".*(us-east-1[abcd])", k)[0], "default-value-or-empty-string")
      vpc_id = aws_route_table.public_vir[k].vpc_id
    }
  }

  # Flatten route tables and routes
  flattened_rt_routes_vir = local.rt_vir_index != null ? flatten([
    for rt_key, rt in local.rt_vir_index : [
      for route_key, route in local.public_routes[var.environment] : merge(
        rt,
        {
          vpc_id       = rt.vpc_id
          vpc_key      = route[1]
          rt_key       = rt_key
          route_key    = route_key
          route_region = route[0]
          route_target = route[2]
          route_cidr   = route[3]
          az           = rt.az
        }
      )
      if route[0] == "us-east-1"
    ]
  ]) : []

  # Convert to maps with readable, immutable keys
  rt_routes_map_vir = {
    for idx, route in local.flattened_rt_routes_vir : "${route.rt_key}-${route.route_key}" => route
  }

  # Flatted route tables, routes & ec2 instances so we can send a route to the ENI
  flattened_rt_routes_ec2_vir = length(local.rt_vir_index) > 0 ? flatten([
    for rt_key, rt in local.flattened_rt_routes_vir : [
      for ec2_key, ec2 in local.ec2_map : {
        rt_key        = rt.rt_key
        rt_index      = rt.index
        route_key     = rt.route_key
        route_name    = "${rt.route_key}-${rt.az}-${ec2_key}"
        route_target  = rt.route_target
        route_cidr    = rt.route_cidr
        az            = rt.az
        ec2_index     = ec2.index
        ec2_key       = ec2_key
        ec2_az        = ec2.az
        ec2_eni_route = try(ec2.eni_route, null)
      }
      if ec2.index == rt.index
    ]
  ]) : []
}

# Mumbai - ap-south-1
locals {

  # Assign an index to route tables
  rt_mum_index = {
    for k in sort(keys(aws_route_table.public_mum)) : k => {
      id     = aws_route_table.public_mum[k].id
      index  = index(sort(keys(aws_route_table.public_mum)), k)
      az     = try(regex(".*(ap-south-1[abcd])", k)[0], "default-value-or-empty-string")
      vpc_id = aws_route_table.public_mum[k].vpc_id
    }
  }

  # Flatten route tables and routes
  flattened_rt_routes_mum = local.rt_mum_index != null ? flatten([
    for rt_key, rt in local.rt_mum_index : [
      for route_key, route in local.public_routes[var.environment] : merge(
        rt,
        {
          vpc_id       = rt.vpc_id
          vpc_key      = route[1]
          rt_key       = rt_key
          route_key    = route_key
          route_region = route[0]
          route_target = route[2]
          route_cidr   = route[3]
          az           = rt.az
        }
      )
      if route[0] == "ap-south-1"
    ]
  ]) : []

  # Convert to maps with readable, immutable keys
  rt_routes_map_mum = {
    for idx, route in local.flattened_rt_routes_mum : "${route.rt_key}-${route.route_key}" => route
  }

  # Flatted route tables, routes & ec2 instances so we can send a route to the ENI
  flattened_rt_routes_ec2_mum = length(local.rt_mum_index) > 0 ? flatten([
    for rt_key, rt in local.flattened_rt_routes_mum : [
      for ec2_key, ec2 in local.ec2_map : {
        rt_key        = rt.rt_key
        rt_index      = rt.index
        route_key     = rt.route_key
        route_name    = "${rt.route_key}-${rt.az}-${ec2_key}"
        route_target  = rt.route_target
        route_cidr    = rt.route_cidr
        az            = rt.az
        ec2_index     = ec2.index
        ec2_key       = ec2_key
        ec2_az        = ec2.az
        ec2_eni_route = try(ec2.eni_route, null)
      }
      if ec2.index == rt.index
    ]
  ]) : []
}