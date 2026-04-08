resource "aws_sagemaker_image_version" "this" {
  image_name       = var.image_name
  base_image       = var.base_image
  aliases          = var.aliases
  horovod          = var.horovod
  job_type         = var.job_type
  ml_framework     = var.ml_framework
  processor        = var.processor
  programming_lang = var.programming_lang
  release_notes    = var.release_notes
  vendor_guidance  = var.vendor_guidance
}