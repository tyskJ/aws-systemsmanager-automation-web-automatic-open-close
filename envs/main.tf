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

/************************************************************
IAM Role
************************************************************/
module "iam_role" {
  source = "../modules/iam_role"

  partition = local.partition_name
}

/************************************************************
EC2
************************************************************/
module "ec2" {
  source = "../modules/ec2"
  depends_on = [
    module.rtb
  ]

  subnet_id             = module.subnet.id_subnet["private_1a"]
  sg_id                 = module.sg.id_sg["ec2"]
  isntance_profile_name = module.iam_role.instance_profile_name
}

/************************************************************
ALB
************************************************************/
module "alb" {
  source = "../modules/alb"

  vpc_id      = module.vpc.id_vpc
  instance_id = module.ec2.id_instanceid
  subnet_ids  = module.subnet.id_subnet
  sg_id       = module.sg.id_sg["alb"]
  region      = local.region_name
}

/************************************************************
CloudWatch
************************************************************/
module "cw" {
  source = "../modules/cloudwatch"

  instance_id = module.ec2.id_instanceid
}

/************************************************************
Systems Manager
************************************************************/
module "ssm" {
  source = "../modules/systems_manager"
}

/************************************************************
User Notifications
************************************************************/
# module "aun" {
#   source = "../modules/user_notifications"

#   region = local.region_name
#   email  = var.email_address
# }