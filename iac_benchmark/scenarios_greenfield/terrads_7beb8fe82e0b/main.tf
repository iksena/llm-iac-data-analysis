terraform {
  required_version = ">= 0.12"
}

# Storage gateway
resource "aws_storagegateway_gateway" "gateway" {
  gateway_name                                = var.gateway_name
  gateway_timezone                            = var.gateway_timezone
  gateway_ip_address                          = var.gateway_ip_address
  gateway_type                                = var.gateway_type
  activation_key                              = var.activation_key
  average_download_rate_limit_in_bits_per_sec = var.average_download_rate_limit_in_bits_per_sec
  average_upload_rate_limit_in_bits_per_sec   = var.average_upload_rate_limit_in_bits_per_sec
  gateway_vpc_endpoint                        = var.gateway_vpc_endpoint
  cloudwatch_log_group_arn                    = var.cloudwatch_log_group_arn
  medium_changer_type                         = var.medium_changer_type
  smb_guest_password                          = var.smb_guest_password
  smb_security_strategy                       = var.smb_security_strategy
  smb_file_share_visibility                   = var.smb_file_share_visibility
  tape_drive_type                             = var.tape_drive_type

  maintenance_start_time {
    day_of_month   = var.day_of_month
    day_of_week    = var.day_of_week
    hour_of_day    = var.hour_of_day
    minute_of_hour = var.minute_of_hour
  }

  tags = var.custom_tags
}

resource "aws_storagegateway_smb_file_share" "smb" {
  gateway_arn              = aws_storagegateway_gateway.gateway.arn
  location_arn             = var.location_arn
  vpc_endpoint_dns_name    = var.vpc_endpoint_dns_name
  bucket_region            = var.bucket_region
  role_arn                 = aws_iam_role.gateway.arn
  admin_user_list          = var.admin_user_list
  authentication           = var.authentication
  audit_destination_arn    = var.audit_destination_arn
  default_storage_class    = var.default_storage_class
  file_share_name          = var.file_share_name
  guess_mime_type_enabled  = var.guess_mime_type_enabled
  invalid_user_list        = var.invalid_user_list
  kms_encrypted            = var.kms_encrypted
  kms_key_arn              = var.kms_key_arn
  object_acl               = var.object_acl
  oplocks_enabled          = var.oplocks_enabled
  read_only                = var.read_only
  requester_pays           = var.requester_pays
  smb_acl_enabled          = var.smb_acl_enabled
  case_sensitivity         = var.case_sensitivity
  valid_user_list          = var.valid_user_list
  access_based_enumeration = var.access_based_enumeration
  notification_policy      = var.notification_policy

  cache_attributes {
    cache_stale_timeout_in_seconds = var.cache_stale_timeout_in_seconds
  }

  tags = var.custom_tags
}

#Setup cache locol disk

data "aws_storagegateway_local_disk" "localdisk" {
  disk_node   = var.disk_node
  gateway_arn = aws_storagegateway_gateway.gateway.arn
}

resource "aws_storagegateway_cache" "localdisk" {
  disk_id     = data.aws_storagegateway_local_disk.localdisk.id
  gateway_arn = aws_storagegateway_gateway.gateway.arn
}

# Assume default amz storagegateway role
data "aws_iam_policy_document" "storagegateway" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["storagegateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3-bucket-access" {
  statement {
    actions = [
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:ListBucketMultipartUploads"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}"
    ]
  }

  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectVersion",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "s3-bucket-access" {
  policy = data.aws_iam_policy_document.s3-bucket-access.json

}

resource "aws_iam_role" "gateway" {
  name               = "${var.gateway_name}-role"
  assume_role_policy = data.aws_iam_policy_document.storagegateway.json

  tags = var.custom_tags
}

resource "aws_iam_role_policy_attachment" "gateway-attach" {
  role       = aws_iam_role.gateway.name
  policy_arn = aws_iam_policy.s3-bucket-access.arn
}