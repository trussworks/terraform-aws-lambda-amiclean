/**
 * Creates a Lambda function with associated role and policies that
 * will run the ami-cleaner tool to get rid of AMIs that are no longer
 * needed.
 *
 * Creates the following resources:
 *
 * * Lambda function
 * * IAM role and policies to describe and delete AMIs and snapshots,
 *   as well as write messages to Cloudwatch Logs
 * * Cloudwatch Logs group
 * * Cloudwatch Event to regularly run cleanup job.
 *
 * ## Usage
 *
 * ```hcl
 * module "ami-clean-lambda" {
 *   source            = "trussworks/lambda-amiclean/aws"
 *   ami_clean_delete  = "true"
 *   ami_clean_prefix  = "sample_app"
 *   job_identifier    = "sample_app"
 *   s3_bucket         = "sample_app_lambdas"
 *   version_to_deploy = "2.7"
 * }
 * ```
 *
 * For more details on the capabilities of the ami-cleaner tool, as well
 * as how to deploy it, see <https://github.com/trussworks/truss-aws-tools>.
 */

locals {
  pkg  = "truss-aws-tools"
  name = "ami-cleaner"
}

data "aws_region" "current" {}

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

  # Allow describing EBS snapshots.
  statement {
    sid    = "DescribeEBSSnapshots"
    effect = "Allow"

    actions = [
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }

  # Allow deregistering AMIs.
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
  policy = "${data.aws_iam_policy_document.main.json}"
}

# Lambda function
module "amiclean_lambda" {
  source = "github.com/trussworks/terraform-aws-lambda"

  name             = "${local.name}"
  job_identifier   = "${var.job_identifier}"
  runtime          = "go1.x"
  role_policy_arns = ["${aws_iam_policy.main.arn}"]

  s3_bucket = "${var.s3_bucket}"
  s3_key    = "${local.pkg}/${var.version_to_deploy}/${local.pkg}.zip"

  source_types = ["events"]
  source_arns  = ["${aws_cloudwatch_event_rule.main.arn}"]

  env_vars {
    DELETE         = "${var.ami_clean_delete}"
    NAME_PREFIX    = "${var.ami_clean_prefix}"
    RETENTION_DAYS = "${var.ami_clean_retention_days}"
    TAG_KEY        = "${var.ami_clean_tag_key}"
    TAG_VALUE      = "${var.ami_clean_tag_value}"
    INVERT         = "${var.ami_clean_invert}"
    LAMBDA         = true
  }

  tags {
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
  rule = "${aws_cloudwatch_event_rule.main.name}"
  arn  = "${module.amiclean_lambda.lambda_arn}"
}
