resource "cloudflare_load_balancer_pool" "%s" {
  account_id = "%s"
  name       = "my-tf-pool-basic-%s"

  origins {
    name    = "example-1"
    address = "192.0.2.1"
    enabled = true
  }
}
