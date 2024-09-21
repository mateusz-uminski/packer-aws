# required variables
org_name       = "organization"
org_code       = "org"
project_name   = "infra"
project_code   = "infra"
cost_center_id = "00000"
region_name    = "eu-west-1"
env_name       = "development"
env_code       = "dev"

source_ami = {
  name_pattern = "debian-12-amd64-*"
  owner        = "amazon"
  arch         = "x86_64"
  ssh_user     = "admin"
}

vpc_name     = "org-infra-pkr-sandbox-vpc-dev"
subnet_name  = "org-infra-pkr-sandbox-public-sn1-dev"
ami_name     = "base-debian12"
architecture = "x86"

# optional variables
associate_public_addr = true
deprecate_after       = "8766h"
skip_create_ami       = true

copy_to_regions             = []
share_ami_with_aws_accounts = []
