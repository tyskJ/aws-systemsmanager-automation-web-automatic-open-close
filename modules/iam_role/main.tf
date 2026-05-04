/************************************************************
EC2 Role
************************************************************/
resource "aws_iam_role" "ec2" {
  name = "ec2-role"
  tags = {
    Name = "ec2-role"
  }
  description = "Allows EC2 to call AWS services on your behalf"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2" {
  for_each = {
    ssm        = "arn:${var.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
    cloudwatch = "arn:${var.partition}:iam::aws:policy/CloudWatchAgentAdminPolicy"
  }
  role       = aws_iam_role.ec2.name
  policy_arn = each.value
}

/************************************************************
EC2 Instance Profile
************************************************************/
resource "aws_iam_instance_profile" "ec2" {
  name = aws_iam_role.ec2.name
  role = aws_iam_role.ec2.name
}

/************************************************************
Systems Manager Role
************************************************************/
resource "aws_iam_role" "ssm" {
  name = "ssm-automation-role"
  tags = {
    Name = "ssm-automation-role"
  }
  description = "Allows SSM to call AWS services on your behalf"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  for_each = {
    ssm_automation = aws_iam_policy.ssm_automation.arn
  }
  role       = aws_iam_role.ssm.name
  policy_arn = each.value
}