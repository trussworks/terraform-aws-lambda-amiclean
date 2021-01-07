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

Terraform 0.13 and later. Pin module version to ~> 3.0. Submit pull requests to `master` branch.
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
| terraform | >= 0.13.0 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_clean\_delete | Perform the actual delete of AMIs and snapshots | `string` | n/a | yes |
| ami\_clean\_invert | If set, operates on all AMIs *not* tagged with the given tag. | `string` | `"false"` | no |
| ami\_clean\_prefix | If set, operates only on AMIs with name that start with this prefix. | `string` | `""` | no |
| ami\_clean\_retention\_days | Age of AMI in days before it is a candidate for removal. Default is 30 days. | `string` | `30` | no |
| ami\_clean\_tag\_key | Key of tag to operate on. Requires tag value to also be set. | `string` | `""` | no |
| ami\_clean\_tag\_value | Value of tag to operate on. Requires tag key to also be set. | `string` | `""` | no |
| ami\_clean\_unused | Only purge AMIs for which no running instances were built from. | `string` | `""` | no |
| cloudwatch\_logs\_retention\_days | Number of days to retain Cloudwatch logs. Default is 90 days. | `string` | `90` | no |
| interval\_minutes | How often to run the AMI purging job, in minutes. Default is 1440 (1 day). | `string` | `1440` | no |
| job\_identifier | A generic job identifier to make resources for this job more obvious. | `string` | n/a | yes |
| s3\_bucket | The name of the S3 bucket used to store the Lambda builds. | `string` | n/a | yes |
| version\_to\_deploy | The version of the Lambda function to deploy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | ARN for the amicleaner lambda function |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
