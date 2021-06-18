locals {
  tags = {
    terraform = true
  }

  upper_environment  = upper(terraform.workspace)
  lower_environment  = lower(terraform.workspace)
  prefix_environment = local.lower_environment == "prd" ? "" : "-${lower(terraform.workspace)}"
}