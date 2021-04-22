variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Name of a namespace which will be created for deploying the resources"
}

variable "cert_arn" {
  type        = string
  description = "ARN of TLS certificate from AWS Certificate Manager"
}
