output "router_id" {
  value = openstack_networking_router_v2.router.id
}


output "subnet_id" {
  value = openstack_networking_subnet_v2.subnet.id
}


output "network_id" {
  value = openstack_networking_network_v2.network.id
}


output "external_network_id" {
  value = data.openstack_networking_network_v2.external_network.id
}

