resource "aws_msk_serverless_cluster" "this" {
  region       = var.region
  cluster_name = var.cluster_name
  tags         = var.tags

  client_authentication {
    sasl {
      iam {
        enabled = var.client_authentication.sasl.iam.enabled
      }
    }
  }

  vpc_config {
    subnet_ids         = var.vpc_config.subnet_ids
    security_group_ids = var.vpc_config.security_group_ids
  }

  timeouts {
    create = "120m"
    delete = "120m"
  }
}