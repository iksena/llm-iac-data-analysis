/*
title: basic-cicd-s3-pipeline
desc: Builds a codepipeline and codebuild job attached to an S3 backed cloudfront distribution to deploy changes as the source code changes.
partners: static-site, github-status-updater
*/

provider "aws" {
  region = var.aws_region
}

terraform {
}

data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "target_bucket" {
  bucket = var.s3_bucket
}

data "aws_ssm_parameter" "gh_secret" {
  count = var.codestar_connection_arn == "" ? 1 : 0

  name = var.gh_secret_sm_param_name
}

data "aws_ssm_parameter" "gh_token" {
  count = var.codestar_connection_arn == "" ? 1 : 0

  name = var.gh_token_sm_param_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_bucket" {
  count = var.encrypt_buckets == true ? 1 : 0
  
  bucket = aws_s3_bucket.build_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_logging" "bucket_logging" {
  count = var.access_log_bucket == "" ? 0 : 1

  bucket = aws_s3_bucket.build_bucket.id
  target_bucket = var.access_log_bucket
  target_prefix = var.access_log_prefix
}

resource "aws_s3_bucket" "build_bucket" {

  tags = {
    Name = "Static site build bucket"
    Site = var.site_name
  }

  force_destroy = true

}

resource "aws_s3_bucket_policy" "require_secure_transport" {
  bucket = aws_s3_bucket.build_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "BUCKET-POLICY"
    Statement = [
      {
        Sid       = "EnforceTls"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "${aws_s3_bucket.build_bucket.arn}/*",
          "${aws_s3_bucket.build_bucket.arn}",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "block_build_bucket_pub_access" {
  bucket = aws_s3_bucket.build_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "code_build_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "code_pipeline_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["codepipeline.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "code_build_policy_document" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
    ]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      data.aws_s3_bucket.target_bucket.arn,
      "${data.aws_s3_bucket.target_bucket.arn}/*",
      aws_s3_bucket.build_bucket.arn,
      "${aws_s3_bucket.build_bucket.arn}/*"
    ]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]
    //resources = formatlist("arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter%s", var.secure_build_environment)
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "code_pipeline_policy_document" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      aws_s3_bucket.build_bucket.arn,
      "${aws_s3_bucket.build_bucket.arn}/*"
    ]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning"
    ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = [
      "arn:aws:codestar-connections:${var.aws_region}:${data.aws_caller_identity.current.account_id}:connection/*"
    ]
  }
}

resource "aws_iam_policy" "code_build_policy" {
  policy = data.aws_iam_policy_document.code_build_policy_document.json
}

resource "aws_iam_policy" "code_pipeline_policy" {
  policy = data.aws_iam_policy_document.code_pipeline_policy_document.json
}

resource "aws_iam_role" "code_build_role" {
  assume_role_policy = data.aws_iam_policy_document.code_build_assume_policy.json
}

resource "aws_iam_role" "code_pipeline_role" {
  assume_role_policy = data.aws_iam_policy_document.code_pipeline_assume_policy.json
}

resource "aws_iam_policy_attachment" "attach_cb_policy_to_role" {
  name        = "basic-cicd-build-${var.site_name}-${var.cf_distribution}-cb-attach"
  roles       = [aws_iam_role.code_build_role.name]
  policy_arn  = aws_iam_policy.code_build_policy.arn
}

resource "aws_iam_policy_attachment" "attach_cp_policy_to_role" {
  name        = "basic-cicd-build-${var.site_name}-${var.cf_distribution}-cp-attach"
  roles       = [aws_iam_role.code_pipeline_role.name]
  policy_arn  = aws_iam_policy.code_pipeline_policy.arn
}

resource "aws_iam_role_policy_attachment" "cb_role_user_policies" {
  count       = length(var.build_role_policies)

  role        = aws_iam_role.code_build_role.name
  policy_arn  = element(var.build_role_policies, count.index)
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = "basic-cicd-build-${var.gh_repo}-${var.gh_branch}-${var.cf_distribution}"
  description   = "build site ${var.site_name} for CF dist ${var.cf_distribution} from repo ${var.gh_repo} using branch ${var.gh_branch}"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.code_build_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.allow_root

    environment_variable {
      name  = "TARGET_BUCKET"
      value = var.s3_bucket
    }

    environment_variable {
      name  = "INVALIDATE"
      value = var.cf_invalidate
    }

    environment_variable {
      name  = "DISTRIBUTION_ID"
      value = var.cf_distribution
    }

    dynamic "environment_variable" {
      for_each = var.build_environment

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }

    dynamic "environment_variable" {
      for_each = var.secure_build_environment

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }

  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "random_uuid" "notify_name" { }

resource "aws_codestarnotifications_notification_rule" "notifications" {
  count = var.send_notifications == true ? 1 : 0

  detail_type     = "FULL"
  event_type_ids  = var.notifications_to_send
  name            = random_uuid.notify_name.result
  resource        = aws_codepipeline.buildpipeline.arn

  target {
    address = var.sns_topic_for_notifications
  }
}

resource "aws_codepipeline" "buildpipeline" {
  name        = "basic-cicd-pipeline-${var.gh_repo}-${var.gh_branch}-${var.cf_distribution}"
  role_arn    = aws_iam_role.code_pipeline_role.arn

  artifact_store {
    location  = aws_s3_bucket.build_bucket.bucket
    type      = "S3"
  }

  stage {
    name = "Source"

    // this is the GH v1 connection
    dynamic "action" {
      for_each = var.codestar_connection_arn == "" ? [ "blah" ] : []

      content {
        name              = "Source"
        category          = "Source"
        owner             = "ThirdParty"
        provider          = "GitHub"
        version           = "1"
        output_artifacts  = [ var.gh_branch ]

        configuration = {
          Owner                 = var.gh_username
          Repo                  = var.gh_repo
          Branch                = var.gh_branch
          OAuthToken            = data.aws_ssm_parameter.gh_token.0.value
          PollForSourceChanges  = false
        }
      }
    }

    // this is the GH v2 connection
    dynamic "action" {
      for_each = var.codestar_connection_arn != "" ? [ "blah" ] : []

      content {
        name              = "Source"
        category          = "Source"
        owner             = "AWS"
        provider          = "CodeStarSourceConnection"
        version           = "1"
        output_artifacts  = [var.gh_branch]

        configuration = {
          ConnectionArn    = var.codestar_connection_arn
          FullRepositoryId = "${var.gh_username}/${var.gh_repo}"
          BranchName       = var.gh_branch
          DetectChanges    = true
        }
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = [var.gh_branch]
      version         = "1"

      configuration = {
        ProjectName = "basic-cicd-build-${var.gh_repo}-${var.gh_branch}-${var.cf_distribution}"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "webhook" {
  count = var.codestar_connection_arn == "" ? 1 : 0

  name            = "github-${var.gh_repo}-${var.gh_branch}-${var.cf_distribution}"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.buildpipeline.name

  authentication_configuration {
    secret_token = data.aws_ssm_parameter.gh_secret.0.value
  }

  filter {
    json_path     = "$.ref"
    match_equals  = "refs/heads/{Branch}"
  }
}