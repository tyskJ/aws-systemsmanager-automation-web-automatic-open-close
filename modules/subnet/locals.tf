locals {
  subnets = {
    public_1a = {
      name       = "public-subnet-1a"
      az         = "a"
      cidr       = "10.0.1.0/24"
      map_public = true
    }
    public_1c = {
      name       = "public-subnet-1c"
      az         = "c"
      cidr       = "10.0.2.0/24"
      map_public = true
    }
    private_1a = {
      name       = "private-subnet-1a"
      az         = "a"
      cidr       = "10.0.3.0/24"
      map_public = false
    }
  }
}