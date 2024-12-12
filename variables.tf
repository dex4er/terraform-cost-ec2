variable "profile" {
  type        = string
  description = "AWS profile to use"
  default     = null
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "arch" {
  type        = string
  description = "CPU architecture: x86_64 or arm64"
}

variable "vcpus" {
  type        = string
  description = "Number of vCPUs"
}

variable "memory" {
  type        = string
  description = "Memory in GiB"
}
