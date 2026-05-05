output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2.name
}

output "arn_ssm_role" {
  value = aws_iam_role.ssm.arn
}

output "arn_event_bridge_role" {
  value = aws_iam_role.event_bridge.arn
}