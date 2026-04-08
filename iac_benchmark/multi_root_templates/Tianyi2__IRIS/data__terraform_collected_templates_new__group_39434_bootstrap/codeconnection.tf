resource "aws_codestarconnections_connection" "this" {
  name          = var.boostrap_name
  provider_type = "GitHub"
}

resource "aws_codebuild_source_credential" "this" {
  server_type = "GITHUB"
  auth_type   = "CODECONNECTIONS"
  token       = aws_codestarconnections_connection.this.arn
}