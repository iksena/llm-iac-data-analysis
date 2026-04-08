resource "aws_eip" "eip" {
    instance = aws_instance.instance-ec2.id
  tags = {
    Name = "EIP-${terraform.workspace}"
  }
}