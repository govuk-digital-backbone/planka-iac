data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.cluster_name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = local.task_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  volume {
    name = "public-favicons"

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.efs_ap_public_favicons.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "public-user-avatars"

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.efs_ap_user_avatars.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "public-background-images"

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.efs_ap_background_images.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "private-attachments"

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.efs_ap_attachments.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "logs"

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.efs_ap_logs.id
        iam             = "ENABLED"
      }
    }
  }

  container_definitions = jsonencode([
    {
      name  = local.task_name
      image = "ghcr.io/plankanban/planka:${var.image_tag}"
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]

      #linuxParameters = {
      #  capabilities = {
      #    add = ["SYS_PTRACE"]
      #  }
      #}

      environment = [
        for k, v in local.planka_variables : {
          name  = k
          value = v
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true" # creates log group if it doesn't exist
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = "eu-west-2"
          awslogs-stream-prefix = "ecs" # shows up as task_name/<container>/<task-id>
        }
      }

      mountPoints = [
        {
          sourceVolume  = "public-favicons"
          containerPath = "/app/public/favicons"
          readOnly      = false
        },
        {
          sourceVolume  = "public-user-avatars"
          containerPath = "/app/public/user-avatars"
          readOnly      = false
        },
        {
          sourceVolume  = "public-background-images"
          containerPath = "/app/public/background-images"
          readOnly      = false
        },
        {
          sourceVolume  = "private-attachments"
          containerPath = "/app/private/attachments"
          readOnly      = false
        },
        {
          sourceVolume  = "logs"
          containerPath = "/app/logs/"
          readOnly      = false
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = local.task_name
  cluster         = data.aws_ecs_cluster.ecs_cluster.arn
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.private_subnets.ids
    security_groups = [aws_security_group.ecs_service.id]
    # assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = local.task_name
    container_port   = 1337
  }
}



