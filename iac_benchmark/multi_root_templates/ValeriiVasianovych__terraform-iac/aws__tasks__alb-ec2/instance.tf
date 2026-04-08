resource "aws_instance" "ubuntu_ec2" {
    count = var.count_instance
    ami = data.aws_ami.latest_ubuntu.id
    instance_type = var.instance_type
    key_name = var.key_name
    user_data = file("${path.module}/install-nginx.sh")
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    tags = {
        Name = "ec2-instance-${count.index + 1}-alb-${var.env}"
    }
}

