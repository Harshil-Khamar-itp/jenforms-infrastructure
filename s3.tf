module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"
  acl = "private"
  bucket = var.bucketName
  force_destroy=true
  attach_policy = true
  block_public_acls = true
  block_public_policy = true
  policy = templatefile("policy.tftpl",{bucketArn=module.s3.s3_bucket_arn,cfArn=module.cf.cloudfront_distribution_arn})
  tags = {
    Name : "jenforms-hk"
    Owner : "harshil.khamar@intuitive.cloud"
  }
  website = {
    index_document =  "index.html"
    error_document="error.html"
  }
}
