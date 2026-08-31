variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "gh_username" {
  type = string
  description = "GitHub username used to access your site source code repo"
}

variable "gh_secret_sm_param_name" {
  type = string
  default = ""
  description = "name of SSM parameter where GitHub webhook secret is stored"
}

variable "gh_token_sm_param_name" {
  type = string
  default = ""
  description = "name of SSM parameter where the GitHub Oauth token is stored"
}

variable "gh_repo" {
  type = string
  description = "name of repo containing site source and buildspec.yml file"
}

variable "gh_branch" {
  type = string
  default = "master"
  description = "branch of git repo to use for changes"
}

variable "site_name" {
  type = string
  description = "FQDN of site e.g. www.example.com"
}

variable "cf_distribution" {
  type = string
  description = "ID of the CF distribution to be updated on each deployment"
}

variable "s3_bucket" {
  type = string
  description = "S3 bucket where the files behind the CF distribution are placed"
}

variable "build_timeout" {
  default = 5
  type = number
  description = "how long should we wait (in minutes) before assuming a build has failed"
}

variable "cf_invalidate" {
  default = "yes"
  type = string
  description = "should the CF distribution be invalidated for each deployment"
}

variable "encrypt_buckets" {
  type = bool
  default = false
  description = "encrypt buckets with default AWS keys"
}

variable "allow_root" {
  type = bool
  default = false
  description = "allow build process to become root (sudo)"
}

variable "build_image" {
  type = string
  default = "aws/codebuild/standard:2.0"
  description = "what build image should be used to run the build job"
}

variable "send_notifications" {
  type = bool
  default = false
  description = "should pipeline notifications be sent"
}

variable "sns_topic_for_notifications" {
  type = string
  description = "arn for sns topic to send notifications to"
  default = ""
}

variable "notifications_to_send" {
  type = list(string)
  description = "which notifications should we send, for values see here https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api"
  default = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-resumed",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-pipeline-execution-superseded"
  ]
} 

variable "access_log_bucket" {
  type = string
  default = ""
  description = "bucket to be used for access logging on the pipeline s3 bucket"
}

variable "access_log_prefix" {
  type = string
  default = ""
  description = "prefix to use for pipeline bucket access logs where that is enabled"
}

variable "build_role_policies" {
  description = "list of ARNs of policies to attach to the build role"
  default = []
  type = list(string)
}

variable "build_environment" {
  description = "non secret build environment variables"
  default = []
  type = list(object({
    name = string,
    value = string
  }))
}

variable "secure_build_environment" {
  description = "secret build environment variables"
  default = []
  type = list(object({
    name = string,
    value = string,
    type = string
  }))
}

variable "build_compute_type" {
  type = string
  default = "BUILD_GENERAL1_SMALL"
  description = "compute type for the build job"
}

variable "codestar_connection_arn" {
  type = string
  description = "ARN for the codestar connection to use to access github"
  default = ""
}