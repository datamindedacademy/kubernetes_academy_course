provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "aws" {
  region              = "eu-west-1"
  allowed_account_ids = ["338791806049"]
  default_tags {
    tags = {
      "Course" = "Docker and Kubernetes"
      "Terraform" = "true"
    }
  }
}
