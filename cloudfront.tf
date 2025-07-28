resource "aws_cloudfront_distribution" "this" {
  count = var.bootstrap_step >= 1 ? 1 : 0

  origin {
    domain_name = aws_route53_record.alb[0].fqdn
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = var.port
      https_port             = var.port
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.planka_domain
  default_root_object = "index.html"

  aliases = var.bootstrap_step >= 3 ? [var.planka_domain] : []

  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.bootstrap_step >= 3 ? false : true
    acm_certificate_arn            = var.bootstrap_step >= 3 ? aws_acm_certificate.cloudfront_cert[0].arn : null
    ssl_support_method             = var.bootstrap_step >= 3 ? "sni-only" : null
    minimum_protocol_version       = var.bootstrap_step >= 3 ? "TLSv1.2_2021" : null
  }

  tags = {
    Name = "${local.task_name}-cloudfront-distribution"
  }
}
