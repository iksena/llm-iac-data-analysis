module "ecr" {
  source  = "app.terraform.io/ovotech/container-registry/aws"
  version = "1.0.0"

  ecr_name = "my-container-registry"
}
