resource "aws_s3_bucket" "terraform-state-storage-s3" {
    bucket = "tf-state-rc-napi"

    versioning {
        enabled = false
    }

    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
    name = "terraform-state-lock-dynamo"
    hash_key = "LockID"
    read_capacity = 20
    write_capacity = 20

    attribute {
        name = "LockID"
        type = "S"
    }
}

data "aws_iam_policy_document" "terraform-state-access-policy-document" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
        "arn:aws:s3:::tf-state-rc-napi"
    ]
  }

  statement {
    sid = "2"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
        "arn:aws:s3:::tf-state-rc-napi/*"
    ]
  }
}

resource  "aws_iam_policy" "terraform_access_state_policy" {
    name = "terraform_access_state_policy"
    policy = data.aws_iam_policy_document.terraform-state-access-policy-document.json
}

data "aws_iam_policy_document" "deployment-policy-document" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
        "*"
    ]
  }
}

resource  "aws_iam_policy" "deployment_policy" {
    name = "deployment_policy"
    policy = data.aws_iam_policy_document.deployment-policy-document.json
}

resource "aws_iam_group" "deployment_users_group" {
    name = "deployment_users_group"
}

resource "aws_iam_group_policy_attachment" "group-state-policy-attachment" {
    group      = aws_iam_group.deployment_users_group.name
    policy_arn = aws_iam_policy.terraform_access_state_policy.arn
}

resource "aws_iam_group_policy_attachment" "group-deployment-policy-attachment" {
    group      = aws_iam_group.deployment_users_group.name
    policy_arn = aws_iam_policy.deployment_policy.arn
}