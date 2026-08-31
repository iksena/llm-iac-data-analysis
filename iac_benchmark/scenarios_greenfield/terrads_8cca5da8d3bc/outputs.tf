#create outputs for all the data sources for the terraform.tfstate file to get the values with the remote backend
output "cluster_name" {
    value = aws_eks_cluster.k8s_cluster.name
}

output "region" {
  value = var.aws_region
}

output "pg_address" {
  value = aws_db_instance.tfe_db.address
}

output "pg_dbname" {
  value = aws_db_instance.tfe_db.db_name
}

output "pg_user" {
  value = aws_db_instance.tfe_db.username
}

output "pg_password" {
  value = aws_db_instance.tfe_db.password
  sensitive = true
}

output "s3_bucket" {
  value = aws_s3_bucket.s3bucket_data.bucket
}

output "redis_host" {
  value = lookup(aws_elasticache_cluster.tfe_redis.cache_nodes[0], "address", "Redis address not found")
}

output "redis_port" {
  value = lookup(aws_elasticache_cluster.tfe_redis.cache_nodes[0], "port", "Redis port not found")
}

output "kubectl_environment" {
   value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.k8s_cluster.name}"  
}
