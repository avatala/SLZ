# --------------------------------------------------------------------------------------------------
# Locals
# --------------------------------------------------------------------------------------------------


locals {

 subnets  = {
              for x in var.networkSubnets :
              "${x.subnet_region}/${x.subnet_name}" => x
  }



  }
