output "VPC" {
    value = module.vpc.vpc_id
}

output "s3" {
    value = module.s3.s3_bucket_website_endpoint
}

output "s3Domain" {
    value = module.s3.s3_bucket_bucket_domain_name
}