resource "openstack_compute_keypair_v2" "terraform" {
  name       = "${var.env_name}-keypair"
  public_key = file(var.public_key)
}
