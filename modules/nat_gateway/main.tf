/************************************************************
Elastic IP
************************************************************/
resource "aws_eip" "this" {
  domain = "vpc"
  tags = {
    Name = "regional-nat-a-eip"
  }
}

/************************************************************
NAT Gateway
************************************************************/
resource "aws_nat_gateway" "this" {
  availability_mode = "regional"
  connectivity_type = "public"
  vpc_id            = var.vpc_id
  availability_zone_address {
    allocation_ids = [
      aws_eip.this.allocation_id
    ]
    availability_zone = "${var.region}a"
  }
  tags = {
    Name = "manual-regional-ngw"
  }
}