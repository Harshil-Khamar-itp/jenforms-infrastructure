data "aws_route53_zone" "public" {
    name = "dns-poc-onprem.tk"
    private_zone = false
}

module "dns" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  zone_id = data.aws_route53_zone.public.id
  records = [{
    name    = "jenformshk"
    type    = "A"
    alias = {
        name = module.cf.cloudfront_distribution_domain_name
        zone_id = module.cf.cloudfront_distribution_hosted_zone_id
    }
  }]
}