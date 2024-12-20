variable "name" {
  description = "DynamoDB Table Name"
  type        = string
}

variable "env_name" {
  description = "Environment name suffix to use for the shared environment resources"
  type        = string
}

variable "table_hash" {
  description = "DynamoDB Table hash"
  type = object({
    key_name = string
    key_type = string
  })
}

variable "table_capacity" {
  description = "DynamoDB Table capacity"
  type = object({
    read  = optional(number, 50)
    write = optional(number, 50)
  })
  default = {}
}
