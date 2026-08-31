## Output for the AWS Region
output "region" {
  description = "The AWS region used for the deployment"
  value       = var.region
}

## Output for AWS EC2 Instances 
data "aws_instances" "asg_instances" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.weasel_crm_asg.name
  }
}

output "ec2_instance_ids" {
  description = "List of IDs of EC2 instances"
  value       = data.aws_instances.asg_instances.ids
}
#
## Output for AWS RDS Instance
output "aws_db_instance_id" {
  value = aws_db_instance.weasel_crm_rds.id
}

## Output for AWS S3 Bucket
output "aws_s3_bucket_id" {
  value = aws_s3_bucket.private_bucket.id
}

## Output for AWS ELB
output "aws_elb_dns_name" {
  value = aws_elb.weasel_crm_elb.dns_name
}
