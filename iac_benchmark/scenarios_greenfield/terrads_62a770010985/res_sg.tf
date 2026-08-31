// DataDBSecurityGroup

resource "aws_security_group" "DataDB" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.solution_short}-${var.env}-DataDB"
  description = "Security group for Data DB - ${var.solution}-${var.env}"

  tags = {
    Name = "${var.solution_short}-${var.env}-DataDB"
  }
}

resource "aws_security_group_rule" "DataDB_App_Forms" {
  type                     = "ingress"
  description              = "Allow App Forms to access DB via PostgreSQL port"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.App_Forms.id
  security_group_id        = aws_security_group.DataDB.id
}

/*resource "aws_security_group_rule" "DataDB_App_Trainer" {
  type                     = "ingress"
  description = "Allow App to access DB via PostgreSQL port"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.App_Trainer.id
  security_group_id        = aws_security_group.DataDB.id
}*/

// ELB

resource "aws_security_group" "App_Forms_ELB" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.solution_short}-${var.env}-App_Forms_ELB"
  description = "Security group for ALB Forms - ${var.solution}-${var.env}"

  tags = {
    Name = "${var.solution_short}-${var.env}-App_Forms_ELB"
  }
}

/*resource "aws_security_group_rule" "App_Forms_ELB_Internet_HTTP" {
  type              = "ingress"
    description = "Allow Users to access LB via HTTP protocol"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.App_Forms_ELB.id
}*/

resource "aws_security_group_rule" "App_Forms_ELB_Internet_HTTPS" { #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  type              = "ingress"
  description       = "Allow Users to access LB via HTTPs protocol"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.App_Forms_ELB.id
}

resource "aws_security_group_rule" "App_Forms_ELB_OUT" {
  type              = "egress"
  description       = "Allow LB to access the App Forms"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.App_Forms_ELB.id
}

//App-Core Instance

resource "aws_security_group" "App_Forms" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.solution_short}-${var.env}-App_Forms"
  description = "Security group for App Forms - ${var.solution}-${var.env}"

  tags = {
    Name = "${var.solution_short}-${var.env}-App_Forms"
  }
}

resource "aws_security_group_rule" "ELB_App_Forms" {
  type                     = "ingress"
  description              = "Allow LB to access the App Forms"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.App_Forms_ELB.id
  security_group_id        = aws_security_group.App_Forms.id
}

resource "aws_security_group_rule" "App_Forms_OUT" { #tfsec:ignore:aws-vpc-no-public-egress-sgr
  type              = "egress"
  description       = "Allow App Forms to access Internet"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.App_Forms.id
}

//App-Trainer Instance

resource "aws_security_group" "App_Trainer" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.solution_short}-${var.env}-App_Trainer"
  description = "Security group for App Trainer - ${var.solution}-${var.env}"

  tags = {
    Name = "${var.solution_short}-${var.env}-App_Trainer"
  }
}

resource "aws_security_group_rule" "App_Trainer_OUT" { #tfsec:ignore:aws-vpc-no-public-egress-sgr
  type              = "egress"
  description       = "Allow App Trainer to access Internet"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.App_Trainer.id
}

//Splunk Instance

resource "aws_security_group" "Splunk_Instance" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.solution_short}-${var.env}-Splunk_Instance"
  description = "Security group for Splunk instances - ${var.solution}-${var.env}"

  tags = {
    Name = "${var.solution_short}-${var.env}-Splunk_Instance"
  }
}

resource "aws_security_group_rule" "Splunk_Instance_IN" {
  type              = "ingress"
  description       = "Allow logs traffic to Splunk"
  from_port         = 9997
  to_port           = 9997
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.Splunk_Instance.id
}

resource "aws_security_group_rule" "Splunk_Instance_OUT" { #tfsec:ignore:aws-vpc-no-public-egress-sgr
  type              = "egress"
  description       = "Allow Splunk to access Internet"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.Splunk_Instance.id
}

resource "aws_security_group" "InterfaceEndpoint" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.solution_short}-${var.env}-InterfaceEndpoint"
  description = "Security group Interface EndPoint VPC - ${var.solution}-${var.env}"

  tags = {
    Name = "${var.solution_short}-${var.env}-InterfaceEndpoint"
  }
}

resource "aws_security_group_rule" "InterfaceEndpoint_ingress_http" {
  type              = "ingress"
  description       = "Allow access for Interface Endpoint for HTTP"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.InterfaceEndpoint.id
}

resource "aws_security_group_rule" "InterfaceEndpoint_ingress_https" {
  type              = "ingress"
  description       = "Allow access for Interface Endpoint for HTTPS"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.InterfaceEndpoint.id
}

resource "aws_security_group_rule" "InterfaceEndpoint_egress" { #tfsec:ignore:aws-vpc-no-public-egress-sgr
  type        = "egress"
  description = "Allow access for Interface Endpoint"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  #cidr_blocks       = [var.vpc_cidr_block]
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.InterfaceEndpoint.id
}
