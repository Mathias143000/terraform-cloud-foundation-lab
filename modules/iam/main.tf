data "aws_iam_policy_document" "assume_ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "app_policy" {
  statement {
    sid = "DescribeInfra"

    actions = [
      "ec2:DescribeInstances",
      "rds:DescribeDBInstances"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "app" {
  name               = "${var.name_prefix}-app-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-role"
  })
}

resource "aws_iam_role_policy" "app" {
  name   = "${var.name_prefix}-app-inline"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.app_policy.json
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.name_prefix}-app-profile"
  role = aws_iam_role.app.name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-profile"
  })
}
