resource "aws_security_group" "sg-forgotted" {
  name        = "sg_forgotted"
  description = "Allows HTTP HTTPS"
  dynamic "ingress" {
    for_each = [80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "SG-test-forgotted"
    Environment = "Test"
  }
}
# resource "aws_security_group" "sg-2-test" {
#   name        = "sg_test_two"
#   description = "Allows HTTP HTTPS"
#   dynamic "ingress" {
#     for_each = [80, 443]
#     content {
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name  = "SG-test-1"
#     Environment = "Test"
#   }
# }