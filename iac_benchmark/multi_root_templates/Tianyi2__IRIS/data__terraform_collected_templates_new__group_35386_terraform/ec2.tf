resource "aws_key_pair" "key_pair_paraguay_public_servan" {
  key_name   = "key_pair_paraguay_public_servan"
  public_key = var.ec2_public_key

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_instance" "mlflow_ec2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.key_pair_paraguay_public_servan.key_name
  vpc_security_group_ids = [data.aws_vpc.default.id]
  subnet_id              = data.aws_subnets.default_subnets.ids[0]
  iam_instance_profile   = aws_iam_instance_profile.mlflow_ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y python3-pip
    pip3 install mlflow==${var.ec2_mlflow_pip_mlflow}
    pip3 install boto3==${var.ec2_mlflow_pip_boto3}
    pip3 install psycopg2-binary
    echo "MLFLOW_BACKEND_STORE_URI=postgresql://${aws_db_instance.mlflow_rds.username}:${aws_db_instance.mlflow_rds.password}@${aws_db_instance.mlflow_rds.address}:${aws_db_instance.mlflow_rds.port}/${aws_db_instance.mlflow_rds.db_name}" >> /etc/environment
    echo "MLFLOW_ARTIFACT_ROOT=s3://${aws_s3_bucket.mlflow_artifacts.bucket}/" >> /etc/environment
    sudo systemctl restart mlflow
  EOF

  tags = var.ec2_mlflow_tags
}

resource "aws_instance" "flask_ec2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.key_pair_paraguay_public_servan.key_name
  vpc_security_group_ids = [aws_security_group.ec2_flask_sg.id]
  subnet_id              = data.aws_subnets.default_subnets.ids[1]
  iam_instance_profile   = aws_iam_instance_profile.flask_ec2_profile.name

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com",
      "docker pull ${aws_ecr_repository.rj92_aws_docker_repository.repository_url}:${data.aws_ecr_image.flask_image.image_tag}",
      "docker run -d -p ${var.ec2_flask_port}:${var.ec2_flask_port} ${aws_ecr_repository.rj92_aws_docker_repository.repository_url}:${data.aws_ecr_image.flask_image.image_tag}"
    ]

  }

}

resource "aws_instance" "mage_ai_ec2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.key_pair_paraguay_public_servan.key_name

  vpc_security_group_ids = [aws_security_group.ec2_mage_ai_sg.id]
  subnet_id              = data.aws_subnets.default_subnets.ids[2]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "docker pull mageai/mageai:latest",
      "docker run -d -p 6789:6789 --name mageai -v $(pwd):/home/mageai/mage_ai mageai/mageai:latest"
    ]
  }
}
