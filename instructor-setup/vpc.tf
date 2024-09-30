data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name                          = "docker-k8s-vpc"
  cidr                          = "10.1.0.0/16"
  azs                           = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets               = ["10.1.128.0/20", "10.1.144.0/20", "10.1.160.0/20"]
  public_subnets                = ["10.1.0.0/20", "10.1.16.0/20", "10.1.32.0/20"]
  enable_nat_gateway            = true
  single_nat_gateway            = true
  enable_dns_hostnames          = true
  enable_dns_support            = true
  manage_default_security_group = true
  tags                          = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
    "tier"                                        = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
    "tier"                                        = "private"
  }
}

