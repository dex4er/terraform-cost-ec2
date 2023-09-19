variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "vcpus" {
  type        = string
  description = "Number of vCPUs"
}

variable "memory" {
  type        = string
  description = "Memory in MiB"
}
