variable "vpc_name" {
  description = "The AWS VPC identifier"
  type        = string
  default     = ""

  validation {
    condition     = length(var.vpc_name) > 0
    error_message = "The VPC identifier is mandatory."
  }
}
