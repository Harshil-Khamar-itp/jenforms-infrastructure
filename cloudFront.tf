data "aws_acm_certificate" "certificate" {
  domain = "dns-poc-onprem.tk"
  statuses = ["ISSUED"]
}
module "cf" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.2.1"
  aliases = ["jenformshk.dns-poc-onprem.tk"]
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  create_origin_access_control = true
  default_root_object = "index.html"
  origin_access_control = {
    "s3Access" = {
      description = ""
      origin_type = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }
  origin = {

    s3Origin = {
      domain_name = module.s3.s3_bucket_bucket_domain_name
      origin_access_control_id = module.cf.cloudfront_origin_access_controls.s3Access.id
    }
  }
  default_cache_behavior = {
    target_origin_id           = "s3Origin"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
  }
  viewer_certificate = {
    acm_certificate_arn = data.aws_acm_certificate.certificate.arn
    ssl_support_method = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "S3 Access"
}

output "OAC" {
  value = module.cf.cloudfront_origin_access_controls
  
}