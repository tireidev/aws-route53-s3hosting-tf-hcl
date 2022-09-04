# ========================================================== #
# [処理名]
# メイン処理
# 
# [概要]
# S3にWebサービスをホスティングする
# 
# [手順]
# 0. プロバイダ設定(AWS)
# 1. ストレージ作成
#   1.1. S3バケット作成
#   1.2. S3バケットオブジェクト作成
# 2. セキュリティ設定
#   2.1. MyIP取得
#   2.2. S3バケットACL作成
#   2.3. S3バケットポリシー作成
# 3. S3ホスティング設定
#   3.1. S3ホスティング
# 4. DNS設定
#   4.1. ホストゾーン作成
#   4.2. エイリアスレコード作成
# ========================================================== #


# ========================================================== #
# 0. プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = "ap-northeast-1"
}

# ========================================================== #
# 1. ストレージ作成
# ========================================================== #
#   1.1. S3バケット作成
# ========================================================== #
module "aws_s3_bucket" {
  source        = "./modules/storage/aws_s3_bucket"
  u_domain_name = var.u_domain_name
  u_env         = var.u_env
}

# ========================================================== #
#   1.2. S3バケットオブジェクト作成
# ========================================================== #
module "aws_s3_object" {
  source            = "./modules/storage/aws_s3_object"
  u_s3_bucket_id    = module.aws_s3_bucket.id
  u_object_key_name = var.u_object_key_name
  u_object_source   = var.u_object_source
  u_contect_type    = var.u_contect_type
}

# ========================================================== #
# 2. セキュリティ設定
# ========================================================== #
#   2.1. MyIP取得
# ========================================================== #
module "cidr_myip" {
  source              = "./modules/network/cidr_myip"
  u_allowed_cidr_myip = var.u_allowed_cidr_myip
}

# ========================================================== #
#   2.2. S3バケットACL作成
# ========================================================== #
module "aws_s3_bucket_acl" {
  source         = "./modules/storage/aws_s3_bucket_acl"
  u_s3_bucket_id = module.aws_s3_bucket.id
  u_s3_acl       = var.u_s3_acl
}

# ========================================================== #
#   2.3. S3バケットポリシー作成
# ========================================================== #
module "aws_iam_policy_document" {
  source              = "./modules/security/aws_iam_policy_document"
  u_allowed_cidr_myip = module.cidr_myip.ip
  u_s3_bucket_arn     = module.aws_s3_bucket.arn
}

module "aws_s3_bucket_policy" {
  source             = "./modules/storage/aws_s3_bucket_policy"
  u_s3_bucket_id     = module.aws_s3_bucket.id
  u_s3_bucket_policy = module.aws_iam_policy_document.json
}

# ========================================================== #
# 3. S3ホスティング設定
# ========================================================== #
#   3.1. S3ホスティング
# ========================================================== #
module "aws_s3_bucket_website_configuration" {
  source         = "./modules/storage/aws_s3_bucket_website_configuration"
  u_s3_bucket_id = module.aws_s3_bucket.id
}

# ========================================================== #
# 4. DNS設定
# ========================================================== #
#   4.1. ホストゾーン作成
# ========================================================== #
module "aws_route53_zone" {
  source        = "./modules/network/aws_route53_zone"
  u_domain_name = module.aws_s3_bucket.id
}

# ========================================================== #
#   4.2. エイリアスレコード作成
# ========================================================== #
module "aws_route53_record" {
  source                = "./modules/network/aws_route53_record"
  u_zone_id             = module.aws_route53_zone.zone_id
  u_domain_name         = module.aws_s3_bucket.id
  u_s3_website_domain = var.u_s3_website_domain
  u_hosted_zone_id      = module.aws_s3_bucket.hosted_zone_id
}