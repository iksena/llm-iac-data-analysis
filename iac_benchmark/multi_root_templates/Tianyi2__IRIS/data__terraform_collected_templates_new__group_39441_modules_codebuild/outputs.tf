output "aws_iam_role_name" {
  value = aws_iam_role.build.name
}

output "name" {
  value = aws_codebuild_project.build.name
}

output "arn" {
  value = aws_codebuild_project.build.arn
}
