# IaCGen Benchmark Report

Run date: 2026-03-11T11:32:33.488725Z
Model: generate_cfn (skill)
Skills used: generate_cfn, validate_cfn
Live deployment: skipped (skip_deploy=true)
Total prompts: 153

***

## Results Table

| Row | Ground Truth Template | Status | YAML | cfn-lint | Deploy | Error Summary |
|-----|-----------------------|--------|------|----------|--------|---------------|
| 0 | Data\groud_truth\template\sqs_easy.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 1 | Data\groud_truth\template\sns_easy.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 2 | Data\groud_truth\template\s3_easy.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 3 | Data\groud_truth\template\s3_webhost_and_deletion_policy.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 4 | Data\groud_truth\template\ec2_easy.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 5 | Data\groud_truth\template\DynamoDB_easy.yaml |   | ❌ | ❌ | ⏭️ | generation failed |
| 6 | Data\groud_truth\template\EC2InstanceWithSecurityGroupSample.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 7 | Data\groud_truth\template\virtualmachine.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 8 | Data\groud_truth\template\CloudWatch_Dashboard_NAT_FlowLogs.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 9 | Data\groud_truth\template\EFS_encrypted_one_zone.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 10 | Data\groud_truth\template\EC2_Instance_With_Ephemeral_Drives.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 11 | Data\groud_truth\template\dynamo.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 12 | Data\groud_truth\template\EIP_With_Association.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 13 | Data\groud_truth\template\InstanceWithCfnInit.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 14 | Data\groud_truth\template\SingleENIwithMultipleEIPs.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 15 | Data\groud_truth\template\apigateway_lambda_integration.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 16 | Data\groud_truth\template\glue-for-cloudtrail.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 17 | Data\groud_truth\template\billing-alarms.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 18 | Data\groud_truth\template\dynamodb_with_eventbridge.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 19 | Data\groud_truth\template\eventbridge.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 20 | Data\groud_truth\template\CloudWatch_Dashboard_ClientVPN.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 21 | Data\groud_truth\template\ts_tables.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 22 | Data\groud_truth\template\DynamoDB_Secondary_Indexes.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 23 | Data\groud_truth\template\DynamoDB_Table.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 24 | Data\groud_truth\template\Elasticache-snapshot.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 25 | Data\groud_truth\template\iot_sns_sqs.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 26 | Data\groud_truth\template\s3_sns.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 27 | Data\groud_truth\template\sam_kinesis.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 28 | Data\groud_truth\template\sns_for_secret_manager.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 29 | Data\groud_truth\template\parameter-store-demo.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 30 | Data\groud_truth\template\efs-provisioned.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 31 | Data\groud_truth\template\codedeploy.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 32 | Data\groud_truth\template\LambdaSample.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 33 | Data\groud_truth\template\lab3.1.4.iamrole.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 34 | Data\groud_truth\template\RDS_PIOPS.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 35 | Data\groud_truth\template\RDS_Snapshot_On_Delete.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 36 | Data\groud_truth\template\RDS_with_DBParameterGroup.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 37 | Data\groud_truth\template\compliant-bucket.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 38 | Data\groud_truth\template\S3_LambdaTrigger.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 39 | Data\groud_truth\template\ecr.yaml |  which i | ❌ | ❌ | ⏭️ | generation failed |
| 40 | Data\groud_truth\template\SQSFIFOQueue.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 41 | Data\groud_truth\template\SQSStandardQueue.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 42 | Data\groud_truth\template\FindInMapAZs.yaml |  with a pair of public and  | ❌ | ❌ | ⏭️ | generation failed |
| 43 | Data\groud_truth\template\lab2.2.4.create.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 44 | Data\groud_truth\template\VPC_With_Managed_NAT_And_Private_Subnet.yaml |  you | ❌ | ❌ | ⏭️ | generation failed |
| 45 | Data\groud_truth\template\DataFirehoseDeliveryStream.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 46 | Data\groud_truth\template\recovery.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 47 | Data\groud_truth\template\lab3.1.3.iamrole.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 48 | Data\groud_truth\template\010_resources.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 49 | Data\groud_truth\template\ecs_serverless_with_fargate.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 50 | Data\groud_truth\template\url2png-loadtest.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 51 | Data\groud_truth\template\loadbalancer.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 52 | Data\groud_truth\template\Route53-ARC-routing-control.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 53 | Data\groud_truth\template\010_emr_serverless.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 54 | Data\groud_truth\template\central_alert.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 55 | Data\groud_truth\template\client_security_group.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 56 | Data\groud_truth\template\cognito_userpool.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 57 | Data\groud_truth\template\simple_ecs.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 58 | Data\groud_truth\template\efs_file_system.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 59 | Data\groud_truth\template\kinesis-data-stream.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 60 | Data\groud_truth\template\kms-key.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 61 | Data\groud_truth\template\route53-hosted-zone-private.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 62 | Data\groud_truth\template\rds_2db_instance.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 63 | Data\groud_truth\template\rds_psql_export.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 64 | Data\groud_truth\template\arch6-lab3.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 65 | Data\groud_truth\template\lambda_template.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 66 | Data\groud_truth\template\create_vpc_example.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 67 | Data\groud_truth\template\cloudwatch-config-s3-bucket.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 68 | Data\groud_truth\template\ssm-cloudwatch-instance-role.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 69 | Data\groud_truth\template\s3_dynamodb.yaml |  Security Group |  S3 Bucket |  | ❌ | ❌ |
| 70 | Data\groud_truth\template\base-network.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 71 | Data\groud_truth\template\resource-dependencies-challenge.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 72 | Data\groud_truth\template\code-server-stack.yaml |  web-based VS Code devel | ❌ | ❌ | ⏭️ | generation failed |
| 73 | Data\groud_truth\template\easy-ecs-cluster.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 74 | Data\groud_truth\template\task-def-book.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 75 | Data\groud_truth\template\CPUStressInstances.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 76 | Data\groud_truth\template\setup-users.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 77 | Data\groud_truth\template\dynamo-tables.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 78 | Data\groud_truth\template\ipam.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 79 | Data\groud_truth\template\iam-policies.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 80 | Data\groud_truth\template\bedrock-agent-role.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 81 | Data\groud_truth\template\patch-resource-group.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 82 | Data\groud_truth\template\alb-notebook-access-logsbucket.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 83 | Data\groud_truth\template\tgw.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 84 | Data\groud_truth\template\macie.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 85 | Data\groud_truth\template\CloudWatch2S3-bucket.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 86 | Data\groud_truth\template\guardduty.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 87 | Data\groud_truth\template\essentials.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 88 | Data\groud_truth\template\sc-s3-launchrole.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 89 | Data\groud_truth\template\security-hub.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 90 | Data\groud_truth\template\ec2-image-builder.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 91 | Data\groud_truth\template\bucket_for_vpc.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 92 | Data\groud_truth\template\BashScriptAssociation.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 93 | Data\groud_truth\template\BashScriptAssociationTags.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 94 | Data\groud_truth\template\BashScriptSSMAutomation.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 95 | Data\groud_truth\template\BashScriptSSMAutomationTags.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 96 | Data\groud_truth\template\network-stack.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 97 | Data\groud_truth\template\organization_data_pipeline.yaml |  | ❌ | ❌ | ⏭️ | generation failed |
| 98 | Data\groud_truth\template\web.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 99 | Data\groud_truth\template\pattern3-base.yaml |  multi-AZ VPC architectu | ❌ | ❌ | ⏭️ | generation failed |
| 100 | Data\groud_truth\template\baseline-iam.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 101 | Data\groud_truth\template\vpc-flow-logs-custom.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 102 | Data\groud_truth\template\risk_management.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 103 | Data\groud_truth\template\security-lab-stack.yaml |  monitored web applicati | ❌ | ❌ | ⏭️ | generation failed |
| 104 | Data\groud_truth\template\sample_environment_template.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 105 | Data\groud_truth\template\automation_role.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 106 | Data\groud_truth\template\bucket_and_notification.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 107 | Data\groud_truth\template\APIGateway_SQS_ReceiveMessages.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 108 | Data\groud_truth\template\cognito_sample.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 109 | Data\groud_truth\template\mongoDB.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 110 | Data\groud_truth\template\crossAccResources.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 111 | Data\groud_truth\template\DataDogApiDestination.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 112 | Data\groud_truth\template\sns-sqs.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 113 | Data\groud_truth\template\sns_with_events.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 114 | Data\groud_truth\template\b2bi.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 115 | Data\groud_truth\template\sns-secretsmanager.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 116 | Data\groud_truth\template\sns_with_sqs.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 117 | Data\groud_truth\template\DynamoDB_to_EventBridge.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 118 | Data\groud_truth\template\EventBridge_Pipes_with_API_destinations.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 119 | Data\groud_truth\template\event-kinesis.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 120 | Data\groud_truth\template\sqs-pipes-batch-service.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 121 | Data\groud_truth\template\eventbridge-schedule-to-ssm.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 122 | Data\groud_truth\template\ShopifyAPIDestination.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 123 | Data\groud_truth\template\stripe.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 124 | Data\groud_truth\template\api_with_dynamoDB.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 125 | Data\groud_truth\template\apigateway_ses.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 126 | Data\groud_truth\template\apigateway_kinesis.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 127 | Data\groud_truth\template\efs_easy.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 128 | Data\groud_truth\template\securityhub-controls.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 129 | Data\groud_truth\template\config.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 130 | Data\groud_truth\template\account-password-policy.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 131 | Data\groud_truth\template\alert.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 132 | Data\groud_truth\template\batch-demo.template.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 133 | Data\groud_truth\template\arch7-lab1.template.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 134 | Data\groud_truth\template\lambda-demo.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 135 | Data\groud_truth\template\cloudfront-demo-api.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 136 | Data\groud_truth\template\permission-boundary-demo.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 137 | Data\groud_truth\template\appsync-demo.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 138 | Data\groud_truth\template\arch-lab1-demo.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 139 | Data\groud_truth\template\custom-resource-example.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 140 | Data\groud_truth\template\stepfunction-calculator.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 141 | Data\groud_truth\template\stepfunction-recognition.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 142 | Data\groud_truth\template\systems-manager-demo.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 143 | Data\groud_truth\template\arch7-lab6.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 144 | Data\groud_truth\template\arch7-lab2.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 145 | Data\groud_truth\template\cloudfront-demo.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 146 | Data\groud_truth\template\adv-dev-lab3.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 147 | Data\groud_truth\template\slot-machine-website.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 148 | Data\groud_truth\template\multiaz.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 149 | Data\groud_truth\template\efs.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 150 | Data\groud_truth\template\redis-minimal.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 151 | Data\groud_truth\template\bedrock-agent.yaml | ❌ | ❌ | ⏭️ | generation failed | — |
| 152 | Data\groud_truth\template\template-rds-proxy.yaml |  scalable Amazon Aurora  | ❌ | ❌ | ⏭️ | generation failed |

