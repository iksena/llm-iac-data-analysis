# Keycloak Self-Hosted Identity Provider Configuration

# Keycloak deployment on AWS ECS
resource "aws_ecs_task_definition" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  family                   = "${local.name_prefix}-keycloak"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.keycloak_cpu
  memory                   = var.keycloak_memory
  execution_role_arn       = aws_iam_role.keycloak_execution[0].arn
  task_role_arn           = aws_iam_role.keycloak_task[0].arn

  container_definitions = jsonencode([
    {
      name  = "keycloak"
      image = "quay.io/keycloak/keycloak:${var.keycloak_version}"
      
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "KEYCLOAK_ADMIN"
          value = var.keycloak_admin_user
        },
        {
          name  = "KC_HOSTNAME"
          value = "auth.${var.domain_name}"
        },
        {
          name  = "KC_HOSTNAME_STRICT"
          value = "false"
        },
        {
          name  = "KC_HTTP_ENABLED"
          value = "true"
        },
        {
          name  = "KC_PROXY"
          value = "edge"
        },
        {
          name  = "KC_DB"
          value = "postgres"
        }
      ]

      secrets = [
        {
          name      = "KEYCLOAK_ADMIN_PASSWORD"
          valueFrom = aws_ssm_parameter.keycloak_admin_password[0].arn
        },
        {
          name      = "KC_DB_URL"
          valueFrom = aws_ssm_parameter.keycloak_db_url[0].arn
        },
        {
          name      = "KC_DB_USERNAME"
          valueFrom = aws_ssm_parameter.keycloak_db_username[0].arn
        },
        {
          name      = "KC_DB_PASSWORD"
          valueFrom = aws_ssm_parameter.keycloak_db_password[0].arn
        }
      ]

      command = ["start", "--optimized"]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.keycloak[0].name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/health/ready || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 120
      }
    }
  ])

  tags = local.common_tags
}

# CloudWatch Log Group for Keycloak
resource "aws_cloudwatch_log_group" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  name              = "/ecs/${local.name_prefix}-keycloak"
  retention_in_days = 7

  tags = local.common_tags
}

# Security Group for Keycloak
resource "aws_security_group" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  name_prefix = "${local.name_prefix}-keycloak"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.keycloak_alb[0].id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-keycloak-sg"
  })
}

# ECS Service for Keycloak
resource "aws_ecs_service" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  name            = "${local.name_prefix}-keycloak"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.keycloak[0].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.keycloak[0].id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.keycloak[0].arn
    container_name   = "keycloak"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.keycloak[0]]

  tags = local.common_tags
}

# Application Load Balancer for Keycloak
resource "aws_lb" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  name               = "${local.name_prefix}-keycloak-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.keycloak_alb[0].id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = local.common_tags
}

# Security Group for Keycloak ALB
resource "aws_security_group" "keycloak_alb" {
  count = var.enable_keycloak ? 1 : 0
  
  name_prefix = "${local.name_prefix}-keycloak-alb"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-keycloak-alb-sg"
  })
}

# Target Group for Keycloak
resource "aws_lb_target_group" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  name        = "${local.name_prefix}-keycloak-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health/ready"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = local.common_tags
}

# ALB Listener - HTTP (redirects to HTTPS)
resource "aws_lb_listener" "keycloak_http" {
  count = var.enable_keycloak ? 1 : 0
  
  load_balancer_arn = aws_lb.keycloak[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ALB Listener - HTTPS
resource "aws_lb_listener" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  load_balancer_arn = aws_lb.keycloak[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate_validation.keycloak[0].certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.keycloak[0].arn
  }
}

# SSL Certificate for Keycloak
resource "aws_acm_certificate" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  domain_name       = "auth.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

# Certificate validation
resource "aws_route53_record" "keycloak_cert_validation" {
  count = var.enable_keycloak ? 1 : 0
  
  for_each = {
    for dvo in aws_acm_certificate.keycloak[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

resource "aws_acm_certificate_validation" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  certificate_arn         = aws_acm_certificate.keycloak[0].arn
  validation_record_fqdns = [for record in aws_route53_record.keycloak_cert_validation[0] : record.fqdn]
}

# Route 53 record for Keycloak
resource "aws_route53_record" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  zone_id = var.route53_zone_id
  name    = "auth.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.keycloak[0].dns_name
    zone_id                = aws_lb.keycloak[0].zone_id
    evaluate_target_health = true
  }
}

# Database for Keycloak
resource "aws_db_instance" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  identifier = "${local.name_prefix}-keycloak-db"
  
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = var.keycloak_db_instance_class
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true
  
  db_name  = "keycloak"
  username = "keycloak"
  password = random_password.keycloak_db_password[0].result
  
  vpc_security_group_ids = [aws_security_group.keycloak_db[0].id]
  db_subnet_group_name   = aws_db_subnet_group.keycloak[0].name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = local.common_tags
}

