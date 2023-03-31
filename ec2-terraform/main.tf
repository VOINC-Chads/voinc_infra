module "ec2_instance" {
  source = "./modules/ec2-instance"
}

module "ecr_repo" {
  source = "./modules/ecr-repo"
}

module "ec2_iam" {
  source = "./modules/ec2-iam"
}
