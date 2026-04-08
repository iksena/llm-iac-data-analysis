provider "aws" { // My Root Account
  region = "us-west-2"
}

provider "aws" { // My DEV Account
  region = "us-west-1"
  alias  = "dev"
}

provider "aws" { // My PROD Account
  region = "ca-central-1"
  alias  = "prod"
}
#--------------------------------------------------------------

module "servers" {
  source        = "./modules/instance-module"
  instance_type = "t3.small"
  providers = {
    aws.root = aws             # Default region
    aws.prod = aws.prod        # Prod region
    aws.dev  = aws.dev         # Dev region
  }
}