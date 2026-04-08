output "name" {
  description = "The name of the response plan."
  value       = data.aws_ssmincidents_response_plan.this.name
}

output "tags" {
  description = "The tags applied to the response plan."
  value       = data.aws_ssmincidents_response_plan.this.tags
}

output "display_name" {
  description = "The long format of the response plan name. This field can contain spaces."
  value       = data.aws_ssmincidents_response_plan.this.display_name
}

output "chat_channel" {
  description = "The Chatbot chat channel used for collaboration during an incident."
  value       = data.aws_ssmincidents_response_plan.this.chat_channel
}

output "engagements" {
  description = "The Amazon Resource Name (ARN) for the contacts and escalation plans that the response plan engages during an incident."
  value       = data.aws_ssmincidents_response_plan.this.engagements
}

output "incident_template" {
  description = "The incident template configuration."
  value       = data.aws_ssmincidents_response_plan.this.incident_template
}

output "incident_template_title" {
  description = "The title of a generated incident."
  value       = try(data.aws_ssmincidents_response_plan.this.incident_template[0].title, null)
}

output "incident_template_impact" {
  description = "The impact value of a generated incident."
  value       = try(data.aws_ssmincidents_response_plan.this.incident_template[0].impact, null)
}

output "incident_template_dedupe_string" {
  description = "A string used to stop Incident Manager from creating multiple incident records for the same incident."
  value       = try(data.aws_ssmincidents_response_plan.this.incident_template[0].dedupe_string, null)
}

output "incident_template_incident_tags" {
  description = "The tags assigned to an incident template."
  value       = try(data.aws_ssmincidents_response_plan.this.incident_template[0].incident_tags, null)
}

output "incident_template_summary" {
  description = "The summary of an incident."
  value       = try(data.aws_ssmincidents_response_plan.this.incident_template[0].summary, null)
}

output "incident_template_notification_target" {
  description = "The Amazon Simple Notification Service (Amazon SNS) targets that this incident notifies when it is updated."
  value       = try(data.aws_ssmincidents_response_plan.this.incident_template[0].notification_target, null)
}

output "incident_template_notification_target_sns_topic_arn" {
  description = "The ARN of the Amazon SNS topic."
  value       = try([for nt in data.aws_ssmincidents_response_plan.this.incident_template[0].notification_target : nt.sns_topic_arn][0], null)
}

output "action" {
  description = "The actions that the response plan starts at the beginning of an incident."
  value       = data.aws_ssmincidents_response_plan.this.action
}

output "action_ssm_automation" {
  description = "The Systems Manager automation document to start as the runbook at the beginning of the incident."
  value       = try(data.aws_ssmincidents_response_plan.this.action[0].ssm_automation, null)
}

output "action_ssm_automation_document_name" {
  description = "The automation document's name."
  value       = try(data.aws_ssmincidents_response_plan.this.action[0].ssm_automation[0].document_name, null)
}

output "action_ssm_automation_role_arn" {
  description = "The Amazon Resource Name (ARN) of the role that the automation document assumes when it runs commands."
  value       = try(data.aws_ssmincidents_response_plan.this.action[0].ssm_automation[0].role_arn, null)
}

output "action_ssm_automation_document_version" {
  description = "The version of the automation document to use at runtime."
  value       = try(data.aws_ssmincidents_response_plan.this.action[0].ssm_automation[0].document_version, null)
}

output "action_ssm_automation_target_account" {
  description = "The account that runs the automation document."
  value       = try(data.aws_ssmincidents_response_plan.this.action[0].ssm_automation[0].target_account, null)
}

output "action_ssm_automation_parameter" {
  description = "The key-value pair parameters used when the automation document runs."
  value       = try(data.aws_ssmincidents_response_plan.this.action[0].ssm_automation[0].parameter, null)
}

output "action_ssm_automation_dynamic_parameters" {
  description = "The key-value pair used to resolve dynamic parameter values when processing a Systems Manager Automation runbook."
  value       = try(data.aws_ssmincidents_response_plan.this.action[0].ssm_automation[0].dynamic_parameters, null)
}

output "integration" {
  description = "Information about third-party services integrated into the response plan."
  value       = data.aws_ssmincidents_response_plan.this.integration
}

output "integration_pagerduty" {
  description = "Details about the PagerDuty configuration for a response plan."
  value       = try(data.aws_ssmincidents_response_plan.this.integration[0].pagerduty, null)
}

output "integration_pagerduty_name" {
  description = "The name of the PagerDuty configuration."
  value       = try(data.aws_ssmincidents_response_plan.this.integration[0].pagerduty[0].name, null)
}

output "integration_pagerduty_service_id" {
  description = "The ID of the PagerDuty service that the response plan associates with an incident when it launches."
  value       = try(data.aws_ssmincidents_response_plan.this.integration[0].pagerduty[0].service_id, null)
}

output "integration_pagerduty_secret_id" {
  description = "The ID of the AWS Secrets Manager secret that stores your PagerDuty key and other user credentials."
  value       = try(data.aws_ssmincidents_response_plan.this.integration[0].pagerduty[0].secret_id, null)
}