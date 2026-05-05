output "arn_notification_configuration" {
  value = aws_notifications_notification_configuration.cloudwatch.arn
}

output "arn_delivery_channel" {
  value = aws_notificationscontacts_email_contact.email.arn
}