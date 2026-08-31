# EC2 Security Group
resource "aws_security_group" "weasel_crm_sg" {
  vpc_id = aws_vpc.weasel_crm_vpc.id

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
  tags = {
    "Name" = "weasel-crm-ec2-sg"
  }
}


resource "aws_security_group" "weasel_crm_sg_ec2" {
  vpc_id = aws_vpc.weasel_crm_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  tags = {
    "Name" = "weasel-crm-ec2-sg"
  }
}



# RDS Security Group
resource "aws_security_group" "weasel_crm_rds_sg" {
  vpc_id = aws_vpc.weasel_crm_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.weasel_crm_sg.id]
  }
  tags = {
    "Name" = "weasel-crm-rds-sg"
  }
}
