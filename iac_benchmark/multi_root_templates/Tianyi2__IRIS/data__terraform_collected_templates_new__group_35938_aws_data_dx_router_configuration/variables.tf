variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "virtual_interface_id" {
  description = "ID of the Direct Connect Virtual Interface"
  type        = string

  validation {
    condition     = can(regex("^dxvif-[a-z0-9]+$", var.virtual_interface_id))
    error_message = "data_aws_dx_router_configuration, virtual_interface_id must be a valid Direct Connect Virtual Interface ID starting with 'dxvif-'."
  }
}

variable "router_type_identifier" {
  description = "ID of the Router Type. For example: CiscoSystemsInc-2900SeriesRouters-IOS124"
  type        = string

  validation {
    condition = contains([
      "CiscoSystemsInc-2900SeriesRouters-IOS124",
      "CiscoSystemsInc-3700SeriesRouters-IOS124",
      "CiscoSystemsInc-7200SeriesRouters-IOS124",
      "CiscoSystemsInc-Nexus7000SeriesSwitches-NXOS51",
      "CiscoSystemsInc-Nexus9KSeriesSwitches-NXOS93",
      "JuniperNetworksInc-MMXSeriesRouters-JunOS95",
      "JuniperNetworksInc-SRXSeriesRouters-JunOS95",
      "JuniperNetworksInc-TSeriesRouters-JunOS95",
      "PaloAltoNetworks-PA3000and5000series-PANOS803"
    ], var.router_type_identifier)
    error_message = "data_aws_dx_router_configuration, router_type_identifier must be one of the supported router types: CiscoSystemsInc-2900SeriesRouters-IOS124, CiscoSystemsInc-3700SeriesRouters-IOS124, CiscoSystemsInc-7200SeriesRouters-IOS124, CiscoSystemsInc-Nexus7000SeriesSwitches-NXOS51, CiscoSystemsInc-Nexus9KSeriesSwitches-NXOS93, JuniperNetworksInc-MMXSeriesRouters-JunOS95, JuniperNetworksInc-SRXSeriesRouters-JunOS95, JuniperNetworksInc-TSeriesRouters-JunOS95, PaloAltoNetworks-PA3000and5000series-PANOS803."
  }
}