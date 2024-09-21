locals {
  timestamp_raw = timestamp()
  timestamp     = formatdate("DDMMYYYY-hhmm", local.timestamp_raw)

  full_name = "${var.org_code}-${var.project_code}-${var.ami_name}-${var.architecture}-${local.timestamp}"

  aws_account_ids = [for k in var.share_ami_with_aws_accounts : vault("secrets/${var.org_code}/aws/account-ids", "${k}")]

  tags = {
    Name                               = local.full_name
    "org-name"                         = var.org_name
    "org-code"                         = var.org_code
    "${var.org_code}:project-name"     = var.project_name
    "${var.org_code}:project-code"     = var.project_code
    "${var.org_code}:cost-center-id"   = var.cost_center_id
    "${var.org_code}:environment-name" = var.env_name
    "${var.org_code}:environment-code" = var.env_code
    "${var.org_code}:repository"       = "github.com/mateusz-uminski/packer-aws"
    "${var.org_code}:path"             = var.ami_name
    "${var.org_code}:tool"             = "packer"
    "${var.org_code}:cpu-arch"         = var.architecture
  }

  shell_dir   = "${var.ami_name}/shell"
  ansible_dir = "${var.ami_name}/ansible"
  tests_dir   = "${var.ami_name}/tests"
}

data "git-commit" "head" {}

data "amazon-ami" "source" {
  filters = {
    name                = var.source_ami.name_pattern
    architecture        = var.source_ami.arch
    virtualization-type = "hvm"
    root-device-type    = "ebs"
  }
  owners      = [var.source_ami.owner]
  region      = var.region_name
  most_recent = true
}

source "amazon-ebs" "main" {
  skip_create_ami = var.skip_create_ami

  ami_name        = local.full_name
  ami_description = "commit: ${data.git-commit.head.hash}"

  region           = var.region_name
  source_ami       = data.amazon-ami.source.id
  ami_regions      = var.copy_to_regions
  ami_users        = local.aws_account_ids
  force_deregister = true

  iam_instance_profile        = ""
  associate_public_ip_address = var.associate_public_addr

  vpc_filter {
    filters = {
      "tag:Name" : var.vpc_name
    }
  }

  subnet_filter {
    filters = {
      "tag:Name" : var.subnet_name
    }
  }

  ssh_username = var.source_ami.ssh_user
  ssh_pty      = false

  instance_type = "t2.micro"
  ena_support   = true
  sriov_support = false

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = 32
    volume_type           = "gp3"
    delete_on_termination = true
  }

  deprecate_at = timeadd(local.timestamp_raw, var.deprecate_after)

  run_tags        = local.tags
  run_volume_tags = local.tags
  tags            = local.tags
}

build {
  sources = ["source.amazon-ebs.main"]

  name = var.ami_name

  provisioner "shell" {
    script = "${local.shell_dir}/configure.sh"
  }

  provisioner "ansible" {
    user = var.source_ami.ssh_user

    collections_path     = "${local.ansible_dir}"
    galaxy_file          = "${local.ansible_dir}/requirements.yaml"
    galaxy_force_install = true

    playbook_file = "${local.ansible_dir}/configure.yaml"

    extra_arguments = [
      # fix: failed to transfer file to ...
      # fix: failed to connect to the host via scp ...
      "--scp-extra-args", "'-O'",
      # debug
      # "-vvvv",
    ]
  }

  provisioner "shell-local" {
    environment_vars = [
      "PACKER_BUILD_ID=${build.ID}",
      "PACKER_SSH_PRIVATE_KEY=${build.SSHPrivateKey}",
      "PACKER_USER=${build.User}",
      "PACKER_HOST=${build.Host}",
      "PACKER_TESTS_PATH=${local.tests_dir}",
    ]
    script = "${local.shell_dir}/tests.sh"
  }
}
