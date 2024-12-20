output "name" {
  description = "RDS Cluster name"
  value       = var.name
}

output "env_name" {
  description = "Environment name suffix to use for the shared environment resources"
  value       = var.env_name
}

# output "disable_dead_letter_queue" {
#   description = "Enable dead-letter queue"
#   value       = var.disable_dead_letter_queue
# }

# output "delay_seconds" {
#   description = "SQS Queue delay seconds"
#   value       = var.delay_seconds
# }

# output "max_message_size" {
#   description = "SQS Queue max message size"
#   value       = var.max_message_size
# }

# output "message_rentention_seconds" {
#   description = "SQS Queue message rentention seconds"
#   value       = var.message_rentention_seconds
# }
