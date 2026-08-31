resource "aws_security_group" "ecs_task" {
  name        = "${local.prefix}-ecs-task"
  description = "Security group for ECS Task"
  vpc_id      = data.terraform_remote_state.common.outputs.vpc_id
  ingress = [
    {
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups = [
        data.terraform_remote_state.common.outputs.alb_sg_id,
      ]
      prefix_list_ids = []
      self            = false
      description     = "HTTP"
      protocol        = "tcp"
      from_port       = 5000
      to_port         = 5000
    },
  ]

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "db" {
  name        = "${local.prefix}-db"
  description = "Security group for Aurora Serverless"
  vpc_id      = data.terraform_remote_state.common.outputs.vpc_id
  ingress = [
    {
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups = [
        aws_security_group.ecs_task.id,
        data.terraform_remote_state.common.outputs.codebuild_sg_id,
      ]
      prefix_list_ids = []
      self            = false
      description     = "MySQL"
      protocol        = "tcp"
      from_port       = 3306
      to_port         = 3306
    },
  ]

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}