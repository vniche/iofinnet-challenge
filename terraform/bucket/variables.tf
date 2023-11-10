variable "uuid" {
  type        = string
  description = "Environment unique idenifier"
}

variable "bucket_name" {
  type        = string
  description = "Name of the bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags for managed resources"
  default = {
    "managed-by" = "terraform"
  }
}
