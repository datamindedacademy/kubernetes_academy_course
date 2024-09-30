terraform {
  backend "s3" {
    bucket         = "dataminded-academy-courses-tf-state"
    region         = "eu-west-1"
    encrypt        = "true"
    key            = "kubernetes-course/cluster-setup.tfstate"
    dynamodb_table = "datafy-dp-terraform-statelock-209b"
  }
}
