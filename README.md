# DEPRECIATION NOTICE
 
This module has been deprecated and is no longer maintained. Should you need to continue to use it, please fork the repository. Thank you.
 
 Creates a Lambda function with associated role and policies that
will run the ami-cleaner tool to get rid of AMIs that are no longer
needed.

Creates the following resources:

* Lambda function
* IAM role and policies to describe and delete AMIs and snapshots,
  as well as write messages to Cloudwatch Logs
* Cloudwatch Logs group
* Cloudwatch Event to regularly run cleanup job.

## Terraform Versions

Terraform 0.13 and later. Pin module version to ~> 2.1.1. Submit pull requests to `master` branch.
Terraform 0.12. Pin module version to ~> 2.0. Submit pull requests to `terraform012` branch.

## Usage

```hcl
module "ami-clean-lambda" {
  source            = "trussworks/lambda-amiclean/aws"
  ami_clean_delete  = "true"
  ami_clean_prefix  = "sample_app"
  job_identifier    = "sample_app"
  s3_bucket         = "sample_app_lambdas"
  version_to_deploy = "2.7"
}
```

For more details on the capabilities of the ami-cleaner tool, as well
as how to deploy it, see <https://github.com/trussworks/truss-aws-tools>.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_amiclean_lambda"></a> [amiclean\_lambda](#module\_amiclean\_lambda) | trussworks/lambda/aws | ~> 2.5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_clean_delete"></a> [ami\_clean\_delete](#input\_ami\_clean\_delete) | Perform the actual delete of AMIs and snapshots | `string` | n/a | yes |
| <a name="input_ami_clean_invert"></a> [ami\_clean\_invert](#input\_ami\_clean\_invert) | If set, operates on all AMIs *not* tagged with the given tag. | `string` | `"false"` | no |
| <a name="input_ami_clean_prefix"></a> [ami\_clean\_prefix](#input\_ami\_clean\_prefix) | If set, operates only on AMIs with name that start with this prefix. | `string` | `""` | no |
| <a name="input_ami_clean_retention_days"></a> [ami\_clean\_retention\_days](#input\_ami\_clean\_retention\_days) | Age of AMI in days before it is a candidate for removal. Default is 30 days. | `string` | `30` | no |
| <a name="input_ami_clean_tag_key"></a> [ami\_clean\_tag\_key](#input\_ami\_clean\_tag\_key) | Key of tag to operate on. Requires tag value to also be set. | `string` | `""` | no |
| <a name="input_ami_clean_tag_value"></a> [ami\_clean\_tag\_value](#input\_ami\_clean\_tag\_value) | Value of tag to operate on. Requires tag key to also be set. | `string` | `""` | no |
| <a name="input_ami_clean_unused"></a> [ami\_clean\_unused](#input\_ami\_clean\_unused) | Only purge AMIs for which no running instances were built from. | `string` | `""` | no |
| <a name="input_cloudwatch_logs_retention_days"></a> [cloudwatch\_logs\_retention\_days](#input\_cloudwatch\_logs\_retention\_days) | Number of days to retain Cloudwatch logs. Default is 90 days. | `string` | `90` | no |
| <a name="input_interval_minutes"></a> [interval\_minutes](#input\_interval\_minutes) | How often to run the AMI purging job, in minutes. Default is 1440 (1 day). | `string` | `1440` | no |
| <a name="input_job_identifier"></a> [job\_identifier](#input\_job\_identifier) | A generic job identifier to make resources for this job more obvious. | `string` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | The name of the S3 bucket used to store the Lambda builds. | `string` | n/a | yes |
| <a name="input_version_to_deploy"></a> [version\_to\_deploy](#input\_version\_to\_deploy) | The version of the Lambda function to deploy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | ARN for the amicleaner lambda function |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
