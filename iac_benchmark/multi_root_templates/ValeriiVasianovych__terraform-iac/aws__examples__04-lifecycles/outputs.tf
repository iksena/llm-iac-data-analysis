output "aws_region" {
  value = data.aws_region.current.name
}

output "aws_region_description" {
  value = data.aws_region.current.description
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.available
}

output "aws_caller_identity" {
  value = data.aws_caller_identity.current
}