module "main_basic" {
  source = "../.."

  enabled     = true
  name        = "basic-example"
  environment = "dev"

  tags = {
    Environment = "dev"
    Project     = "terraform-module-template"
    Example     = "basic"
  }
}
