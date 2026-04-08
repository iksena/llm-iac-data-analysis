resource "cloudflare_load_balancer_pool" "%s" {
  account_id = "%s"
  name       = "my-tf-pool-regions-%s"

  origins = [{
    name    = "example-1"
    address = "192.0.2.1"
  }]

  check_regions = ["WEU", "ENAM", "WNAM"]
}
