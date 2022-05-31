provider "vault" {
	address = "https://127.0.0.1:8203"
	token = "${var.vault_token}"
}

resource "vault_aws_secret_backend" "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"

  default_lease_ttl_seconds = "120"
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
