provider "aws" {
  region = "us-east-2" 
}

module "ec2_instance" {
  source = "./modules/ec2-instance"
}

module "ecr_repo" {
  source = "./modules/ecr-repo"
}

module "ec2_iam" {
  source = "./modules/ec2-iam"
}

# module "aws_static_website" {
#    source  = "cloudmaniac/static-website/aws"

#   # This is the domain as defined in Route53
#   domains-zone-root       = "voinc.click"

#   # Domains used for CloudFront
#   website-domain-main     = "cloudmaniac.net"
#   website-domain-redirect = "www.cloudmaniac.net"
#   website-additional-domains = ["noredir1.cloudmaniac.net","noredir2.cloudmaniac.net"]
# }

module "frontend" {
  source   = "./modules/frontend"

  bucket_name = "voinc-fe"
}