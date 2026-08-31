output "ec2_instances_info" {
  description = "Cyber ec2 instances info"
  value = try({
    for ec2 in module.ec2_instance : ec2.tags_all.Name =>
    {
      "name" : ec2.tags_all.Name,
      "id" : ec2.id,
      "private_ip" : ec2.private_ip,
      "public_ip" : ec2.public_ip,
      "private_key_location" : "s3://${resource.aws_s3_bucket.main.id}/${aws_s3_bucket_object.ssh_key[ec2.tags_all.fameMachineId].id}",
    }
  }, "")
}
