resource "openstack_networking_floatingip_v2" "ftp_ip" {
  pool = var.external_network_name
}