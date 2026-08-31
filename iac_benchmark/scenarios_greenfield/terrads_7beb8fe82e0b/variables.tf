############################
##  REQUIRED  aws_storagegateway_gateway     
############################
variable "gateway_name" {
  description = "Name of the gateway."
  type        = string
  default     = null
}
variable "gateway_timezone" {
  description = "The time zone is used, for example, for scheduling snapshots and your gateway's maintenance schedule."
  type        = string
  default     = "GMT"
}
variable "disk_node" {
  description = "local cache disk node"
  type        = string
  default     = null
}

############################
##  REQUIRED  s3_bucket   
############################
variable "bucket_name" {
  description = "Name of s3 bucket"
  type        = string
  default     = null
}

############################
##  OPTIONAL  aws_storagegateway_gateway     
############################
variable "activation_key" {
  description = "Gateway activation key during resource creation. Conflicts with gateway_ip_address. "
  type        = string
  default     = null
}
variable "average_download_rate_limit_in_bits_per_sec" {
  description = "he average download bandwidth rate limit in bits per second. This is supported for the CACHED, STORED, and VTL gateway types."
  type        = string
  default     = null
}
variable "average_upload_rate_limit_in_bits_per_sec" {
  description = "The average upload bandwidth rate limit in bits per second. This is supported for the CACHED, STORED, and VTL gateway types."
  type        = string
  default     = null
}
variable "gateway_ip_address" {
  description = "Gateway IP address to retrieve activation key during resource creation. Conflicts with activation_key. "
  type        = string
  default     = null
}
variable "gateway_type" {
  description = "Type of the gateway. The default value is STORED. Valid values: CACHED, FILE_FSX_SMB, FILE_S3, STORED, VTL."
  type        = string
  default     = "FILE_S3"
}
variable "gateway_vpc_endpoint" {
  description = "VPC endpoint address to be used when activating your gateway. This should be used when your instance is in a private subnet."
  type        = string
  default     = null
}
variable "cloudwatch_log_group_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon CloudWatch log group to use to monitor and log events in the gateway."
  type        = string
  default     = null
}
variable "medium_changer_type" {
  description = "Type of medium changer to use for tape gateway. Terraform cannot detect drift of this argument. Valid values: STK-L700, AWS-Gateway-VTL, IBM-03584L32-0402."
  type        = string
  default     = null
}
variable "smb_guest_password" {
  description = "Guest password for Server Message Block (SMB) file shares. Only valid for FILE_S3 and FILE_FSX_SMB gateway types. Must be set before creating GuestAccess authentication SMB file shares. "
  type        = string
  default     = null
}
variable "smb_security_strategy" {
  description = " Specifies the type of security strategy. Valid values are: ClientSpecified, MandatorySigning, and MandatoryEncryption"
  type        = string
  default     = null
}
variable "smb_file_share_visibility" {
  description = "Specifies whether the shares on this gateway appear when listing shares."
  type        = string
  default     = null
}
variable "tape_drive_type" {
  description = "Type of tape drive to use for tape gateway. Terraform cannot detect drift of this argument. Valid values: IBM-ULT3580-TD5."
  type        = string
  default     = null
}

############################
##  OPTIONAL  aws_storagegateway_gateway  maintenance_start_time   
############################
variable "day_of_month" {
  description = "The day of the month component of the maintenance start time represented as an ordinal number from 1 to 28, where 1 represents the first day of the month and 28 represents the last day of the month."
  type        = number
  default     = null
}
variable "day_of_week" {
  description = "The day of the week component of the maintenance start time week represented as an ordinal number from 0 to 6, where 0 represents Sunday and 6 Saturday."
  type        = number
  default     = null
}
variable "hour_of_day" {
  description = "The hour component of the maintenance start time represented as hh, where hh is the hour (00 to 23). The hour of the day is in the time zone of the gateway."
  type        = number
  default     = null
}
variable "minute_of_hour" {
  description = "The minute component of the maintenance start time represented as mm, where mm is the minute (00 to 59). The minute of the hour is in the time zone of the gateway."
  type        = number
  default     = null
}
############################
##  OPTIONAL  aws_storagegateway_gateway  smb_active_directory_settings
############################
variable "domain_name" {
  description = "The name of the domain that you want the gateway to join."
  type        = string
  default     = null
}
variable "active_directory_username" {
  description = "The password of the user who has permission to add the gateway to the Active Directory domain."
  type        = string
  default     = null
}
variable "active_directory_password" {
  description = "The user name of user who has permission to add the gateway to the Active Directory domain."
  type        = string
  default     = null
}
variable "timeout_in_seconds" {
  description = "Specifies the time in seconds, in which the JoinDomain operation must complete. The default is 20 seconds."
  type        = string
  default     = null
}
variable "organizational_unit" {
  description = "The organizational unit (OU) is a container in an Active Directory that can hold users, groups, computers, and other OUs and this parameter specifies the OU that the gateway will join within the AD domain."
  type        = string
  default     = null
}
variable "domain_controllers" {
  description = "List of IPv4 addresses, NetBIOS names, or host names of your domain server. If you need to specify the port number include it after the colon (“:”). For example, mydc.mydomain.com:389."
  type        = list(string)
  default     = null
}

