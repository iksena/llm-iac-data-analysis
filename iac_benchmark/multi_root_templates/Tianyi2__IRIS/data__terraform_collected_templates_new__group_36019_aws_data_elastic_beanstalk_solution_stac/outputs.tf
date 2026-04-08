output "name" {
  description = "Name of the solution stack."
  value       = data.aws_elastic_beanstalk_solution_stack.this.name
}