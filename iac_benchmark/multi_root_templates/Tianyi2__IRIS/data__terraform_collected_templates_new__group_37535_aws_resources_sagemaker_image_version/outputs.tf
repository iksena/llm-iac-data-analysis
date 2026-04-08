output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Image Version."
  value       = aws_sagemaker_image_version.this.arn
}

output "version" {
  description = "The version of the image. If not specified, the latest version is described."
  value       = aws_sagemaker_image_version.this.version
}

output "container_image" {
  description = "The registry path of the container image that contains this image version."
  value       = aws_sagemaker_image_version.this.container_image
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_sagemaker_image_version.this.region
}

output "image_name" {
  description = "The name of the image."
  value       = aws_sagemaker_image_version.this.image_name
}

output "base_image" {
  description = "The registry path of the container image on which this image version is based."
  value       = aws_sagemaker_image_version.this.base_image
}

output "aliases" {
  description = "A list of aliases for the image version."
  value       = aws_sagemaker_image_version.this.aliases
}

output "horovod" {
  description = "Indicates Horovod compatibility."
  value       = aws_sagemaker_image_version.this.horovod
}

output "job_type" {
  description = "Indicates SageMaker AI job type compatibility."
  value       = aws_sagemaker_image_version.this.job_type
}

output "ml_framework" {
  description = "The machine learning framework vended in the image version."
  value       = aws_sagemaker_image_version.this.ml_framework
}

output "processor" {
  description = "Indicates CPU or GPU compatibility."
  value       = aws_sagemaker_image_version.this.processor
}

output "programming_lang" {
  description = "The supported programming language and its version."
  value       = aws_sagemaker_image_version.this.programming_lang
}

output "release_notes" {
  description = "The maintainer description of the image version."
  value       = aws_sagemaker_image_version.this.release_notes
}

output "vendor_guidance" {
  description = "The stability of the image version, specified by the maintainer."
  value       = aws_sagemaker_image_version.this.vendor_guidance
}