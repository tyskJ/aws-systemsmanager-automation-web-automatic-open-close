locals {
  sgs = {
    alb = {
      name        = "alb-sg"
      description = "For ALB"
    }
    ec2 = {
      name        = "ec2-sg"
      description = "For EC2"
    }
  }
}