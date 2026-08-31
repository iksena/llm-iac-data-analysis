locals {

  # Flatten the structure for subnet creation
  flattened_subnets = flatten([
    for k, v in local.vpc[var.environment] : [
      for idx, subnet in v[2] : {
        vpc_key    = k
        region     = v[0]
        cidr_block = subnet
        az         = "${v[0]}${element(["a", "b", "c", "d"], idx)}"
      }
    ]
  ])
  # Give the subnet a unique key
  subnet_map = {
    for subnet in local.flattened_subnets : "${subnet.vpc_key}-${subnet.az}" => subnet
  }
}