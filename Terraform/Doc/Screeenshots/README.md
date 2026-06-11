# Terraform Evidence Checklist

1. `terraform fmt -check` and `terraform validate`
2. Reviewed `terraform plan` summary
3. Successful apply summary
4. `terraform state list` with sensitive values hidden
5. AWS resource validation
6. Controlled destroy summary when the lab is complete

Never capture private keys, credentials, state contents, account IDs, or sensitive plan values.
