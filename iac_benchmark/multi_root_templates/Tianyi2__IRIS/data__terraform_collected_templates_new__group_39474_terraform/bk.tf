resource "aws_iam_instance_profile" "unity_dapa_instance_profile" {
  name = "unity-dapa-instance-profile-tf"

  role = var.role

  tags = {
    Name = "unity_dapa_instance_profile"
  }

}

resource "aws_instance" "unity_dapa_instance" {
  ami           = var.ami
  instance_type = "t2.micro"

  tags = {
    Name = "unity-dapa-instance-tf"
  }

  #key_name = var.key_name

  vpc_security_group_ids = [var.sg_id]

  subnet_id = var.subnet_id

  iam_instance_profile = aws_iam_instance_profile.unity_dapa_instance_profile.name

  user_data = file("./add-dapa.sh")

}
