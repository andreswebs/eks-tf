variable "role_name" {
  default     = null
  description = "Role name; auto-generated if unset"
}

variable "profile_name" {
  default     = null
  description = "Profile name; auto-generated if unset"
}

variable "policies" {
  type        = list(string)
  default     = []
  description = "List of policy ARNs to attach"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply"
}
