locals {

  tags = {
    created_by = "terraform"
  }
  module_path        = abspath(path.module)
  worker_path        = abspath("${path.module}/worker/")
  deploy_path        = abspath("${path.module}/deploy.zip")
}