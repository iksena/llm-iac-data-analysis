output "region" {
    value = data.aws_region.current.name
}

output "describe_region" {
    value = data.aws_region.current
}

output "availability_zones" {
    value = data.aws_availability_zones.available.names
}

output "vpc_id" {
    value = data.aws_vpc.default.id
}

output "subnet_ids" {
    value = data.aws_subnet_ids.default.ids
}