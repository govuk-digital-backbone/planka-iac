locals {
  task_name          = "planka-task-${var.environment_name}-${var.planka_instance_id}"
  log_retention_days = var.environment_name == "production" ? 365 : 14

  database_username = sensitive(random_password.sql_master_username.result)
  database_password = sensitive(random_password.sql_master_password.result)
  database_name     = sensitive("db${random_password.sql_database_name.result}")
  connection_string = sensitive("postgresql://${local.database_username}:${local.database_password}@${aws_rds_cluster.db.endpoint}/${local.database_name}")
}
