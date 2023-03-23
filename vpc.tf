module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  cidr = var.vpcCidr
  name = "jenForms-VPC-HK"
  enable_dns_support = true
  enable_dns_hostnames = true
}

data "aws_availability_zones" "azs" {
  
}