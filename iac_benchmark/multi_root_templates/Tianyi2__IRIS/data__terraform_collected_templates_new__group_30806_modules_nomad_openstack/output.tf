output workers-fixed-ips {
  value = openstack_compute_instance_v2.server.*.network.0.fixed_ip_v4
}

