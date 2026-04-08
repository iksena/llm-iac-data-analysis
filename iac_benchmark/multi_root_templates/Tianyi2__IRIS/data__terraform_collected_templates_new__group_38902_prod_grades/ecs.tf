module "server_evergreen_service" {
  source = "../../modules/evergreen-service"

  service_name = "grades-prod-server"

  acm_certificate_arns = [module.server_certificate.certificate_arn]
  domain_names         = [local.server_domain]

  target_group_container_name = "grades-prod-server"
  target_group_container_port = 8081
  target_group_rule_priority  = 1200

  alb_health_check_path = "/"

  task_count    = 1
  task_cpu      = 1024 / 8
  task_memory   = 1024 / 8
  task_role_arn = aws_iam_role.server.arn

  runtime_platform_architecture     = "X86_64"
  runtime_platform_operating_system = "LINUX"

  containers = [
    {
      container_name = "grades-prod-server"
      image          = data.aws_ecr_image.server.image_uri
      cpu            = 1024 / 8
      memory         = 1024 / 8
      essential      = true
      environment    = data.doppler_secrets.grades.map
      ports          = [{ container_port = 8081, protocol = "tcp" }]
      healthcheck = {
        command = ["CMD-SHELL", "true"]
      }
    }
  ]
}

module "web_evergreen_service" {
  source = "../../modules/evergreen-service"

  service_name = "grades-prod-web"

  acm_certificate_arns = [module.web_certificate.certificate_arn, module.web_www_certificate.certificate_arn]
  domain_names         = [local.web_domain, "www.${local.web_domain}"]

  target_group_container_name = "grades-prod-web"
  target_group_container_port = 3000
  target_group_rule_priority  = 1300

  alb_health_check_path = "/"

  task_count    = 1
  task_cpu      = 1024 / 4
  task_memory   = 1024 / 4
  task_role_arn = aws_iam_role.web.arn

  runtime_platform_architecture     = "X86_64"
  runtime_platform_operating_system = "LINUX"

  containers = [
    {
      container_name = "grades-prod-web"
      image          = data.aws_ecr_image.web.image_uri
      cpu            = 1024 / 4
      memory         = 1024 / 4
      essential      = true
      environment    = data.doppler_secrets.grades.map
      ports          = [{ container_port = 3000, protocol = "tcp" }]
      healthcheck = {
        command = ["CMD-SHELL", "true"]
      }
    }
  ]
}
