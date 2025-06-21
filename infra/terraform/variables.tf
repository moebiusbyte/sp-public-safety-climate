variable "namespace_list" {
  type    = list(string)
  default = ["infra", "bronze", "silver", "gold"]
}

variable "minio_buckets" {
  type    = list(string)
  default = ["bronze", "silver", "gold"]
}
