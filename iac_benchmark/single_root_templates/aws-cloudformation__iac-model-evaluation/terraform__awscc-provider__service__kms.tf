# ── awscc_kms_alias_p1.tf ────────────────────────────────────
# Create AWS KMS Alias via the 'awscc' provider

# Create KMS Key
resource "awscc_kms_key" "this" {
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    }
  )
}

# Create KMS Alias
resource "awscc_kms_alias" "this" {
  alias_name    = "alias/example-kms-alias"
  target_key_id = awscc_kms_key.this.key_id
}


# ── awscc_kms_alias_p2.tf ────────────────────────────────────
# Terraform code to create KMS Alias via the 'awscc' provider

# Create KMS Key
resource "awscc_kms_key" "this" {
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    }
  )
}

# Create KMS Alias
resource "awscc_kms_alias" "this" {
  alias_name    = "alias/example-kms-alias"
  target_key_id = awscc_kms_key.this.key_id
}


# ── awscc_kms_alias_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates KMS Alias, use awscc provider

# Create KMS Key
resource "awscc_kms_key" "this" {
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    }
  )
}

# Create KMS Alias
resource "awscc_kms_alias" "this" {
  alias_name    = "alias/example-kms-alias"
  target_key_id = awscc_kms_key.this.key_id
}


# ── awscc_kms_key_p1.tf ────────────────────────────────────
# Create AWS KMS Key via the 'awscc' provider

resource "awscc_kms_key" "this" {
  description = "KMS Key for root"
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy-For-Root",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    }
  )
}


# ── awscc_kms_key_p2.tf ────────────────────────────────────
# Terraform code to create KMS Key via the 'awscc' provider

resource "awscc_kms_key" "this" {
  description = "KMS Key for root"
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy-For-Root",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    }
  )
}


# ── awscc_kms_key_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates KMS Key, use awscc provider

resource "awscc_kms_key" "this" {
  description = "KMS Key for root"
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy-For-Root",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    }
  )
}


# ── awscc_kms_key_with_tags_p1.tf ────────────────────────────────────
# Create AWS KMS Key with tags via the 'awscc' provider

resource "awscc_kms_key" "this" {
  description            = "KMS Key for root"
  enabled                = "true"
  enable_key_rotation    = "false"
  pending_window_in_days = 30
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy-For-Root",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    },
  )
  tags = [{
    key   = "Name"
    value = "this"
  }]
}


# ── awscc_kms_key_with_tags_p2.tf ────────────────────────────────────
# Terraform code to create KMS Key with tags via the 'awscc' provider

resource "awscc_kms_key" "this" {
  description            = "KMS Key for root"
  enabled                = "true"
  enable_key_rotation    = "false"
  pending_window_in_days = 30
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy-For-Root",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    },
  )
  tags = [{
    key   = "Name"
    value = "this"
  }]
}


# ── awscc_kms_key_with_tags_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates KMS Key with tags, use awscc provider

resource "awscc_kms_key" "this" {
  description            = "KMS Key for root"
  enabled                = "true"
  enable_key_rotation    = "false"
  pending_window_in_days = 30
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "KMS-Key-Policy-For-Root",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::111122223333:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
    ],
    },
  )
  tags = [{
    key   = "Name"
    value = "this"
  }]
}
