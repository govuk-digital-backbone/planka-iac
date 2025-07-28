resource "aws_efs_access_point" "efs_ap_public_favicons" {
  file_system_id = var.efs_id

  root_directory {
    path = "/${local.task_name}/public/favicons"
    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "755"
    }
  }

  posix_user {
    # the user Fargate tasks will run as
    uid = 0
    gid = 0
  }

  tags = {
    Name = "${local.task_name}-efs-ap-public-favicons"
  }
}

resource "aws_efs_access_point" "efs_ap_user_avatars" {
  file_system_id = var.efs_id

  root_directory {
    path = "/${local.task_name}/public/user-avatars"
    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "755"
    }
  }

  posix_user {
    uid = 0
    gid = 0
  }

  tags = {
    Name = "${local.task_name}-efs-ap-user-avatars"
  }
}

resource "aws_efs_access_point" "efs_ap_background_images" {
  file_system_id = var.efs_id

  root_directory {
    path = "/${local.task_name}/public/background-images"
    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "755"
    }
  }

  posix_user {
    uid = 0
    gid = 0
  }

  tags = {
    Name = "${local.task_name}-efs-ap-background-images"
  }
}

resource "aws_efs_access_point" "efs_ap_attachments" {
  file_system_id = var.efs_id

  root_directory {
    path = "/${local.task_name}/private/attachments"
    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "755"
    }
  }

  posix_user {
    uid = 0
    gid = 0
  }

  tags = {
    Name = "${local.task_name}-efs-ap-attachments"
  }
}

resource "aws_efs_access_point" "efs_ap_logs" {
  file_system_id = var.efs_id

  root_directory {
    path = "/${local.task_name}/logs"
    creation_info {
      owner_uid   = 0
      owner_gid   = 0
      permissions = "755"
    }
  }

  posix_user {
    uid = 0
    gid = 0
  }

  tags = {
    Name = "${local.task_name}-efs-ap-logs"
  }
}
