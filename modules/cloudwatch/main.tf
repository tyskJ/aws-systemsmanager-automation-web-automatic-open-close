/************************************************************
Alarm
************************************************************/
resource "aws_cloudwatch_metric_alarm" "nginx" {
  alarm_name  = "cw-alarm-process-nginx"
  namespace   = "CWAgent"
  metric_name = "procstat_lookup_pid_count"
  dimensions = {
    exe        = "nginx"
    InstanceId = var.instance_id
    pid_finder = "native"
  }
  statistic           = "Maximum"
  period              = 60
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  datapoints_to_alarm = 1
  evaluation_periods  = 1
  treat_missing_data  = "breaching"
  tags = {
    Name = "cw-alarm-process-nginx"
  }
}