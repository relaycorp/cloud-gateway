variable "name" {}

variable "host_name" {}

variable "probe_type" {
  default = "https"

  validation {
    condition     = contains(["https", "tcp"], var.probe_type)
    error_message = "Probe type should be 'https' or 'tcp'."
  }
}

variable "gcp_project_id" {}

variable "notification_channels" {
  type = list(string)
}
