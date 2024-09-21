# packer-aws

[![lint](https://github.com/mateusz-uminski/packer-aws/actions/workflows/lint.yaml/badge.svg)](https://github.com/mateusz-uminski/packer-aws/actions/workflows/lint.yaml)

This repository serves as a collection of Packer templates specifically designed to build Amazon Machine Images that can be used in other projects. These templates are used for learning and verifying unconventional ideas.

Besides the README.md further documentation can be found in commits, code comments and nested README files.

Feel free to explore and copy everything you want. Enjoy!


# What is AnyCompany?
AnyCompany is a fictional Software as a Service (SaaS) company to demonstrate sample use cases.


# Prerequisites
1. Configure environment:
```sh
cd $(git rev-parse --show-toplevel)
python3 -m venv venv/
source venv/bin/activate
pip install pip --upgrade
pip install -r requirements.txt
```

2. Start HashiCorp Vault server:
```sh
vault server -dev
```

3. Add AWS account IDs to the vault:
```sh
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='<token>'
ORG_CODE='<org_code>'

vault secrets enable -path=secrets/${ORG_CODE}/ kv
vault kv put secrets/${ORG_CODE}/aws/account-ids <aws_account_alias>=<aws_account_id>
# validate entry
vault kv get -field=<aws_account_alias> secrets/${ORG_CODE}/aws/account-ids
```

4. Configure appropriate profiles in `~/.aws/credentials` and `~/.aws/config`.

5. Create AWS infrastructure:
```sh
cd infrastructure/
export AWS_PROFILE=sandbox
terraform init
terraform apply -auto-approve
```

# Usage

## Build an Amazon Machine Image

```sh
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='<token>'
export AWS_PROFILE=<aws_profile>

cd $(git rev-parse --show-toplevel)
source venv/bin/activate
packer build -var-file=base-debian12/pkrvars/sandbox.pkrvars.hcl .
```
