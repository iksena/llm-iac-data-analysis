# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "sg-0bc61af652e9c65e1"
resource "aws_security_group" "security_group_general" {
  description = "An example security group for Terraform"
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 443
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 443
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 80
  }]
  name                   = "sg"
  name_prefix            = null
  revoke_rules_on_delete = null
  tags = {
    Name    = "sg"
    Owner   = "Valerii Vasianovych"
    Project = "Test Project"
  }
  tags_all = {
    Name    = "sg"
    Owner   = "Valerii Vasianovych"
    Project = "Test Project"
  }
  vpc_id = "vpc-0f47deecc163757a6"
}

# __generated__ by Terraform
resource "aws_instance" "ubuntu_ec2_2" {
  ami                                  = "ami-05c17b22914ce7378"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1a"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = false
  enable_primary_ipv6                  = null
  get_password_data                    = false
  hibernation                          = false
  host_id                              = null
  host_resource_group_arn              = null
  iam_instance_profile                 = "AmazonSSMRoleForInstancesQuickSetup"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  #ipv6_address_count                   = 0
  #ipv6_addresses                       = []
  key_name                             = "aws_ssh_key"
  monitoring                           = false
  placement_group                      = null
  placement_partition_number           = 0
  private_ip                           = "172.31.17.117"
  secondary_private_ips                = []
  security_groups                      = ["sg"]
  source_dest_check                    = true
  subnet_id                            = "subnet-001cbe6a01612ea6c"
  tags = {
    Name    = "ec2-instance-2"
    Owner   = "Valerii Vasianovych"
    Project = "Test Project"
  }
  tags_all = {
    Name    = "ec2-instance-2"
    Owner   = "Valerii Vasianovych"
    Project = "Test Project"
  }
  tenancy                     = "default"
  user_data                   = "18bac5e6fe42c68e723f18009ff37d4cd10bf502"
  user_data_base64            = null
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-0bc61af652e9c65e1"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    amd_sev_snp      = null
    core_count       = 1
    threads_per_core = 1
  }
  credit_specification {
    cpu_credits = "standard"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}

# __generated__ by Terraform
resource "aws_instance" "ubuntu_ec2_1" {
  ami                                  = "ami-05c17b22914ce7378"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1a"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = false
  enable_primary_ipv6                  = null
  get_password_data                    = false
  hibernation                          = false
  host_id                              = null
  host_resource_group_arn              = null
  iam_instance_profile                 = "AmazonSSMRoleForInstancesQuickSetup"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  #ipv6_address_count                   = 0
  #ipv6_addresses                       = []
  key_name                             = "aws_ssh_key"
  monitoring                           = false
  placement_group                      = null
  placement_partition_number           = 0
  private_ip                           = "172.31.25.245"
  secondary_private_ips                = []
  security_groups                      = ["sg"]
  source_dest_check                    = true
  subnet_id                            = "subnet-001cbe6a01612ea6c"
  tags = {
    Name    = "ec2-instance-1"
    Owner   = "Valerii Vasianovych"
    Project = "Test Project"
  }
  tags_all = {
    Name    = "ec2-instance-1"
    Owner   = "Valerii Vasianovych"
    Project = "Test Project"
  }
  tenancy                     = "default"
  user_data                   = "18bac5e6fe42c68e723f18009ff37d4cd10bf502"
  user_data_base64            = null
  user_data_replace_on_change = null
  volume_tags                 = null
  vpc_security_group_ids      = ["sg-0bc61af652e9c65e1"]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    amd_sev_snp      = null
    core_count       = 1
    threads_per_core = 1
  }
  credit_specification {
    cpu_credits = "standard"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    kms_key_id            = null
    tags                  = {}
    tags_all              = {}
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}
