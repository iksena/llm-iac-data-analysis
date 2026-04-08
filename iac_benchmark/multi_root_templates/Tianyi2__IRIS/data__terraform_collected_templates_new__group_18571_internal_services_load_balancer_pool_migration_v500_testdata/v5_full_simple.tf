resource "cloudflare_load_balancer_pool" "%s" {
  account_id = "%s"
  name       = "my-tf-pool-full-%s"

  origins = [
    {
      name    = "example-1"
      address = "192.0.2.1"
      enabled = false
      weight  = 1.0
      header = {
        host = ["test1.%s"]
      }
    },
    {
      name    = "example-2"
      address = "192.0.2.2"
      weight  = 0.5
      header = {
        host = ["test2.%s"]
      }
    }
  ]

  latitude  = 12.3
  longitude = 55

  check_regions      = ["WEU"]
  description        = "tfacc-fully-specified"
  enabled            = false
  minimum_origins    = 2
  notification_email = "someone@example.com"
}
