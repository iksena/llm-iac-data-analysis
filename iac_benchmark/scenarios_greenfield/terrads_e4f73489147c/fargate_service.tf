locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  service_name = "nginx"
  task_image = "${local.aws_account_id}.dkr.ecr.${local.aws_region}.amazonaws.com/${local.prefix}-${local.service_name}:latest"
  service_port = 80
  service_namespace_id = aws_service_discovery_private_dns_namespace.app.id
  container_definition = [{
    cpu         = 512
    image       = local.task_image
    memory      = 1024
    name        = local.service_name
    networkMode = "awsvpc"
    environment = [
      {
        "name": "SERVICE_DISCOVERY_NAMESPACE_ID", "value": local.service_namespace_id
      }
    ]
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = local.service_port
        hostPort      = local.service_port
      }
    ]
    logConfiguration = {
      logdriver = "awslogs"
      options = {
        "awslogs-group"         = local.cw_log_group
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "stdout"
      }
    }
  }]
  cw_log_group = "/ecs/${local.service_name}"
}

# Fargate service

resource "aws_security_group" "fargate_task" {
  name   = "${local.service_name}-fargate-task"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = local.service_port
    to_port     = local.service_port
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
  local.common_tags,
  {
    Name = local.service_name
  }
  )
}

data "aws_iam_policy_document" "fargate-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "fargate_execution" {
  name   = "fargate_execution_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetAuthorizationToken",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ssm:GetParameters",
            "secretsmanager:GetSecretValue",
            "kms:Decrypt"
        ],
        "Resource": [
            "*"
        ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "fargate_task" {
  name   = "fargate_task_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "servicediscovery:ListServices",
            "servicediscovery:ListInstances"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "fargate_execution" {
  name               = "${local.service_name}-fargate-execution-role"
  assume_role_policy = data.aws_iam_policy_document.fargate-role-policy.json
}

resource "aws_iam_role" "fargate_task" {
  name               = "${local.service_name}-fargate-task-role"
  assume_role_policy = data.aws_iam_policy_document.fargate-role-policy.json
}
resource "aws_iam_role_policy_attachment" "fargate-execution" {
  role       = aws_iam_role.fargate_execution.name
  policy_arn = aws_iam_policy.fargate_execution.arn
}
resource "aws_iam_role_policy_attachment" "fargate-task" {
  role       = aws_iam_role.fargate_task.name
  policy_arn = aws_iam_policy.fargate_task.arn
}

# Fargate Container
resource "aws_cloudwatch_log_group" "app" {
  name = local.cw_log_group
  tags = merge(
    local.common_tags,
    {
      Name = local.service_name
    }
  )
}

resource "aws_ecs_task_definition" "app" {
  family                   = local.service_name
  network_mode             = "awsvpc"
  cpu                      = local.container_definition.0.cpu
  memory                   = local.container_definition.0.memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode(local.container_definition)
  execution_role_arn       = aws_iam_role.fargate_execution.arn
  task_role_arn            = aws_iam_role.fargate_task.arn
  tags = merge(
    local.common_tags,
    {
      Name = local.service_name
    }
  )
}

resource "aws_ecs_service" "app" {
  name            = local.service_name
  cluster         = aws_ecs_cluster.main.name
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = "1"
  launch_type     = "FARGATE"

  service_registries {
    registry_arn = aws_service_discovery_service.app_service.arn
    container_name = local.service_name
    container_port = local.service_port
  }

  network_configuration {
    security_groups = [aws_security_group.fargate_task.id]
    subnets         = module.vpc.private_subnets
  }
}

resource "aws_service_discovery_service" "app_service" {
  name = local.service_name

  dns_config {
    namespace_id = local.service_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    dns_records {
      ttl  = 10
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
