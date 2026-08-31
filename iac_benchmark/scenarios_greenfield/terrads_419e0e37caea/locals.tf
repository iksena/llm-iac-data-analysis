##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
locals {
  region_arr        = split("-", data.aws_region.current.name)
  region            = format("%s%s%s", lower(local.region_arr[0]), lower(substr(local.region_arr[1], 0, 2)), lower(local.region_arr[2]))
  system_name       = format("%s-%s-%s-%s-%s", lower(var.org.organization_unit), lower(var.org.environment_name), lower(var.org.environment_type), var.spoke_def, local.region)
  system_name_short = format("%s-%s-%s-%s-%s", substr(lower(var.org.organization_unit), 0, 3), substr(lower(var.org.environment_name), 0, 3), substr(lower(var.org.environment_type), 0, 4), var.spoke_def, local.region)
  all_tags          = merge(module.tags.locals.common_tags, var.extra_tags)
}
