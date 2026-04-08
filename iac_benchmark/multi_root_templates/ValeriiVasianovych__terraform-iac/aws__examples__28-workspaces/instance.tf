resource "aws_instance" "instance-ec2" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "Instance-${terraform.workspace}" 
  }
}