/************************************************************
Automation
************************************************************/
resource "aws_iam_policy" "ssm_automation" {
  name = "iam-policy-ssm-automation"
  tags = {
    Name = "iam-policy-ssm-automation"
  }
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowSSM"
        Effect = "Allow"
        Action = [
          "ssm:GetCalendarState"
        ]
        Resource = ["*"]
      },
      {
        Sid    = "AllowElb"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:SetRulePriorities",
          "elasticloadbalancing:DescribeTargetHealth"
        ]
        Resource = ["*"]
      },
      {
        Sid    = "AllowEc2"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstanceStatus",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = ["*"]
      }
    ]
  })
}