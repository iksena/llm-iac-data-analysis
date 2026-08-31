output "saml_arn" {
  value = try(aws_iam_saml_provider.vss[0].arn, "")
}
output "saml_valid_until" {
  value = try(aws_iam_saml_provider.vss[0].valid_until, "")
}
output "user_arn" {
  value = try(aws_iam_user.vss[0].arn, "")
}
output "user_name" {
  value = try(aws_iam_user.vss[0].name, "")
}
output "user_unique_id" {
  value = try(aws_iam_user.vss[0].unique_id, "")
}
output "access_key_create_date" {
  value = try(aws_iam_access_key.vss[0].create_date, "")
}
output "access_key_id" {
  value = try(aws_iam_access_key.vss[0].id, "")
}
output "access_key_secret" {
  value = try(aws_iam_access_key.vss[0].secret, "")
}
output "access_key_encrypted_secret" {
  value = try(aws_iam_access_key.vss[0].encrypted_secret, "")
}
output "access_key_key_fingerprint" {
  value = try(aws_iam_access_key.vss[0].key_fingerprint, "")
}
output "access_key_ses_smtp_password_v4" {
  value = try(aws_iam_access_key.vss[0].ses_smtp_password_v4, "")
}
output "access_key_encrypted_ses_smtp_password_v4" {
  value = try(aws_iam_access_key.vss[0].encrypted_ses_smtp_password_v4, "")
}
output "policy_id" {
  value = try(aws_iam_policy.vss[0].id, "")
}
output "policy_arn" {
  value = try(aws_iam_policy.vss[0].arn, "")
}
output "policy_name" {
  value = try(aws_iam_policy.vss[0].name, "")
}
output "policy_policy" {
  value = try(aws_iam_policy.vss[0].policy, "")
}
output "policy_policy_id" {
  value = try(aws_iam_policy.vss[0].policy_id, "")
}
output "role_id" {
  value = try(aws_iam_role.vss[0].id, "")
}
output "role_arn" {
  value = try(aws_iam_role.vss[0].arn, "")
}
output "role_name" {
  value = try(aws_iam_role.vss[0].name, "")
}
output "role_unique_id" {
  value = try(aws_iam_role.vss[0].unique_id, "")
}
output "profile_id" {
  value = try(aws_iam_instance_profile.vss[0].id, "")
}
output "profile_arn" {
  value = try(aws_iam_instance_profile.vss[0].arn, "")
}
output "group_id" {
  value = try(aws_iam_group.vss[0].id, "")
}
output "group_arn" {
  value = try(aws_iam_group.vss[0].arn, "")
}
output "group_name" {
  value = try(aws_iam_group.vss[0].name, "")
}
output "group_unique_id" {
  value = try(aws_iam_group.vss[0].unique_id, "")
}
output "group_membership_name" {
  value = try(aws_iam_group_membership.vss[0].name, "")
}
output "group_membership_users" {
  value = try(aws_iam_group_membership.vss[0].users, "")
}
output "group_membership_group" {
  value = try(aws_iam_group_membership.vss[0].group, "")
}