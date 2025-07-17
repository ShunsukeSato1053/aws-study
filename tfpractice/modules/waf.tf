# ----------
# 変数定義
# ----------

# ----------
# リソース定義
# ----------
# WAF_WebACLの設定
resource "aws_wafv2_web_acl" "awsstudy_web_acl" {
  name        = "awsstudyWebACL"
  description = "WebACL for awsstudy ALB"
  scope       = "REGIONAL" # ALB用はREGIONALを指定
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "awsstudyWebACLMetric"
    sampled_requests_enabled   = true
  }
  rule {
    name     = "awsstudyManagedRulesCoreRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CoreRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

# WebACLをALBに関連付け
resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = aws_lb.awsstudy_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.awsstudy_web_acl.arn
}

# Logファイル
resource "aws_cloudwatch_log_group" "waf_log_group" {
  name              = "aws-waf-logs-ACLLogs"
  retention_in_days = 90
  tags = {
    ProjectName = "awsstudylogs"
  }
}

# LogファイルとWebACLの連携
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.awsstudy_web_acl.arn
}
