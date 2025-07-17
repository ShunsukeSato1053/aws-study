# ----------
# 変数定義
# ----------

# ----------
# リソース定義
# ----------
# CloudWatchでアラーム設定（CPU使用率超過）
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_utilization_alarm" {
  alarm_name          = "awsstudy-cpu-utilization-alarm"
  alarm_description   = "awsstudy EC2CPUの使用率が0.0099%以上になりました。"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 0.0099
  treat_missing_data  = "missing"
  unit                = "Percent"
  actions_enabled     = true

  alarm_actions = [
    "arn:aws:sns:ap-northeast-1:255126145977:Default_CloudWatch_Alarms_Topic"
  ]

  dimensions = {
    InstanceId = aws_instance.test_ec2.id
  }
}

# CloudWatchでアラーム設定（WAFリクエスト許可数通知）
resource "aws_cloudwatch_metric_alarm" "allowed_requests_alarm" {
  alarm_name          = "awsstudy-allowedrequest-alarm"
  alarm_description   = "awsstudy WebACLでのリクエスト許可数が1件以上になりました。"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 1
  metric_name         = "AllowedRequests"
  namespace           = "AWS/WAFV2"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  actions_enabled     = true

  alarm_actions = [
    "arn:aws:sns:ap-northeast-1:255126145977:Default_CloudWatch_Alarms_Topic"
  ]

  dimensions = {
    WebACL = aws_wafv2_web_acl.awsstudy_web_acl.name
    Region = "ap-northeast-1"
  }
}
