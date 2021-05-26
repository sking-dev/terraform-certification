# Superseded by use of terraform.tfvars file.
variable "location" {
  #description = "Default Azure region"
  #default     = "northeurope"
}

variable "tags" {
  # default = {
  #   source = "citadel"
  #   env    = "training"
  # }
}

variable "webapplocations" {
  description = "Allowed regions for Web app deployments."
  # type        = list(any)
  # default     = ["northeurope", "uksouth", "ukwest"]
}
