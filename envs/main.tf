/************************************************************
VPC
************************************************************/
module "vpc" {
  source = "../modules/vpc"
}

/************************************************************
Subnet
************************************************************/
module "subnet" {
  source = "../modules/subnet"

  vpc_id = module.vpc.id_vpc
  region = local.region_name
}

/************************************************************
Internet Gateway
************************************************************/
module "igw" {
  source = "../modules/internet_gateway"

  vpc_id = module.vpc.id_vpc
}

/************************************************************
NAT Gateway
************************************************************/
module "ngw" {
  source = "../modules/nat_gateway"
  depends_on = [
    module.igw
  ]

  vpc_id = module.vpc.id_vpc
  region = local.region_name
}

/************************************************************
Route Table
************************************************************/
module "rtb" {
  source = "../modules/route_table"

  vpc_id     = module.vpc.id_vpc
  subnet_ids = module.subnet.id_subnet
  igw_id     = module.igw.id_igw
  ngw_id     = module.ngw.id_ngw
}

/************************************************************
Security Group
************************************************************/
module "sg" {
  source = "../modules/security_group"

  vpc_id    = module.vpc.id_vpc
  source_ip = var.source_ip
}