provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      owner      = "tavares"
      managed-by = "terraform"
      enviroment = "data-plataform"
    }
  }
}
