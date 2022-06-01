provider "vault" {
	address = "https://vault-cluster-aws.vault.797ef198-e9b5-4477-b448-5c560fcbe367.aws.hashicorp.cloud:8200"
	token = "hvs.CAESIE0bCmocw56iCzmCGAByRXvI_nqxTv8oloKx13GLSL8KGicKImh2cy55M2Q3Uloycm5mbWM3OUV4UG51eWhpbzQuQ052Z3gQnxA"
}

terraform {
  backend "remote" {
    path = "terraform.tfstate"
  }
}

resource "vault_aws_secret_backend" "aws" {
  access_key = "AKIAT3PUN65TUA2MFSWE"
  secret_key = "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"
  region = "us-east-2"

  default_lease_ttl_seconds = "121"
  max_lease_ttl_seconds     = "240"
}

resource "vault_aws_secret_backend_role" "ec2-admin" {
  backend = vault_aws_secret_backend.aws.path
  name    = "ec2-admin-role"
  credential_type = "iam_user"

  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*", "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}
