output "terraform_super_admin_access_key_id" {
  value = aws_iam_access_key.terraform_super_admin.id
}
output "terraform_super_admin_access_key_encrytped_secret" {
  value = aws_iam_access_key.terraform_super_admin.encrypted_secret
}

output "terraform_admin_access_key_id" {
  value = aws_iam_access_key.terraform_admin.id
}
output "terraform_admin_access_key_encrytped_secret" {
  value = aws_iam_access_key.terraform_admin.encrypted_secret
}

output "project_iam_id" {
  value = aws_organizations_account.iam.id
}
