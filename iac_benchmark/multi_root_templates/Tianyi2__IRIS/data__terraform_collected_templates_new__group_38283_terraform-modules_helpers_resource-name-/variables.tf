########################
#    Resource Naming   #
########################
variable "name" {
  description = "The base name of the resources"
  type        = string
}

########################
#      Tags Config     #
########################
variable "tags" {
  description = "Tags to assign"
  type        = map(string)
}