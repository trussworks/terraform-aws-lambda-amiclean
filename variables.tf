variable "ami_clean_delete" {
  description = "Perform the actual delete of AMIs and snapshots"
  type        = "string"
}

variable "ami_clean_invert" {
  default     = "false"
  description = "If set, operates on all AMIs *not* tagged with the given tag."
  type        = "string"
}

variable "ami_clean_prefix" {
  default     = ""
  description = "If set, operates only on AMIs with name that start with this prefix."
  type        = "string"
}

variable "ami_clean_retention_days" {
  default     = 30
  description = "Age of AMI in days before it is a candidate for removal. Default is 30 days."
  type        = "string"
}

variable "ami_clean_tag_key" {
  default     = ""
  description = "Key of tag to operate on. Requires tag value to also be set."
  type        = "string"
}

variable "ami_clean_tag_value" {
  default     = ""
  description = "Value of tag to operate on. Requires tag key to also be set."
  type        = "string"
}

variable "cloudwatch_logs_retention_days" {
  default     = 90
  description = "Number of days to retain Cloudwatch logs. Default is 90 days."
  type        = "string"
}

variable "interval_minutes" {
  default     = 1440  # 1 day
  description = "How often to run the AMI purging job, in minutes. Default is 1440 (1 day)."
  type        = "string"
}

variable "job_identifier" {
  description = "A generic job identifier to make resources for this job more obvious."
  type        = "string"
}

variable "s3_bucket" {
  description = "The name of the S3 bucket used to store the Lambda builds."
  type        = "string"
}

variable "version_to_deploy" {
  description = "The version of the Lambda function to deploy."
  type        = "string"
}
