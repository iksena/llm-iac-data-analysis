output "s3_bucket_id" {
  value = join("", aws_s3_bucket.s3.*.id)
}

output "s3_bucket_arn" {
  value = join("", aws_s3_bucket.s3.*.arn)
}

output "s3_bucket_name" {
  value = var.name
}

output "s3_bucket_regional_domain_name" {
  value = join("", aws_s3_bucket.s3.*.bucket_regional_domain_name)
}

output "iam_policy_rw_arn" {
  value = join("", aws_iam_policy.rw.*.arn)
}

output "iam_policy_rw_id" {
  value = join("", aws_iam_policy.rw.*.id)
}

output "iam_policy_rw_name" {
  value = join("", aws_iam_policy.rw.*.name)
}

output "iam_policy_ro_arn" {
  value = join("", aws_iam_policy.ro.*.arn)
}

output "iam_policy_ro_id" {
  value = join("", aws_iam_policy.ro.*.id)
}

output "iam_policy_ro_name" {
  value = join("", aws_iam_policy.ro.*.name)
}

output "iam_user_rw_arn" {
  value = join("", aws_iam_user.rw.*.arn)
}

output "iam_user_rw_id" {
  value = join("", aws_iam_user.rw.*.id)
}

output "iam_user_rw_name" {
  value = join("", aws_iam_user.rw.*.name)
}

output "iam_user_ro_arn" {
  value = join("", aws_iam_user.ro.*.arn)
}

output "iam_user_ro_id" {
  value = join("", aws_iam_user.ro.*.id)
}

output "iam_user_ro_name" {
  value = join("", aws_iam_user.ro.*.name)
}
