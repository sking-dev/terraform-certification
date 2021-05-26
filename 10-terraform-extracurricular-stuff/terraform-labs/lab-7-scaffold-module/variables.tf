variable "location" {
  description = "This is the region to use for the labs."
  default     = "North Europe"
}

variable "tags" {
  description = "These are the tags to assign to the resources."
  type        = map(string)
  default = {
    environment = "training"
    source      = "citadel"
  }
}
