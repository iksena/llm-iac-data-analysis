variable "aws_subnets" {
	type = list(string)
	default = [
		"10.0.0.0/16",
		"10.1.0.0/24"
	]
}

variable "gcp_subnets" {
  type = list(string)
  default = [
    "172.16.0.0/21"
  ]
}

variable "owner" {
	type = string
	default = "benchmark"
}

variable "se-region" {
	type = string
	default = "us-east-1"
}

variable "purpose" {
	type = string
	default = "benchmark"
}

variable "ttl" {
	type = number
	default = 30
}

variable "terraform" {
	type = bool
	default = true
}

variable "hc-internet-facing" {
	type = bool
	default = false
}

variable "tfc_organization" {
  type = string
  default = "tfo-apj-demos"
}