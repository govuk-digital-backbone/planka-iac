data "aws_ssm_parameter" "planka-admin-password" {
  count = var.bootstrap_step >= 2 ? 1 : 0
  name  = local.ssm_admin_password
}

data "aws_ssm_parameter" "planka-oidc-secret" {
  count = var.bootstrap_step >= 2 ? 1 : 0
  name  = local.ssm_oidc_secret
}

data "aws_ssm_parameter" "planka-notify-api-key" {
  count = var.bootstrap_step >= 2 ? 1 : 0
  name  = local.ssm_notify_api_key
}

data "aws_ssm_parameter" "planka-notify-template-id" {
  count = var.bootstrap_step >= 2 ? 1 : 0
  name  = local.ssm_notify_template_id
}
