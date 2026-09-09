#####EC2 INSTANCE#####
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_iam_role" "terraform_ec2_ssm" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_ec2_ssm" {
  role       = aws_iam_role.terraform_ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "terraform_ec2_ssm" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-profile"
  role = aws_iam_role.terraform_ec2_ssm.name
}

resource "aws_instance" "terraform_ec2" {
 associate_public_ip_address = false #(set to true if you want to add public ip, makesure to switch the private subnet to public)
 count = var.ec2_instance_count
 instance_type = var.ec2_instance_type
 ami           = var.ec2_instance_image != "" ? var.ec2_instance_image : data.aws_ami.amazon_linux.id
 iam_instance_profile = aws_iam_instance_profile.terraform_ec2_ssm.name
 vpc_security_group_ids = [aws_security_group.terraform_ec2_sg.id]
 ebs_optimized = true
 availability_zone = "us-east-1a"
 subnet_id = aws_subnet.terraform_private_subnet_a.id
 tags = merge(var.standard_tags, {
    Name                 = "${var.project_name}-${var.environment}-ec2-${count.index}"
  })
} 
#####ALB & Target groups#####
resource "aws_lb" "terraform_elb" {
 name = "${var.project_name}-${var.environment}-alb"
 load_balancer_type = "application"
 subnets = [aws_subnet.terraform_public_subnet_a.id, aws_subnet.terraform_public_subnet_b.id]
 security_groups = [aws_security_group.terraform_lb_sg.id]
 enable_deletion_protection = true
 tags = merge(var.standard_tags, {
    Name                 = "${var.project_name}-${var.environment}-alb"
  }) 
}

resource "aws_lb_target_group" "terraform_tg" {
 name = "${var.project_name}-${var.environment}-tg"
 target_type = "ip"
 port = 80
 protocol = "HTTP"
 vpc_id = aws_vpc.main.id
 tags = merge(var.standard_tags, {
    Name                 = "${var.project_name}-${var.environment}-tg"
  }) 
}

resource "aws_lb_target_group_attachment" "terraform_tg_attach" {
  count            = var.ec2_instance_count
  target_group_arn = aws_lb_target_group.terraform_tg.arn
  target_id        = aws_instance.terraform_ec2.*.id[count.index]
  port             = 80
  depends_on       = [aws_instance.terraform_ec2]
}