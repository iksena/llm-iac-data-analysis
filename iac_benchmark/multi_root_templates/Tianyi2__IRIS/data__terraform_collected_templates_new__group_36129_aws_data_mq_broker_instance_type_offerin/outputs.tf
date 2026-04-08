output "broker_instance_options" {
  description = "List of broker instance options"
  value       = data.aws_mq_broker_instance_type_offerings.this.broker_instance_options
}

output "availability_zones" {
  description = "List of available Availability Zones from all broker instance options"
  value = flatten([
    for option in data.aws_mq_broker_instance_type_offerings.this.broker_instance_options : [
      for az in option.availability_zones : {
        name = az.name
      }
    ]
  ])
}

output "engine_types" {
  description = "List of engine types from all broker instance options"
  value = distinct([
    for option in data.aws_mq_broker_instance_type_offerings.this.broker_instance_options :
    option.engine_type
  ])
}

output "host_instance_types" {
  description = "List of host instance types from all broker instance options"
  value = distinct([
    for option in data.aws_mq_broker_instance_type_offerings.this.broker_instance_options :
    option.host_instance_type
  ])
}

output "storage_types" {
  description = "List of storage types from all broker instance options"
  value = distinct([
    for option in data.aws_mq_broker_instance_type_offerings.this.broker_instance_options :
    option.storage_type
  ])
}

output "supported_deployment_modes" {
  description = "List of supported deployment modes from all broker instance options"
  value = distinct(flatten([
    for option in data.aws_mq_broker_instance_type_offerings.this.broker_instance_options :
    option.supported_deployment_modes
  ]))
}

output "supported_engine_versions" {
  description = "List of supported engine versions from all broker instance options"
  value = distinct(flatten([
    for option in data.aws_mq_broker_instance_type_offerings.this.broker_instance_options :
    option.supported_engine_versions
  ]))
}