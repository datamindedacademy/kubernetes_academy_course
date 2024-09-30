resource "aws_iam_role" "kubernetes_workshop_gitpod_role" {
  name               = "kubernetes-workshop-gitpod-role"
  assume_role_policy = data.aws_iam_policy_document.gitpod_assume_role.json
  max_session_duration = 28800
}

resource "aws_iam_role_policy" "gitpod_permissions" {
  policy = data.aws_iam_policy_document.gitpod_permissions.json
  role   = aws_iam_role.kubernetes_workshop_gitpod_role.id
  name = "gitpod_permissions"
}

data "aws_iam_policy_document" "gitpod_permissions" {
  statement {
    actions = ["eks:DescribeCluster"]
    resources = ["*"]
    effect  = "Allow"
  }
}

data "aws_iam_policy_document" "gitpod_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "services.gitpod.io/idp:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "services.gitpod.io/idp:sub"
      values   = ["https://github.com/datamindedacademy/kubernetes_academy_course"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.eks_connect_provider_gitpod.arn]
      type        = "Federated"
    }
  }
}
