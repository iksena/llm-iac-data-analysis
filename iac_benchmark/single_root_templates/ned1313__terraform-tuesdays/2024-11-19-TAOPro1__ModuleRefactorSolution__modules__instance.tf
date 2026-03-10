# ── main.tf ────────────────────────────────────
resource "aws_security_group" "allow_http" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.ingress_port
    to_port     = var.ingress_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data                   = var.user_data
  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}

# ── variables.tf ────────────────────────────────────
variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "ingress_port" {
  description = "The port to allow ingress traffic on"
  type        = number
  default     = 80
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = "WebServer"
}

variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "The subnet ID to use for the instance"
  type        = string
}

variable "user_data" {
  description = "The user data to use for the instance"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to use for the security group"
  type        = string

}


# ── outputs.tf ────────────────────────────────────
output "public_dns" {
  value = aws_instance.web.public_dns

}