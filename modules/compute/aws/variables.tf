variable "project_id" {
  type        = string
  description = "Project/Account identifier for AWS scope tracking"
}

variable "subnet_id" {
  type        = string
  description = "Target AWS Subnet ID for the instance placement"
}