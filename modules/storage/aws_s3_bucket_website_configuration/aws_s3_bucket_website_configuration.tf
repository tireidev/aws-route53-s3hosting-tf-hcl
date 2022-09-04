# ========================================================== #
# S3ホスティング
# ========================================================== #
resource "aws_s3_bucket_website_configuration" "config" {
  bucket = var.u_s3_bucket_id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}