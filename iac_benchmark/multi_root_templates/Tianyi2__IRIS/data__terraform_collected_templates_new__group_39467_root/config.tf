# Enable Config via Terraform if it was not enabled before.
# You can only have one Config Recorder. This resource would fail
# if you enabled AWS config manually before.
#resource "aws_config_configuration_recorder" "config-recorder" {
#  name = "aws_config_recorder"
#  role_arn = "${aws_iam_role.aws_config_recorder.arn}"
#}

resource "aws_config_organization_managed_rule" "resourcesTagged" {
  name             = "instanceTagged"
  input_parameters = replace(replace(jsonencode(var.required_tags), "\"", ""), ":", "=")

  rule_identifier = "REQUIRED_TAGS"
}

resource "aws_config_organization_managed_rule" "accessKeyRotated" {
  name             = "access_key_rotated"
  input_parameters = <<EOF
  {
    "maxAccessKeyAge" : "${var.accessKeyRotated_maxAccessKeyAge}"
  }
EOF


  rule_identifier = "ACCESS_KEYS_ROTATED"
}

resource "aws_config_organization_managed_rule" "dbInstanceBackupEnabled" {
  name = "db_instance_backup_enabled"
  # https://docs.aws.amazon.com/config/latest/developerguide/db-instance-backup-enabled.html
  input_parameters = <<EOF
  {
    "backupRetentionPeriod" : "${var.dbInstanceBackupEnabled_RetentionPeriod}",
    "preferredBackupWindow" : "${var.dbInstanceBackupEnabled_PreferredBackupWindow}",
    "checkReadReplicas"     : "${var.dbInstanceBackupEnabled_CheckReadReplicas}"
  }
EOF


  rule_identifier = "DB_INSTANCE_BACKUP_ENABLED"
}

resource "aws_config_organization_managed_rule" "ec2InstanceNoPublicIp" {
  name = "ec2_instance_no_public_ip"

  rule_identifier = "EC2_INSTANCE_NO_PUBLIC_IP"
}

resource "aws_config_organization_managed_rule" "elasticsearchInVpcOnly" {
  name = "elasticsearch_in_vpc_only"

  rule_identifier = "ELASTICSEARCH_IN_VPC_ONLY"
}

resource "aws_config_organization_managed_rule" "elbLoggingEnabled" {
  name = "elb_logging_enabled"
  # https://docs.aws.amazon.com/config/latest/developerguide/elb-logging-enabled.html
  input_parameters = <<EOF
  {
    "s3BucketNames" : "${var.elbLoggingEnabled_s3BucketNames}"
  }
  
EOF


  rule_identifier = "ELB_LOGGING_ENABLED"
}

resource "aws_config_organization_managed_rule" "iamRootAccessKeyCheck" {
  name = "iam_root_access_key_check"

  rule_identifier = "IAM_ROOT_ACCESS_KEY_CHECK"
}

resource "aws_config_organization_managed_rule" "rdsInstancePublicAccessCheck" {
  name = "rds_instance_public_access_check"

  rule_identifier = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
}

## CUSTOM RULES ##
resource "aws_config_organization_custom_rule" "s3WebserverBuckets" {
  name = "s3_webserver_buckets"

  #depends_on = ["aws_config_configuration_recorder.config-recorder", "aws_lambda_permission.s3_webserver_buckets_config_permissions"]
  lambda_function_arn = aws_lambda_function.s3_webserver_buckets.arn
  trigger_types       = ["ScheduledNotification"]
}

resource "aws_config_organization_custom_rule" "iam_console_login" {
  name = "iam_console_login"

  lambda_function_arn = aws_lambda_function.iam_console_login.arn
  trigger_types       = ["ScheduledNotification"]
}

