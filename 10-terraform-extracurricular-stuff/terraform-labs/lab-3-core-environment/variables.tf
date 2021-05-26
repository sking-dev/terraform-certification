variable "location" {
  description = "Default Azure region"
  default     = "North Europe"
}

variable "tags" {
  default = {
    source = "citadel"
    env    = "training"
  }
}
