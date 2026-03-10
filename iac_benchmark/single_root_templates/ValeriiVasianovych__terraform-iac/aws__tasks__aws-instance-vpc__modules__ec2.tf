# ── main.tf ────────────────────────────────────
resource "aws_instance" "this" {
  ami             = var.instance_ami 
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]

  tags = merge(
    var.common_tags,
    {
    Name = "Latest Ubuntu EC2 Instance ${var.instance_ami}"
    }
  )
}

# ── variables.tf ────────────────────────────────────
variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

# ── outputs.tf ────────────────────────────────────
output "instance_id" {
  value = aws_instance.this.id
}

output "instance_public_ip" {
  value = aws_instance.this.public_ip
}