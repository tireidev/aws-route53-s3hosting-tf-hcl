# ========================================================== #
# S3バケットポリシー作成
# ========================================================== #
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

   condition {
     test     = "IpAddress"
     variable = "aws:SourceIp"
     values = [
   	    var.u_allowed_cidr_myip
     ]
   }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      var.u_s3_bucket_arn,
      "${var.u_s3_bucket_arn}/*",
    ]
  }
}

output "json" {
  value       = data.aws_iam_policy_document.s3_bucket_policy.json
}