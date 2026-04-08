output "id" {
  description = "AWS Region."
  value       = data.aws_glue_script.this.id
}

output "python_script" {
  description = "Python script generated from the DAG when the language argument is set to PYTHON."
  value       = data.aws_glue_script.this.python_script
}

output "scala_code" {
  description = "Scala code generated from the DAG when the language argument is set to SCALA."
  value       = data.aws_glue_script.this.scala_code
}