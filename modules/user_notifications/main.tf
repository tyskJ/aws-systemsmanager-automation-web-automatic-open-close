/************************************************************
Notification Hub
************************************************************/
resource "aws_notifications_notification_hub" "apne1" {
  notification_hub_region = var.region
}

/************************************************************
Delivery Channels
************************************************************/
### Email
resource "aws_notificationscontacts_email_contact" "email" {
  email_address = var.email
  name          = "ops-email"
  tags = {
    Name = "ops-email"
  }
}

/************************************************************
Notification Configuration
************************************************************/
### CloudWatch
resource "aws_notifications_notification_configuration" "cloudwatch" {
  name                 = "cloudwatch-evnet"
  description          = "Notification when any CloudWatch alarm in the account goes to alert status."
  aggregation_duration = "NONE"
  tags = {
    Name = "cloudwatch-evnet"
  }
}

/************************************************************
Event Rule
************************************************************/
### CloudWatch
resource "aws_notifications_event_rule" "cloudwatch" {
  notification_configuration_arn = aws_notifications_notification_configuration.cloudwatch.arn
  source                         = "aws.cloudwatch"
  event_type                     = "CloudWatch Alarm State Change"
  event_pattern                  = file("${path.module}/config/cloudwatch.json")
  regions = [
    var.region
  ]
}

/************************************************************
Channel Association
************************************************************/
### CloudWatch
# resource "aws_notifications_channel_association" "email" {
#   arn                            = aws_notificationscontacts_email_contact.email.arn
#   notification_configuration_arn = aws_notifications_notification_configuration.cloudwatch.arn
# }