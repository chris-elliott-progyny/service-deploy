variable "name" {
  description = "SQS Queue name"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "disable_dead_letter_queue" {
  description = "Enable dead-letter queue"
  type        = bool
  default     = true
}

variable "delay_seconds" {
  description = "SQS Queue delay seconds"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "SQS Queue max message size"
  type        = number
  default     = 1024
}

variable "message_rentention_seconds" {
  description = "SQS Queue message rentention seconds"
  type        = number
  default     = 30
}
