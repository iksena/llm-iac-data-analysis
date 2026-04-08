resource "aws_eip" "elastic_ip" {
    tags = {
        Name        = "Example Elasic IP"
        Owner       = "Valerii Vasianovych"
        Project     = "Project name is: ${local.full_project_name} environment"
        Location    = "Our headquaters in: ${local.location}"
        AvailableAZ = "All available AZ: ${local.az_list}"
        AZinRegion  = "${local.region_az}"
    }
} 