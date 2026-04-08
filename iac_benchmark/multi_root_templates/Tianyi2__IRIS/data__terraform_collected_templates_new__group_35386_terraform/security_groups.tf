resource "aws_security_group" "rds_mlflow_sg" {
  name        = var.security_group_name_mlflow
  description = "Security group ${var.security_group_name_mlflow} for ${var.rds_identifier_mlflow}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [
      name,
      description,
    ]
  }

}

resource "aws_security_group" "rds_mage_ai_sg" {
  name        =  var.security_group_name_mage
  description = "Security group ${var.security_group_name_mage} for ${var.rds_identifier_mage}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [
      name,
      description,
    ]
  }

}

resource "aws_security_group" "ec2_mlflow_sg" {
  name        =  var.security_group_name_ec2_mlflow
  description = "Security group ${var.security_group_name_ec2_mlflow} for ec2"

  ingress {
    from_port   = var.ec2_ssh_port
    to_port     = var.ec2_ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ingress {
  #  from_port   = aws_db_instance.mlflow_rds.port
  #  to_port     = aws_db_instance.mlflow_rds.port
  #  protocol    = "tcp"
  #  security_groups = [aws_security_group.rds_mlflow_sg.arn]
  #}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [
      name,
      description,
    ]
  }

}

resource "aws_security_group" "ec2_flask_sg" {
  name        =  var.security_group_name_ec2_flask
  description = "Security group ${var.security_group_name_ec2_flask} for ec2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = var.ec2_ssh_port
    to_port     = var.ec2_ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ec2_flask_port
    to_port     = var.ec2_flask_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [
      name,
      description,
    ]
  }

}

resource "aws_security_group" "ec2_mage_ai_sg" {
  name        =  var.security_group_name_ec2_mage
  description = "Security group ${var.security_group_name_ec2_mage} for ec2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = var.ec2_ssh_port
    to_port     = var.ec2_ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ec2_mage_port
    to_port     = var.ec2_mage_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ingress {
  #  from_port   = aws_db_instance.mage_ai_rds.port
  #  to_port     = aws_db_instance.mage_ai_rds.port
  #  protocol    = "tcp"
  #  security_groups = [aws_security_group.rds_mage_ai_sg.id]
  #}

  egress {
    from_port   = aws_db_instance.mage_ai_rds.port
    to_port     = aws_db_instance.mage_ai_rds.port
    protocol    = "tcp"
    security_groups = [aws_security_group.rds_mage_ai_sg.id]
  }

  lifecycle {
    ignore_changes = [
      name,
      description,
    ]
  }

}

resource "aws_security_group_rule" "rds_mlflow_ingress" {
  type              = "ingress"
  from_port         = aws_db_instance.mlflow_rds.port
  to_port           = aws_db_instance.mlflow_rds.port
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_mlflow_sg.id
  source_security_group_id = aws_security_group.ec2_mlflow_sg.id
}

resource "aws_security_group_rule" "rds_mage_ai_ingress" {
  type              = "ingress"
  from_port         = aws_db_instance.mage_ai_rds.port
  to_port           = aws_db_instance.mage_ai_rds.port
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_mage_ai_sg.id
  source_security_group_id = aws_security_group.ec2_mage_ai_sg.id
}

resource "aws_security_group_rule" "ec2_mlflow_ingress_from_mage_ai" {
  type              = "ingress"
  from_port         = var.ec2_mlflow_port
  to_port           = var.ec2_mlflow_port
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2_mlflow_sg.id
  source_security_group_id = aws_security_group.ec2_mage_ai_sg.id

  depends_on = [
    aws_security_group.ec2_mlflow_sg,
    aws_security_group.ec2_mage_ai_sg
  ]
}

resource "aws_security_group_rule" "ec2_mlflow_ingress_from_flask" {
  type              = "ingress"
  from_port         = var.ec2_mlflow_port
  to_port           = var.ec2_mlflow_port
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2_mlflow_sg.id
  source_security_group_id = aws_security_group.ec2_flask_sg.id

  depends_on = [
    aws_security_group.ec2_mlflow_sg,
    aws_security_group.ec2_flask_sg
  ]
}

resource "aws_security_group_rule" "ec2_mage_ai_egress_to_mlflow" {
  type                = "egress"
  from_port           = var.ec2_mlflow_port
  to_port             = var.ec2_mlflow_port
  protocol            = "tcp"
  security_group_id   = aws_security_group.ec2_mage_ai_sg.id
  source_security_group_id = aws_security_group.ec2_mlflow_sg.id

  depends_on = [
    aws_security_group.ec2_mage_ai_sg,
    aws_security_group.ec2_mlflow_sg
  ]
}
