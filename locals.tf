locals {
  task_name          = "planka-${var.environment_name}-${var.planka_instance_id}"
  ssm_key_prefix     = "/planka/${var.environment_name}/${var.planka_instance_id}"
  ssm_admin_password = "${local.ssm_key_prefix}/admin_password"
  ssm_oidc_secret    = "${local.ssm_key_prefix}/oidc_secret"
  log_retention_days = var.environment_name == "production" ? 365 : 14

  database_username = sensitive(random_password.sql_master_username.result)
  database_password = sensitive(random_password.sql_master_password.result)
  database_name     = sensitive("db${random_password.sql_database_name.result}")
  connection_string = sensitive("postgresql://${local.database_username}:${local.database_password}@${aws_rds_cluster.db.endpoint}/${local.database_name}")

  planka_variables = merge(
    var.planka_variables,
    {
      BASE_URL         = "https://${var.planka_domain}"
      DATABASE_URL     = local.connection_string
      SECRET_KEY       = random_password.planka-secret-key.result
      LOG_LEVEL        = var.log_level
      TRUST_PROXY      = "true"
      TOKEN_EXPIRES_IN = tostring(var.token_expires_in)
      DEFAULT_LANGUAGE = "en-GB"
    }
  )
}

resource "random_password" "planka-secret-key" {
  length  = 24
  special = false
  upper   = false

  lifecycle {
    ignore_changes = [
      length,
      special,
      upper,
    ]
  }
}
