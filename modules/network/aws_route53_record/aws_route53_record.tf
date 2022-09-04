# ========================================================== #
# エイリアスレコード作成
# ========================================================== #
resource "aws_route53_record" "s3_alias_records" {
  zone_id = var.u_zone_id
  name    = var.u_domain_name
  type    = "A"

  alias {
    name    = var.u_s3_website_domain
    zone_id = var.u_hosted_zone_id
    evaluate_target_health = true
  }
}