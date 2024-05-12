variable "auto_ingest" {
  description = "A boolean that determines if the pipe will automatically ingest new files."
  type        = bool
  default     = null
}

variable "aws_sns_topic_arn" {
  description = "The Amazon Resource Name (ARN) of the SNS topic."
  type        = string
  default     = null
  sensitive   = true
}

variable "comment" {
  description = "A comment for the pipe."
  type        = string
  default     = ""
}

variable "copy_statement" {
  description = "The COPY statement for the pipe."
  type        = string
}

variable "database" {
  description = "The name of the database."
  type        = string
}

variable "enable_multiple_grants" {
  description = "A boolean that determines if multiple grants are enabled."
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the pipe."
  type        = string
}

variable "on_future" {
  description = "..."
  type        = bool
  default     = null

  validation {
    condition     = var.on_future == null || var.on_future == false || var.on_future == true
    error_message = "The on_future value must be either null, true, or false."
  }
}

variable "privilege" {
  description = "The privilege for the grant."
  type        = string
  default     = "USAGE"
}

variable "roles" {
  description = "The roles for the grant."
  type        = list(string)
  default     = []
}

variable "schema" {
  description = "The name of the schema."
  type        = string
  default     = null
}

variable "with_grant_option" {
  description = "A boolean that determines if the grant option is enabled."
  type        = bool
  default     = false
}