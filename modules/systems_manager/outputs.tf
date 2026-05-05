output "name_changecalender_document" {
  value = aws_ssm_document.change_calender.id
}

output "arn_changecalender_document" {
  value = aws_ssm_document.change_calender.arn
}

output "arn_automation_document" {
  value = aws_ssm_document.automation.arn
}