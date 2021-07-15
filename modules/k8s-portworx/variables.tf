variable "namespace" {
  type        = string
  description = "Name of a namespace which will be created for deploying the resources"
  default     = "px-backup"
}

variable "storage_class_name" {
  type        = string
  description = "Name of the Portworx-managed storage class to use for backups"
  default     = "px"
}
