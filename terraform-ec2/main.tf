terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.12.31"
}

provider "aws" {
  profile    = "default"
  region     = "eu-west-2"
  shared_credentials_file = "~/.aws/credentials"
}

module "vpc" {
  source = "./modules/vpc"
  env    = "devops_course_final"
  az     = "eu-west-2a"
}

module "ec2" {
  source = "./modules/ec2"
  subnet_id = module.vpc.public_subnet_id

  sg_ids = [module.vpc.public_sg_id]
  name = "web"
  env = "devops_course_ec2_final"
  key_name = "SGK1"
}

output "web_instance_public_ip" {
  value = module.ec2.web_instance_public_ip
}