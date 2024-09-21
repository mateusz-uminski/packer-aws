locals {
  org_code     = "org"
  project_code = "infra"
  env_code     = "dev"
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      "org-name"                           = "organization"
      "org-code"                           = local.org_code
      "${local.org_code}:project-name"     = "infra"
      "${local.org_code}:project-code"     = local.project_code
      "${local.org_code}:cost-center-id"   = "00000"
      "${local.org_code}:environment-name" = "development"
      "${local.org_code}:environment-code" = local.env_code
      "${local.org_code}:repository"       = "github.com/mateusz-uminski/packer-aws"
      "${local.org_code}:path"             = "infrastructure"
      "${local.org_code}:tool"             = "terraform"
    }
  }
}

module "vpc" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//vpc?ref=vpc-v0.1.0"

  # required variables
  org_code     = local.org_code
  project_code = local.project_code
  env_code     = local.env_code
  vpc_name     = "pkr-sandbox"
  vpc_cidr     = "10.18.0.0/16"

  public_subnets  = ["10.18.0.0/20"]
  private_subnets = []
  storage_subnets = []

  # optional variables
  create_nat_gateway = false
  domain_name        = "euw1.dev.org.internal"
}
