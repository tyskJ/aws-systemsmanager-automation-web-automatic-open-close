/************************************************************
Amazon Linux 2023 AMI ID
************************************************************/
data "aws_ssm_parameter" "amlinux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}