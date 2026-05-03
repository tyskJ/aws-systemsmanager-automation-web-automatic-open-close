/************************************************************
Subnet
************************************************************/
resource "aws_subnet" "this" {
  for_each = local.subnets

  vpc_id                  = var.vpc_id
  availability_zone       = "${var.region}${each.value.az}"
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.map_public
  tags = {
    Name = each.value.name
  }
}