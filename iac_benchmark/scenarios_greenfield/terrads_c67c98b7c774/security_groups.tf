resource "aws_security_group" "terraform_lb_sg" {
 name        = "${var.project_name}-${var.environment}-alb-security-group"
 description = "Terraform ALB security group"
 vpc_id      = aws_vpc.main.id
 egress      = [
                {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 0
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "-1"
                security_groups  = []
                self             = false
                to_port          = 0
                },
               ]
 ingress     = [
                {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 0
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "-1"
                security_groups  = []
                self             = false
                to_port          = 0
                },
               ]              
 tags = merge(var.standard_tags, {
    Name                 = "${var.project_name}-${var.environment}-alb-security-group"
  })
}
##############################################
##############################################
resource "aws_security_group" "terraform_ec2_sg" {
 name        = "${var.project_name}-${var.environment}-ec2-security-group"
 description = "Terraform EC2 security group"
 vpc_id      = aws_vpc.main.id
 egress      = [
                {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 0
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "-1"
                security_groups  = []
                self             = false
                to_port          = 0
                },
               ]
 ingress     = [
                {
                cidr_blocks      = [
                "0.0.0.0/0",
                ]
                description      = ""
                from_port        = -1
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "icmp"
                security_groups  = []
                self             = false
                to_port          = -1
                },
                {
                cidr_blocks      = [
                "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 22
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "tcp"
                security_groups  = []
                self             = false
                to_port          = 22
                },
                {
                cidr_blocks      = [
                "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 443
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "tcp"
                security_groups  = []
                self             = false
                to_port          = 443
                },
                {
                cidr_blocks      = [
                "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 80
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "tcp"
                security_groups  = []
                self             = false
                to_port          = 80
                },
               ]            
 tags = merge(var.standard_tags, {
    Name                 = "${var.project_name}-${var.environment}-ec2-security-group"
  })
}
##################################################
##################################################