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
      },
      {
        Sid    = "AllowAun"
        Effect = "Allow"
        Action = [
          "notifications:DisassociateChannel",
          "notifications:AssociateChannel"
        ]
        Resource = ["*"]
      }
    ]
  })
}

/************************************************************
Event Bridge
************************************************************/
resource "aws_iam_policy" "event_bridge" {
  name = "iam-policy-event-bridge"
  tags = {
    Name = "iam-policy-event-bridge"
  }
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowSSM"
        Effect = "Allow"
        Action = [
          "ssm:StartAutomationExecution"
        ]
        Resource = ["*"]
      },
      {
        Sid    = "AllowPassRole"
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = ["*"],
        Condition = {
          StringEquals : { "iam:PassedToService" : "ssm.amazonaws.com" }
        }
      }
    ]
  })
}