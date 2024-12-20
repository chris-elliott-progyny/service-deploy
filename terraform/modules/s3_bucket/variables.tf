variable "name" {
  description = "S3 Bucket name"
  type        = string
}

variable "env_name" {
  description = "Environment name suffix to use for the shared environment resources"
  type        = string
}

variable "versioning_enabled" {
  description = "S3 Bucket versioning"
  type        = bool
  default     = true
}
