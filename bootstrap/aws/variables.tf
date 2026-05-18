variable "aws_region" {
  type        = string
  description = "The target AWS region for the Genesis bootstrap infrastructure."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The targeting environment tier, matching the tree architecture ('dev', 'staging', 'prod')."
  default     = "dev"
}