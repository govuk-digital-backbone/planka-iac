resource "aws_cloudwatch_log_group" "planka" {
  name              = "/ecs/${local.task_name}"
  retention_in_days = local.log_retention_days
  tags = {
    Name = "${local.task_name}-logs"
  }
}

resource "aws_cloudwatch_log_group" "smtp" {
  name              = "/ecs/${local.task_name}-smtp"
  retention_in_days = local.log_retention_days
  tags = {
    Name = "${local.task_name}-smtp"
  }
}
