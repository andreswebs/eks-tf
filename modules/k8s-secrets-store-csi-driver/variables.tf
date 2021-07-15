variable "enable_secret_rotation" {
  type        = string
  description = "Set Helm value `enableSecretRotation`"
  default     = "true"
}

variable "enable_secret_sync" {
  type        = string
  description = "Set Helm value `syncSecret.enabled`"
  default     = "true"
}

variable "rotation_poll_interval" {
  type        = string
  description = "Set Helm value `rotationPollInterval`"
  default     = "3600s"
}

