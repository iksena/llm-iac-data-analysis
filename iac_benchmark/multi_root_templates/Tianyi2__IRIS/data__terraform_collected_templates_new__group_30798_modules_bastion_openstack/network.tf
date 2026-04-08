resource "openstack_networking_floatingip_v2" "bastion_ip" {
  pool = var.external_network_name
}