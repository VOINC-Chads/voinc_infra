# ECR Repo
resource "aws_ecr_repository" "voinc_repo" {
  name = "voinc_repo"
  image_tag_mutability  = "MUTABLE"
}

data "aws_iam_policy_document" "iam_policy" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "voinc_repo_repolicy" {
  repository = aws_ecr_repository.voinc_repo.name
  policy     = data.aws_iam_policy_document.iam_policy.json
}
