variable "bucket_prefix" {
    default = "mytestbucket"
}

variable "env" {
    default = "dev"
}

variable "s3_bucket_names" {
  type = map(list(string))
  default = {
        source1 = ["log1a.veerum", "log1b.veerum"]
        source2 = ["log2a.veerum", "log2b.veerum"]
    }
}

variable "kms_key_alias" {
  type = map(list(string))
  default = {
        source1 = ["log1a.veerum", "log1b.veerum"]
        source2 = ["log2a.veerum", "log2b.veerum"]
    }
}
