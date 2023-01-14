
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "selected" {
  id = var.vpc_name
}

locals {
  account = data.aws_caller_identity.current.account_id
  region  = data.aws_region.current.name
  vpc_id  = data.aws_vpc.selected.id
}