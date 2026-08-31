resource "aws_cloudwatch_event_rule" "required_tags" {
  event_bus_name = "default"
  event_pattern = jsonencode(
    {
      detail = {
        configRuleName = [
          "required-tags"
        ]
        resourceType = [
          "AWS::EC2::Instance",
          "AWS::RDS::DBInstance",
          "AWS::EC2::Volume",
          "AWS::EFS::FileSystem",
          "AWS::Backup::BackupSelection",
          "AWS::DynamoDB::Table",
        ]
      }
      detail-type = [
        "Config Rules Compliance Change"
      ]
      source = [
        "aws.config"
      ]
    }
  )
  name = "${var.name_prefix}-backup-notifications${local.name_suffix}"
}

resource "aws_cloudwatch_event_target" "aws_backup_to_sns" {
  arn            = aws_sns_topic.infrastructure_alerts.arn
  event_bus_name = "default"
  rule           = aws_cloudwatch_event_rule.required_tags.name
  target_id      = "${var.name_prefix}-backup-notifications${local.name_suffix}"
}