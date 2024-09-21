variable "org_name" {
  type        = string
  description = "The name of the organization or company."
}

variable "org_code" {
  type        = string
  description = "A unique identifier or code for the organization."
}

variable "project_name" {
  type        = string
  description = "The name of the project."
}

variable "project_code" {
  type        = string
  description = "A unique identifier or code for the project."
}

variable "cost_center_id" {
  type        = string
  description = "The identifier for the cost center associated with the resources."
}

variable "region_name" {
  type        = string
  description = "The name of the AWS region where the temporary resources will be deployed."
}

variable "env_name" {
  type        = string
  description = "The name of the environment."
}

variable "env_code" {
  type        = string
  description = "A unique identifier or code for the environment."
}

variable "ami_name" {
  type        = string
  description = "Name of the Amazon Machine Image."
}

variable "architecture" {
  type        = string
  description = "The CPU architecture of the target machine image."
}

variable "source_ami" {
  type = object({
    name_pattern = string
    owner        = string
    ssh_user     = string
    arch         = string
  })
  description = <<-EOF
    An object that defines the criteria for selecting the source AMI,
    including a regular expression for the AMI name (name_pattern),
    the owner of the AMI (owner),
    the SSH user to access the AMI (ssh_user),
    and the CPU architecture (arch)."
  EOF
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC where the instance will be launched."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet within the VPC where the instance will be launched."
}

variable "deprecate_after" {
  type        = string
  description = "The duration after which the AMI will be deprecated. The default duration is one year."
  default     = "8766h"
}

variable "associate_public_addr" {
  type        = bool
  description = "Whether to associate a public IP address with the instance."
  default     = false
}

variable "skip_create_ami" {
  type        = bool
  description = "Whether to skip the creation of a new AMI."
  default     = false
}

variable "copy_to_regions" {
  type        = list(string)
  description = "A list of AWS regions where the AMI should be copied."
  default     = []
}

variable "share_ami_with_aws_accounts" {
  type        = list(string)
  description = <<-EOF
    A list of AWS account aliases for which the AMI will be shared.
    These aliases will be used to retrieve the corresponding account IDs from Vault."
  EOF
  default     = []
}
