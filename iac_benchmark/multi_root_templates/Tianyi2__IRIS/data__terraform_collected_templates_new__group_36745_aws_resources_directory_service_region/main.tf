resource "aws_directory_service_region" "this" {
  region                               = var.region
  desired_number_of_domain_controllers = var.desired_number_of_domain_controllers
  directory_id                         = var.directory_id
  region_name                          = var.region_name
  tags                                 = var.tags

  vpc_settings {
    subnet_ids = var.vpc_settings.subnet_ids
    vpc_id     = var.vpc_settings.vpc_id
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}