
resource "aws_instance" "instance-1" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg-1.id]
  tags = {
    Name = "Instance-1"
    Environment = "Production"
  }
}