# DB Subnet Group for Keycloak
resource "aws_db_subnet_group" "keycloak" {
  count = var.enable_keycloak ? 1 : 0
  
  name       = "${local.name_prefix}-keycloak-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-keycloak-db-subnet-group"
  })
}

# Security Group for Keycloak Database
resource "aws_security_group" "keycloak_db" {
  count = var.enable_keycloak ? 1 : 0
  
  name_prefix = "${local.name_prefix}-keycloak-db"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.keycloak[0].id]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-keycloak-db-sg"
  })
}

# Random passwords
resource "random_password" "keycloak_admin_password" {
  count = var.enable_keycloak ? 1 : 0
  
  length  = 16
  special = true
}

resource "random_password" "keycloak_db_password" {
  count = var.enable_keycloak ? 1 : 0
  
  length  = 16
  special = true
}

# SSM Parameters for Keycloak
resource "aws_ssm_parameter" "keycloak_admin_password" {
  count = var.enable_keycloak ? 1 : 0
  
  name  = "/${local.name_prefix}/keycloak-admin-password"
  type  = "SecureString"
  value = random_password.keycloak_admin_password[0].result

  tags = local.common_tags
}

resource "aws_ssm_parameter" "keycloak_db_url" {
  count = var.enable_keycloak ? 1 : 0
  
  name  = "/${local.name_prefix}/keycloak-db-url"
  type  = "SecureString"
  value = "jdbc:postgresql://${aws_db_instance.keycloak[0].endpoint}/keycloak"

  tags = local.common_tags
}

resource "aws_ssm_parameter" "keycloak_db_username" {
  count = var.enable_keycloak ? 1 : 0
  
  name  = "/${local.name_prefix}/keycloak-db-username"
  type  = "String"
  value = aws_db_instance.keycloak[0].username

  tags = local.common_tags
}

resource "aws_ssm_parameter" "keycloak_db_password" {
  count = var.enable_keycloak ? 1 : 0
  
  name  = "/${local.name_prefix}/keycloak-db-password"
  type  = "SecureString"
  value = random_password.keycloak_db_password[0].result

  tags = local.common_tags
}

# IAM roles for Keycloak ECS
resource "aws_iam_role" "keycloak_execution" {
  count = var.enable_keycloak ? 1 : 0
  
  name = "${local.name_prefix}-keycloak-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role" "keycloak_task" {
  count = var.enable_keycloak ? 1 : 0
  
  name = "${local.name_prefix}-keycloak-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# Attach policies to execution role
resource "aws_iam_role_policy_attachment" "keycloak_execution" {
  count = var.enable_keycloak ? 1 : 0
  
  role       = aws_iam_role.keycloak_execution[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom policy for SSM access
resource "aws_iam_role_policy" "keycloak_execution_ssm" {
  count = var.enable_keycloak ? 1 : 0
  
  name = "${local.name_prefix}-keycloak-execution-ssm"
  role = aws_iam_role.keycloak_execution[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ]
        Resource = [
          aws_ssm_parameter.keycloak_admin_password[0].arn,
          aws_ssm_parameter.keycloak_db_url[0].arn,
          aws_ssm_parameter.keycloak_db_username[0].arn,
          aws_ssm_parameter.keycloak_db_password[0].arn
        ]
      }
    ]
  })
}