/************************************************************
Rule
************************************************************/
resource "aws_cloudwatch_event_rule" "change_calender" {
  name           = "ssm-change-calender-state-rule"
  description    = "Match SSM Change Calender State Change"
  state          = "ENABLED"
  event_bus_name = "default"
  event_pattern = jsonencode({
    source      = ["aws.ssm"]
    detail-type = ["Calendar State Change"]
    resources   = [var.changecalender_arn]
  })
  tags = {
    Name = "ssm-change-calender-state-rule"
  }
}

/************************************************************
Target
************************************************************/
resource "aws_cloudwatch_event_target" "ssm_automation" {
  rule           = aws_cloudwatch_event_rule.change_calender.name
  event_bus_name = "default"
  arn            = var.automation_arn
  input = jsonencode({
    AssumeRoleArn                = [var.ssm_role_arn]
    ChangeCalenderName           = [var.change_calender_name]
    InstanceId                   = [var.instance_id]
    ListenerRuleArn              = [var.listener_rule_arn]
    TargetGroupArn               = [var.targetgroup_arn]
    NotificationConfigurationArn = [var.notification_configuration_arn]
    ChannelArn                   = [var.delivery_channel_arn]
  })
  role_arn = var.event_bridge_role_arn
}