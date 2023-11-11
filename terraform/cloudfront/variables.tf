variable "uuid" {
  type        = string
  description = "Environment unique idenifier"
}

variable "bucket_id" {
  type        = string
  description = "Bucket to server static files from"
}

variable "bucket_encryption_key_id" {
  type        = string
  description = "Bucket encryption key id"
}

variable "default_root_object" {
  type        = string
  description = "The default object to serve root (/) requests"
  default     = "index.html"
}

variable "origin_access_control_id" {
  type        = string
  description = "Origin Access Control identification"
}

variable "tags" {
  type        = map(string)
  description = "Tags for managed resources"
}
