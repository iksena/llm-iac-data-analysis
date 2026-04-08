resource "doppler_secret" "aws_access_key_id" {
  config  = "prod"
  name    = "AWS_ACCESS_KEY_ID"
  project = "appkom-passwords"
  value   = aws_iam_access_key.appkom.secret
}

resource "doppler_secret" "aws_secret_access_key" {
  config  = "prod"
  name    = "AWS_SECRET_ACCESS_KEY"
  project = "appkom-passwords"
  value   = aws_iam_access_key.appkom.id
}
