/************************************************************
Security Group ID
************************************************************/
output "id_sg" {
  value = {
    for k, v in aws_security_group.this : k => v.id
  }
}