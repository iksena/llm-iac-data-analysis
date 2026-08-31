locals {
  ec2 = {
    dev = {
      arryw-web = {
        region           = "eu-west-1"
        vpc              = "arryw-dev-dublin"
        count            = 1
        az               = ["eu-west-1a", "eu-west-1b"]
        key_pair         = "arryw"
        root_volume_size = 20
        shutdown_time    = "22:00"
        start_time       = "07:00"
      }
    }
  }
}