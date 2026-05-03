/************************************************************
Route Table
************************************************************/
resource "aws_route_table" "this" {
  for_each = local.rtbs

  vpc_id = var.vpc_id
  tags = {
    Name = each.value.name
  }
}

/************************************************************
Route Table Association
************************************************************/
resource "aws_route_table_association" "this" {
  for_each = local.rtb_assoc

  route_table_id = aws_route_table.this[each.value.rtb_key].id
  subnet_id      = var.subnet_ids[each.value.subnet_key]
}

/************************************************************
Route
************************************************************/
resource "aws_route" "public_rtb_to_igw" {
  route_table_id         = aws_route_table.this["public"].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}
resource "aws_route" "private_rtb_to_ngw" {
  route_table_id         = aws_route_table.this["private"].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.ngw_id
}