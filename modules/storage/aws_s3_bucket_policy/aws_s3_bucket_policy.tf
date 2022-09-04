resource "aws_s3_bucket_policy" "s3_bucket_policy_mapping" {
  bucket = var.u_s3_bucket_id
  policy = var.u_s3_bucket_policy
}