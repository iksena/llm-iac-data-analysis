resource "aws_ecr_repository" "rj92_aws_docker_repository" {
  name = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  force_delete = true
}

resource null_resource ecr_image {
  
   triggers = {
     docker_file = md5(file(var.ecr_docker_image_flask_local_path))
   }

   provisioner "local-exec" {
     command = <<EOF
             aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
             cd ./file/flask
             docker build -t ${aws_ecr_repository.rj92_aws_docker_repository.repository_url}:${var.ecr_image_tag} .
             docker push ${aws_ecr_repository.rj92_aws_docker_repository.repository_url}:${var.ecr_image_tag}
         EOF
   }

}

data aws_ecr_image flask_image {
 depends_on = [null_resource.ecr_image]

 repository_name = var.ecr_repo_name
 image_tag       = var.ecr_image_tag
}
