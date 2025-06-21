resource "aws_s3_bucket" "minio_buckets" {
  for_each = toset(var.minio_buckets)

  bucket = each.value
}
