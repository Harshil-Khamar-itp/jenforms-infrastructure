# resource "aws_cloudfront_distribution" "cf" {
#     origin {
#       domain_name = aws_s3_bucket.s3.bucket_domain_name
#       origin_access_control_id = aws_cloudfront_origin_access_control.oai.id
#       origin_id = var.originId
      
#     }
#     default_cache_behavior {
#        allowed_methods  = ["GET", "HEAD"]
#        viewer_protocol_policy = "redirect-to-https"
#     }
#     logging_config {
#       include_cookies = false
#       bucket = 
#     }
# }

# resource "aws_cloudfront_origin_access_control" "oai" {
#     name = "s3OAI"
#     origin_access_control_origin_type = "s3"
#     signing_behavior = "always"
#     signing_protocol = "sigv4"
# }

# module "cf" {
#   depends_on = [
#     module.s3
#   ]
#   source  = "terraform-aws-modules/cloudfront/aws"
#   version = "3.2.1"
#   enabled = true
#   price_class = "PriceClass_All"
#   create_origin_access_identity = false
#   origin = {
#     s3 = {
#       domain_name = module.s3.s3_bucket_bucket_domain_name
#       s3_origin_config = {
#         origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
#       }
#       # origin_access_control_id = module.cf.default.id
#     }
#   }


  # origin_access_control = {
  #   "s3" = {
  #     description = ""
  #     origin_type = "s3"
  #     signing_behavior = "always"
  #     signing_protocol = "sigv4"
  #   }
  # 
  # }
#   default_cache_behavior = {
#     target_origin_id = "s3AccessIdentity"
#     viewer_protocol_policy = "allow-all"
#     allowed_methods = ["GET","HEAD"]
#     compress = true
#   }
# }

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
  # create_origin_access_identity = true

  # origin_access_identities = {
  #   s3Origin = "S3 Access Identity"
  # }
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
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "S3 Access"
}

output "OAC" {
  value = module.cf.cloudfront_origin_access_controls
}