data "aws_cloudfront_origin_request_policy" "origin" {
  name = "Managed-AllViewerAndCloudFrontHeaders-2022-06"
}

data "aws_cloudfront_cache_policy" "cache" {
  name = "UseOriginCacheControlHeaders-QueryStrings"
}

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
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.origin.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.cache.id    

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" # "whitelist"
      # locations        = ["GB"]
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
