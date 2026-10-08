# ==============================================================================
# ACM Certificate for Cloudflare Full (Strict) TLS
# ==============================================================================

resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "*.example.com"
  validation_method = "DNS"

  subject_alternative_names = ["example.com"]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb-cert"
  })

  lifecycle {
    create_before_destroy = true
  }
}
