variable "region" {
  default = "us-east-1"
}

variable "assume_role" {
  type = object({
    role_arn    = string,
    external_id = string
  })

   default = {
    role_arn    = "arn:aws:iam::794038226274:role/terraform-role"
    external_id = "3b94ec31-9d0d-4b22-9bce-72b6ab95fe1a"
  }
}

variable "remote_backend" {
  type = object({
    bucket = string,
    state_locking = object({
      dynamodb_table_name = string
      dynamodb_table_billing_mode = string
      dynamodb_table_hash_key = string
      dynamodb_table_hash_key_type = string
    })
  })

  default = {
    bucket = "eks-devopsproject-state-files-794038226274"
    state_locking = {
      dynamodb_table_name = "eks-devopsproject-state-locking"
      dynamodb_table_billing_mode = "PAY_PER_REQUEST"
      dynamodb_table_hash_key = "LockID"
      dynamodb_table_hash_key_type = "S"
    }
  }
}

variable "tags" {
  type = object({
    Project     = string
    Environment = string
  })

  default = {
    Project     = "eks-devopsproject"
    Environment = "production"
  }
}

