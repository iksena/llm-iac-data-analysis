output "id" {
  description = "Name of the S3 bucket the configuration is attached to"
  value       = aws_s3_bucket_public_access_block.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_s3_bucket_public_access_block.this.region
}

output "bucket" {
  description = "S3 Bucket to which this Public Access Block configuration is applied"
  value       = aws_s3_bucket_public_access_block.this.bucket
}

output "block_public_acls" {
  description = "Whether Amazon S3 blocks public ACLs for this bucket"
  value       = aws_s3_bucket_public_access_block.this.block_public_acls
}

output "block_public_policy" {
  description = "Whether Amazon S3 blocks public bucket policies for this bucket"
  value       = aws_s3_bucket_public_access_block.this.block_public_policy
}

output "ignore_public_acls" {
  description = "Whether Amazon S3 ignores public ACLs for this bucket"
  value       = aws_s3_bucket_public_access_block.this.ignore_public_acls
}

output "restrict_public_buckets" {
  description = "Whether Amazon S3 restricts public bucket policies for this bucket"
  value       = aws_s3_bucket_public_access_block.this.restrict_public_buckets
}

output "skip_destroy" {
  description = "Whether to retain the public access block upon destruction"
  value       = aws_s3_bucket_public_access_block.this.skip_destroy
}