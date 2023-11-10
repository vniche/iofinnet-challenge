variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "buckets" {
  type        = list(string)
  description = "Buckets to provision and manage"
}

variable "tags" {
  type        = map(string)
  description = "Tags for managed resources"
  default = {
    "managed-by" = "terraform"
  }
}
