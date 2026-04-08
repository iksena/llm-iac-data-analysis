output "aws_region" {
  value = data.aws_region.current.name
} 

output "aws_region_description" {
  value = data.aws_region.current.description
}

output "aws_region_id" {
  value = data.aws_region.current.id
}