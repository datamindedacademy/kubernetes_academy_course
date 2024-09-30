data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = {
    tier = "private"
  }
}

data "aws_caller_identity" "current" {}


module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "20.24.2"
  cluster_name                   = local.cluster_name
  cluster_version                = "1.30"
  subnet_ids                     = data.aws_subnets.private.ids
  vpc_id                         = module.vpc.vpc_id
  enable_irsa                    = true
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    disk_size               = 50
    instance_types = ["t3.large"]
    pre_bootstrap_user_data = local.ssm_userdata
    iam_role_additional_policies = { "ssm" : "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" }
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }
  cluster_enabled_log_types = ["api", "audit"] //, "authenticator", "controllerManager","scheduler"]

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  eks_managed_node_groups = {
    default_node_group = {
      min_size     = 0
      max_size     = 5
      desired_size = 2
    }
  }

  access_entries = {
    workshop_user = {
      principal_arn = aws_iam_role.kubernetes_workshop_gitpod_role.arn
      type          = "STANDARD"


      policy_associations = {
        workshop_user = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  enable_cluster_creator_admin_permissions = true
  tags = {
    Terraform = "true"
  }
}

data "aws_iam_openid_connect_provider" "eks_connect_provider_gitpod" {
  url = "https://services.gitpod.io/idp"
}

# If the OIDC provider does not exist in the aws account, you can create it with the following code:
# resource "aws_iam_openid_connect_provider" "eks_connect_provider_gitpod" {
#   url = "https://services.gitpod.io/idp"
#   client_id_list = ["sts.amazonaws.com"]
#   thumbprint_list = [
#     "F2309CE0494F89BD1C502084FA42243CC18727FF",
#     "349C385FF8E330F20EAD733CD36FB435FEE0B403",
#     "08745487E891C19E3078C1F2A07E452950EF36F6"
#   ]
# }