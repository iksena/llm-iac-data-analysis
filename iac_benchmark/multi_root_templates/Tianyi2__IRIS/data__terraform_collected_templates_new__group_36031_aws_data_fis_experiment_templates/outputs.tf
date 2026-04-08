output "ids" {
  description = "List of all the experiment template ids found."
  value       = data.aws_fis_experiment_templates.this.ids
}