locals {
  org              = "pins"
  service_name     = "applications"
  primary_location = "uk-west"
  # tflint-ignore: terraform_unused_declarations
  secondary_location = "uk-south"

  # resource_suffix           = "${local.service_name}-${var.environment}"
  # secondary_resource_suffix = "${local.service_name}-secondary-${var.environment}"

  # get the IPs from the ip_blacklist secure file only for prod environment
  # defines the file location and is dependent on preliminarySteps defined in pipeline
  ip_blacklist_file_path = abspath("../ip_blacklist.json")
  # function takes a JSON string and converts it into a Terraform list value
  ip_blacklist_data = jsondecode(file(local.ip_blacklist_file_path))
  # Extracts a list of IP prefixes (IPv4 or IPv6) from the decoded blacklist JSON for use in resources.
  ip_blacklist = [
    for prefix in try(local.ip_blacklist_data.prefixes, [{ ipv4Prefix = "10.255.255.255" }]) :
    lookup(
      prefix,
      "ipv4Prefix",
      lookup(prefix, "ipv6Prefix", null)
    )
  ]
  # Sort the IP blacklist to ensure consistent ordering
  sorted_ip_blacklist = sort(local.ip_blacklist)
  # As file contans 600+ IPs we need to chunk them to avoid hitting resource limits
  ip_blacklist_chunks = chunklist(local.sorted_ip_blacklist, 600)

  tags = merge(
    var.tags,
    {
      CreatedBy   = "terraform"
      Environment = var.environment
      ServiceName = local.service_name
      location    = local.primary_location
    }
  )
}
