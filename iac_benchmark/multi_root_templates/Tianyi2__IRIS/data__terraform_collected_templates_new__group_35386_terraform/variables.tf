#aws variable
variable "aws_region" {
  type        = string
  description = "AWS region"
  sensitive   = true
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
  sensitive   = true
}

#rds variable
variable "rds_identifier_mlflow" {
  type        = string
  description = "RDS identifier mlflow"
  default     = "mlflow-data"
}

variable "rds_username_mlflow" {
  type        = string
  description = "RDS username mlflow"
  sensitive   = true
}

variable "rds_password_mlflow" {
  type        = string
  description = "RDS password mlflow"
  sensitive   = true
}

variable "rds_db_name_mlflow" {
  type        = string
  description = "RDS db name mlflow"
}

variable "rds_port_mlflow" {
  type        = number
  description = "RDS port mlflow"
  default     = 5432
}

variable "rds_identifier_mage" {
  type        = string
  description = "RDS identifier mage.ai"
  default     = "mage-ai-data"
}

variable "rds_username_mage" {
  type        = string
  description = "RDS username mage"
  sensitive   = true
}

variable "rds_password_mage" {
  type        = string
  description = "RDS password mage"
  sensitive   = true
}

variable "rds_db_name_mage" {
  type        = string
  description = "RDS db name mage"
}

variable "rds_port_mage" {
  type        = number
  description = "RDS port mage"
  default     = 5433
}

variable "rds_engine" {
  type        = string
  description = "RDS engine"
  default     = "postgres"
}

variable "rds_engine_version" {
  type        = string
  description = "RDS engine version"
  # last version
  default     = ""
}

variable "rds_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  type        = number
  description = "RDS allocated storage"
  default     = 20
}

variable "rds_publicly_accessible" {
  type        = bool
  description = "RDS publicly accessible"
  default     = false
}

variable "rds_skip_final_snapshot" {
  type        = bool
  description = "RDS skip final snapshot"
  default     = true
}

#security group
variable "security_group_name_mage" {
  type        = string
  description = "Security Group for mage"
  default     = "aws_sg_mage_ai"
}

variable "security_group_name_mlflow" {
  type        = string
  description = "Security Group for mlflow"
  default     = "aws_sg_mlflow"
}

variable "security_group_name_ec2_mlflow" {
  type        = string
  description = "Security Group for ec2 mlflow"
  default     = "aws_sg_ec2_mlflow"
}

variable "security_group_name_ec2_flask" {
  type        = string
  description = "Security Group for ec2 flask"
  default     = "aws_sg_ec2_flask"
}

variable "security_group_name_ec2_mage" {
  type        = string
  description = "Security Group for ec2 mage"
  default     = "aws_sg_ec2_mage"
}

#s3 variable
variable "s3_bucket_name_mlflow" {
  type        = string
  description = "S3 Bucket name for mlflow"
}

variable "s3_tags" {
  type        = map(string)
  description = "S3 Bucket tags"
  default     = {
    name          = "bucket s3 for mlflow save artifacts"
  }
}

#ec2 variable
variable "ec2_ami" {
  type        = string
  description = "EC2 ami"
  default     = "ami-0ae8f15ae66fe8cda"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ec2_ssh_port" {
  type        = number
  description = "EC2 ssh port"
  default     = 22
}

variable "ec2_public_key" {
  type        = string
  description = "EC2 public key"
  sensitive   = true
}

#ec2 mlflow variable
variable "ec2_mlflow_pip_mlflow" {
  type        = string
  description = "EC2 mlflow pip version"
  default     = "2.14.3"
}

variable "ec2_mlflow_pip_boto3" {
  type        = string
  description = "EC2 boto3 pip version"
  default     = "1.34.145"
}

variable "ec2_mlflow_tags" {
  type        = map(string)
  description = "EC2 mlflow tags"
  default     = {
    name = "ec2 mlflow server"
  }
}

variable "ec2_mlflow_port" {
  type        = number
  description = "EC2 mlflow port"
  default     = 5000
}

#ec2 mage variable
variable "ec2_mage_port" {
  type        = number
  description = "EC2 mage port"
  default     = 6789
}

#ec2 flask variable
variable "ec2_flask_port" {
  type        = number
  description = "EC2 flask port"
  default     = 8080
}

#ecr
variable "ecr_repo_name" {
  type        = string
  description = "ECR imagen tag"
  default     = "rj92-aws-docker-repository"
}

variable "ecr_docker_image_flask_local_path" {
  type        = string
  description = "ECR docker imagen flask local path"
  default     = "./file/flask/Dockerfile"
}

variable "ecr_image_tag" {
  type        = string
  description = "ECR imagen tag"
  default     = "experimental"
}

#project
variable "project_id" {
  type        = string
  description = "Project id"
  default     = "paraguay-public-servant-salary"
}
