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