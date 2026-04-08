output "resource_record_sets" {
  description = "The resource records sets"
  value       = data.aws_route53_records.this.resource_record_sets
}

output "alias_target" {
  description = "Information about the AWS resource traffic is routed to"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.alias_target
    if record.alias_target != null
  ]
}

output "dns_name" {
  description = "Target DNS name from alias targets"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.alias_target != null ? record.alias_target.dns_name : []
  ])
}

output "evaluate_target_health" {
  description = "Whether an alias resource record set inherits the health of the referenced AWS resource"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.alias_target != null ? record.alias_target.evaluate_target_health : []
  ])
}

output "hosted_zone_id" {
  description = "Target hosted zone ID from alias targets"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.alias_target != null ? record.alias_target.hosted_zone_id : []
  ])
}

output "cidr_routing_config" {
  description = "Information about the CIDR location traffic is routed to"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.cidr_routing_config
    if record.cidr_routing_config != null
  ]
}

output "collection_id" {
  description = "The CIDR collection ID"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.cidr_routing_config != null ? record.cidr_routing_config.collection_id : []
  ])
}

output "location_name" {
  description = "The CIDR collection location name"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.cidr_routing_config != null ? record.cidr_routing_config.location_name : []
  ])
}

output "failover" {
  description = "PRIMARY or SECONDARY"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.failover
    if record.failover != null
  ]
}

output "geolocation" {
  description = "Information about how Amazon Route 53 responds to DNS queries based on the geographic origin of the query"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.geolocation
    if record.geolocation != null
  ]
}

output "continent_code" {
  description = "The two-letter code for the continent"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geolocation != null ? record.geolocation.continent_code : []
  ])
}

output "country_code" {
  description = "The two-letter code for a country"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geolocation != null ? record.geolocation.country_code : []
  ])
}

output "subdivision_code" {
  description = "The two-letter code for a state of the United States"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geolocation != null ? record.geolocation.subdivision_code : []
  ])
}

output "geoproximity_location" {
  description = "Information about how Amazon Route 53 responds to DNS queries based on the geographic origin of the query"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.geoproximity_location
    if record.geoproximity_location != null
  ]
}

output "aws_region" {
  description = "The AWS Region the resource you are directing DNS traffic to, is in"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geoproximity_location != null ? record.geoproximity_location.aws_region : []
  ])
}

output "bias" {
  description = "The bias increases or decreases the size of the geographic region from which Route 53 routes traffic to a resource"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geoproximity_location != null ? record.geoproximity_location.bias : []
  ])
}

output "coordinates" {
  description = "Contains the longitude and latitude for a geographic region"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geoproximity_location != null ? record.geoproximity_location.coordinates : []
  ])
}

output "latitude" {
  description = "Latitude"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geoproximity_location != null && record.geoproximity_location.coordinates != null ?
    record.geoproximity_location.coordinates.latitude : []
  ])
}

output "longitude" {
  description = "Longitude"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geoproximity_location != null && record.geoproximity_location.coordinates != null ?
    record.geoproximity_location.coordinates.longitude : []
  ])
}

output "local_zone_group" {
  description = "An AWS Local Zone Group"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.geoproximity_location != null ? record.geoproximity_location.local_zone_group : []
  ])
}

output "health_check_id" {
  description = "ID of any applicable health check"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.health_check_id
    if record.health_check_id != null
  ]
}

output "multi_value_answer" {
  description = "Traffic is routed approximately randomly to multiple resources"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.multi_value_answer
    if record.multi_value_answer != null
  ]
}

output "name" {
  description = "The name of the record"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.name
  ]
}

output "region" {
  description = "The Amazon EC2 Region of the resource that this resource record set refers to"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.region
    if record.region != null
  ]
}

output "resource_records" {
  description = "The resource records"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.resource_records
    if record.resource_records != null
  ]
}

output "value" {
  description = "The DNS record value"
  value = flatten([
    for record in data.aws_route53_records.this.resource_record_sets :
    record.resource_records != null ? [
      for rr in record.resource_records : rr.value
    ] : []
  ])
}

output "set_identifier" {
  description = "An identifier that differentiates among multiple resource record sets that have the same combination of name and type"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.set_identifier
    if record.set_identifier != null
  ]
}

output "traffic_policy_instance_id" {
  description = "The ID of any traffic policy instance that Route 53 created this resource record set for"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.traffic_policy_instance_id
    if record.traffic_policy_instance_id != null
  ]
}

output "ttl" {
  description = "The resource record cache time to live (TTL), in seconds"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.ttl
    if record.ttl != null
  ]
}

output "type" {
  description = "The DNS record type"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.type
  ]
}

output "weight" {
  description = "Among resource record sets that have the same combination of DNS name and type, a value that determines the proportion of DNS queries that Amazon Route 53 responds to using the current resource record set"
  value = [
    for record in data.aws_route53_records.this.resource_record_sets : record.weight
    if record.weight != null
  ]
}