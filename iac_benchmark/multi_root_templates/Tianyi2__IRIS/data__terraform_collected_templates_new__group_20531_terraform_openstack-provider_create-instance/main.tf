resource "openstack_compute_instance_v2" "basic" {
  name            = "basic"
  image_id        = var.image_id
  flavor_name     = var.flavor_name
  key_pair        = var.key_pair_name
  security_groups = ["default"]
  network {
    name = var.network_name
  }
}

resource "openstack_blockstorage_volume_v3" "debian12_volume" {
  name        = "debian12-root"
  size        = 20                
  image_id    = var.image_id   
  volume_type = var.volume_type        
}

resource "openstack_compute_instance_v2" "test_vm" {
  name            = "terraform-vm"
  flavor_name     = var.flavor_name
  key_pair        = var.key_pair_name
  security_groups = ["default"]

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.debian12_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    name = var.network_name
  }
}
