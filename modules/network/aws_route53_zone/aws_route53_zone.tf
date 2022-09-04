# ========================================================== #
# ホストゾーン作成
# ========================================================== #
resource "aws_route53_zone" "primary" {
  name = var.u_domain_name
}

output "zone_id" {
    value = aws_route53_zone.primary.zone_id
}