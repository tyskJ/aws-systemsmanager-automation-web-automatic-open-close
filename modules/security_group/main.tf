/************************************************************
Security Group
************************************************************/
resource "aws_security_group" "this" {
  for_each = local.sgs

  vpc_id      = var.vpc_id
  name        = each.value.name
  description = each.value.description
  tags = {
    Name = each.value.name
  }
}

/************************************************************
Security Group Rule
************************************************************/
### Ingress
resource "aws_security_group_rule" "alb_sg_ingress_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = [
    var.source_ip
  ]
  security_group_id = aws_security_group.this["alb"].id
  description       = "From Restricted Traffic HTTP"
}
resource "aws_security_group_rule" "ec2_sg_ingress_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this["alb"].id
  security_group_id        = aws_security_group.this["ec2"].id
  description              = "From ALB SG HTTP"
}

### Egress
resource "aws_security_group_rule" "alb_sg_egress_http" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this["ec2"].id
  security_group_id        = aws_security_group.this["alb"].id
  description              = "To EC2 HTTP 80"
}
resource "aws_security_group_rule" "ec2_sg_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this["ec2"].id
  description       = "To Unrestricted Traffic"
}