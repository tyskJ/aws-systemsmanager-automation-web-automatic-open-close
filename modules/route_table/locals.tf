locals {
  rtbs = {
    public = {
      name = "public-rtb"
    }
    private = {
      name = "private-rtb"
    }
  }
  rtb_assoc = {
    public_1a = {
      rtb_key    = "public"
      subnet_key = "public_1a"
    }
    public_1c = {
      rtb_key    = "public"
      subnet_key = "public_1c"
    }
    private_1a = {
      rtb_key    = "private"
      subnet_key = "private_1a"
    }
  }
}