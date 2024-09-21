# required variables
org_name       = "anycompany"
org_code       = "ac"
project_name   = "infra"
project_code   = "infra"
cost_center_id = "00000"
region_name    = "eu-west-1"
env_name       = "production"
env_code       = "prod"

source_ami = {
  name_pattern = "AlmaLinux OS 9*"
  owner        = "679593333241"
  arch         = "x86_64"
  ssh_user     = "ec2-user"
}

vpc_name     = "ac-infra-main-vpc-prod"
subnet_name  = "ac-infra-main-public-sn1-prod"
ami_name     = "base-alma9"
architecture = "x86"

# optional variables
associate_public_addr = true
deprecate_after       = "8766h"
skip_create_ami       = false

copy_to_regions = [
  "eu-west-1",
  "us-east-1"
]
share_ami_with_aws_accounts = [
  "ac_core_prod",
  "ac_app_dev",
  "ac_app_prod"
]