***

## Summary Statistics

| Metric | Value |
|--------|-------|
| Total prompts | 153 |
| ✅ Overall passed (YAML + cfn-lint) | 0 |
| ❌ Overall failed | 153 |
| Overall pass rate | 0.0% |
| ✅ YAML syntax passed | 0 |
| ✅ cfn-lint passed | 0 |
| Most common error type | generation |

***

## Failure Analysis

### YAML Syntax Errors
- Row 0: None
- Row 1: None
- Row 2: None
- Row 3: None
- Row 4: None
- Row 6: None
- Row 7: None
- Row 8: None
- Row 9: None
- Row 10: None
- Row 11: None
- Row 12: None
- Row 13: None
- Row 14: None
- Row 15: None
- Row 16: None
- Row 17: None
- Row 18: None
- Row 19: None
- Row 20: None
- Row 21: None
- Row 22: None
- Row 23: None
- Row 24: None
- Row 25: None
- Row 26: None
- Row 27: None
- Row 28: None
- Row 29: None
- Row 30: None
- Row 31: None
- Row 32: None
- Row 33: None
- Row 34: None
- Row 35: None
- Row 36: None
- Row 37: None
- Row 38: None
- Row 40: None
- Row 41: None
- Row 43: None
- Row 45: None
- Row 46: None
- Row 47: None
- Row 48: None
- Row 49: None
- Row 50: None
- Row 51: None
- Row 52: None
- Row 53: None
- Row 54: None
- Row 55: None
- Row 56: None
- Row 57: None
- Row 58: None
- Row 59: None
- Row 60: None
- Row 61: None
- Row 62: None
- Row 63: None
- Row 64: None
- Row 65: None
- Row 66: None
- Row 67: None
- Row 68: None
- Row 70: None
- Row 71: None
- Row 73: None
- Row 74: None
- Row 75: None
- Row 76: None
- Row 77: None
- Row 78: None
- Row 79: None
- Row 80: None
- Row 81: None
- Row 82: None
- Row 83: None
- Row 84: None
- Row 85: None
- Row 86: None
- Row 87: None
- Row 88: None
- Row 89: None
- Row 90: None
- Row 91: None
- Row 92: None
- Row 93: None
- Row 94: None
- Row 95: None
- Row 96: None
- Row 98: None
- Row 100: None
- Row 101: None
- Row 102: None
- Row 104: None
- Row 105: None
- Row 106: None
- Row 107: None
- Row 108: None
- Row 109: None
- Row 110: None
- Row 111: None
- Row 112: None
- Row 113: None
- Row 114: None
- Row 115: None
- Row 116: None
- Row 117: None
- Row 118: None
- Row 119: None
- Row 120: None
- Row 121: None
- Row 122: None
- Row 123: None
- Row 124: None
- Row 125: None
- Row 126: None
- Row 127: None
- Row 128: None
- Row 129: None
- Row 130: None
- Row 131: None
- Row 132: None
- Row 133: None
- Row 134: None
- Row 135: None
- Row 136: None
- Row 137: None
- Row 138: None
- Row 139: None
- Row 140: None
- Row 141: None
- Row 142: None
- Row 143: None
- Row 144: None
- Row 145: None
- Row 146: None
- Row 147: None
- Row 148: None
- Row 149: None
- Row 150: None
- Row 151: None

### cfn-lint Errors

### Unknown / Parse Failures

***

## Notes
- Report generated by parse_and_report.py from results_summary.csv
