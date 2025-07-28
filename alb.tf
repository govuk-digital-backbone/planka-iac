data "aws_lb" "alb" {
  arn = var.alb_arn
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = data.aws_lb.alb.arn
  port              = var.port

  protocol        = var.bootstrap_step >= 3 ? "HTTPS" : "HTTP"
  ssl_policy      = var.bootstrap_step >= 3 ? "ELBSecurityPolicy-TLS-1-2-2017-01" : null
  certificate_arn = var.bootstrap_step >= 3 ? aws_acm_certificate.planka_cert[0].arn : null

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
      message_body = "Not found"
    }
  }
}

resource "aws_lb_listener_rule" "alb_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  lifecycle {
    create_before_destroy = var.create_before_destroy
  }

  depends_on = [
    aws_lb_target_group.alb_tg
  ]
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${local.task_name}-${var.port}-tg"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  # Ensure listener rule is removed before TG
  lifecycle {
    create_before_destroy = var.create_before_destroy
  }

  health_check {
    path                = "/"
    port                = "traffic-port" # use the port the container listens on
    protocol            = "HTTP"
    interval            = 90
    timeout             = 60
    healthy_threshold   = 2
    unhealthy_threshold = 4
    matcher             = "200-299" # adjust as needed
  }
}
