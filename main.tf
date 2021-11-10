locals {
  pkg     = "truss-aws-tools"
  name    = "ami-cleaner"
  handler = "ami-cleaner"
}

data "aws_region" "current" {
}

# This is the main policy this job is going to need.
data "aws_iam_policy_document" "main" {
  # Allow describing AMIs.
  statement {
    sid    = "DescribeImages"
    effect = "Allow"

    actions = [
      "ec2:DescribeImages",
    ]

    resources = ["*"]
  }

  # Allow describing Instances.
  statement {
    sid    = "DescribeInstances"
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
    ]

    resources = ["*"]
  }

  # Allow describing EBS snapshots.
  statement {
    sid    = "DescribeEBSSnapshots"
    effect = "Allow"

    actions = [
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }

  # Allow deregistering AMIs. DeregisterImage does not allow resource constraints.
  statement {
    sid    = "DeregisterImage"
    effect = "Allow"

    actions = [
      "ec2:DeregisterImage",
    ]

    resources = ["*"]
  }

  # Allow deleteing EBS snapshots.
  statement {
    sid    = "DeleteSnapshot"
    effect = "Allow"

    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = ["arn:aws:ec2:${data.aws_region.current.name}::snapshot/*"]
  }
}

# Create the policy for the document we just added above.
resource "aws_iam_policy" "main" {
  name   = "${local.name}-${var.job_identifier}-policy"
  policy = data.aws_iam_policy_document.main.json
}

# Lambda function
module "amiclean_lambda" {
  source  = "trussworks/lambda/aws"
  version = "~>2.4.0"

  name                           = local.name
  handler                        = local.handler
  job_identifier                 = var.job_identifier
  runtime                        = "go1.x"
  role_policy_arns_count         = 1
  role_policy_arns               = [aws_iam_policy.main.arn]
  cloudwatch_logs_retention_days = var.cloudwatch_logs_retention_days

  s3_bucket = var.s3_bucket
  s3_key    = "${local.pkg}/${var.version_to_deploy}/${local.pkg}.zip"

  source_types = ["events"]
  source_arns  = [aws_cloudwatch_event_rule.main.arn]

  env_vars = {
    DELETE         = var.ami_clean_delete
    NAME_PREFIX    = var.ami_clean_prefix
    RETENTION_DAYS = var.ami_clean_retention_days
    TAG_KEY        = var.ami_clean_tag_key
    TAG_VALUE      = var.ami_clean_tag_value
    INVERT         = var.ami_clean_invert
    UNUSED         = var.ami_clean_unused
    # This will run the AMI cleaner with its Lambda handler.
    LAMBDA = true
  }

  tags = {
    Name = "${local.name}-${var.job_identifier}"
  }
}

# Cloudwatch event for regular running of the Lambda function.
resource "aws_cloudwatch_event_rule" "main" {
  name                = "${local.name}-${var.job_identifier}"
  description         = "scheduled trigger for ${local.name}"
  schedule_expression = "rate(${var.interval_minutes} minutes)"
}

resource "aws_cloudwatch_event_target" "main" {
  rule = aws_cloudwatch_event_rule.main.name
  arn  = module.amiclean_lambda.lambda_arn
}

