variable "rg" {
  description = "This is the resource group to use for labs 1 and 2."
  default     = "rg-sking-dev-lab-1-2"
}

variable "location" {
  description = "This is the region to use for labs 1 and 2."
  default     = "North Europe"
}

variable "tags" {
  description = "These are the tags to assign to the resources for labs 1 and 2."
  type        = map(string)
  default = {
    environment = "training"
    source      = "citadel"
  }
}
