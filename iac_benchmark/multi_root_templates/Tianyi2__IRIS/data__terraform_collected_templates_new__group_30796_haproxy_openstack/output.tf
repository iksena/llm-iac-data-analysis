output "private_ip" {
  value = openstack_compute_instance_v2.haproxy.network.0.fixed_ip_v4
}