############################
##  REQUIRED  aws_storagegateway_smb_file_share    
############################
variable "gateway_arn" {
  description = "Amazon Resource Name (ARN) of the file gateway."
  type        = string
  default     = null
}
variable "location_arn" {
  description = "The ARN of the backed storage used for storing file data."
  type        = string
  default     = null
}
variable "role_arn" {
  description = "The ARN of the AWS Identity and Access Management (IAM) role that a file gateway assumes when it accesses the underlying storage."
  type        = string
  default     = null
}
############################
##  OPTIONAL  aws_storagegateway_smb_file_share
############################
variable "vpc_endpoint_dns_name" {
  description = "The DNS name of the VPC endpoint for S3 private link."
  type        = string
  default     = null
}
variable "bucket_region" {
  description = "The region of the S3 buck used by the file share. Required when specifying a vpc_endpoint_dns_name."
  type        = string
  default     = null
}
variable "admin_user_list" {
  description = "A list of users in the Active Directory that have admin access to the file share. Only valid if authentication is set to ActiveDirectory."
  type        = list(string)
  default     = null
}
variable "authentication" {
  description = "The authentication method that users use to access the file share. Defaults to ActiveDirectory. Valid values: ActiveDirectory, GuestAccess."
  type        = string
  default     = "GuestAccess"
}
variable "audit_destination_arn" {
  description = "The Amazon Resource Name (ARN) of the CloudWatch Log Group used for the audit logs."
  type        = string
  default     = null
}
variable "default_storage_class" {
  description = "The default storage class for objects put into an Amazon S3 bucket by the file gateway. Defaults to S3_STANDARD."
  type        = string
  default     = "S3_STANDARD"
}
variable "file_share_name" {
  description = "The name of the file share. Must be set if an S3 prefix name is set in location_arn."
  type        = string
  default     = null
}
variable "guess_mime_type_enabled" {
  description = "Boolean value that enables guessing of the MIME type for uploaded objects based on file extensions. Defaults to true."
  type        = bool
  default     = true
}
variable "invalid_user_list" {
  description = "A list of users in the Active Directory that are not allowed to access the file share. Only valid if authentication is set to ActiveDirectory."
  type        = list(string)
  default     = null
}
variable "kms_encrypted" {
  description = " Boolean value if true to use Amazon S3 server side encryption with your own AWS KMS key, or false to use a key managed by Amazon S3."
  type        = bool
  default     = false
}
variable "kms_key_arn" {
  description = "Amazon Resource Name (ARN) for KMS key used for Amazon S3 server side encryption. This value can only be set when kms_encrypted is true."
  type        = string
  default     = null
}
variable "object_acl" {
  description = "Access Control List permission for S3 objects."
  type        = string
  default     = "bucket-owner-full-control"
}
variable "oplocks_enabled" {
  description = "Boolean to indicate Opportunistic lock (oplock) status. "
  type        = bool
  default     = false
}
variable "cache_stale_timeout_in_seconds" {
  description = "Refreshes a file share's cache by using Time To Live (TTL). TTL is the length of time since the last refresh after which access to the directory would cause the file gateway to first refresh that directory's contents from the Amazon S3 bucket. Valid Values: 300 to 2,592,000 seconds, default 1 day"
  type        = number
  default     = 86400
}
variable "read_only" {
  description = "Boolean to indicate write status of file share. File share does not accept writes if true"
  type        = bool
  default     = false
}
variable "requester_pays" {
  description = "Boolean who pays the cost of the request and the data download from the Amazon S3 bucket. Set this value to true if you want the requester to pay instead of the bucket owner."
  type        = bool
  default     = false
}
variable "smb_acl_enabled" {
  description = " Set this value to true to enable ACL (access control list) on the SMB fileshare. Set it to false to map file and directory permissions to the POSIX permissions. This setting applies only to ActiveDirectory authentication type."
  type        = bool
  default     = null
}
variable "case_sensitivity" {
  description = "The case of an object name in an Amazon S3 bucket. For ClientSpecified, the client determines the case sensitivity. For CaseSensitive, the gateway determines the case sensitivity. "
  type        = string
  default     = "ClientSpecified"
}
variable "valid_user_list" {
  description = "A list of users in the Active Directory that are allowed to access the file share. If you need to specify an Active directory group, add '@' before the name of the group. It will be set on Allowed group in AWS console. Only valid if authentication is set to ActiveDirectory."
  type        = list(string)
  default     = null
}
variable "access_based_enumeration" {
  description = "The files and folders on this share will only be visible to users with read access."
  type        = bool
  default     = false
}
variable "notification_policy" {
  description = "he notification policy of the file share. For more information see the AWS Documentation."
  type        = string
  default     = null
}
variable "custom_tags" {
  description = "Extra tags to apply to created objects"
  type        = map
  default     = {}
}
