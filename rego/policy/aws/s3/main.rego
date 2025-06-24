# METADATA
# title: AWS S3 policies
# description: |
#  Policies for AWS S3.
# entrypoint: true
package policy.aws.s3

import rego.v1

import data.lib.tfstate

# METADATA
# title: Deny S3 bucket without block public ACLs
# description: |
#  In order to keep the S3 bucket private, public ACLs should be blocked.
# related_resources:
#  - description: Blocking public access to your Amazon S3 storage
#    ref: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
#  - description: aws_s3_bucket_public_access_block resource, hashicorp/aws Terraform provider
#    ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
#  - description: S3 Bucket Allows Public ACL - KICS
#    ref: https://docs.kics.io/latest/queries/terraform-queries/aws/d0cc8694-fcad-43ff-ac86-32331d7e867f/
#  - description: Block Public Acls - Trivy
#    ref: https://avd.aquasec.com/misconfig/aws/s3/avd-aws-0086/
# scope: rule
deny_no_block_public_acls contains msg if {
	some resource in tfstate.managed_resources
	resource.type == "aws_s3_bucket_public_access_block"
	resource.values.block_public_acls == false
	msg := sprintf(
		concat(" ", [
			"`aws_s3_bucket_public_access_block` `block_public_acls`",
			"attribute of `aws_s3_bucket` `%v` should be set to `true`",
			"to ensure it is private",
		]),
		[resource.values.bucket],
	)
}

# METADATA
# title: Deny S3 bucket without block public policy
# description: |
#  In order to keep the S3 bucket private, public policy should be blocked.
# related_resources:
#  - description: Blocking public access to your Amazon S3 storage
#    ref: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
#  - description: aws_s3_bucket_public_access_block resource, hashicorp/aws Terraform provider
#    ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
#  - description: Block Public Policy - Trivy
#    ref: https://avd.aquasec.com/misconfig/aws/s3/avd-aws-0087/
# scope: rule
deny_no_block_public_policy contains msg if {
	some resource in tfstate.managed_resources
	resource.type == "aws_s3_bucket_public_access_block"
	resource.values.block_public_policy == false
	msg := sprintf(
		concat(" ", [
			"`aws_s3_bucket_public_access_block` `block_public_policy`",
			"attribute of `aws_s3_bucket` `%v` should be set to `true`",
			"to ensure it is private",
		]),
		[resource.values.bucket],
	)
}

# METADATA
# title: Deny S3 bucket without Ignore Public ACL
# description: |
#  In order to keep the S3 bucket private, public ACL should be ignored.
# related_resources:
#  - description: Blocking public access to your Amazon S3 storage
#    ref: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
#  - description: aws_s3_bucket_public_access_block resource, hashicorp/aws Terraform provider
#    ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
#  - description: S3 Bucket Without Ignore Public ACL - KICS
#    ref: https://docs.kics.io/latest/queries/terraform-queries/aws/4fa66806-0dd9-4f8d-9480-3174d39c7c91/
#  - description: Ignore Public Acls - Trivy
#    ref: https://avd.aquasec.com/misconfig/aws/s3/avd-aws-0091/
# scope: rule
deny_no_ignore_public_acls contains msg if {
	some resource in tfstate.managed_resources
	resource.type == "aws_s3_bucket_public_access_block"
	resource.values.ignore_public_acls == false
	msg := sprintf(
		concat(" ", [
			"`aws_s3_bucket_public_access_block` `ignore_public_acls`",
			"attribute of `aws_s3_bucket` `%v` should be set to `true`",
			"to ensure it is private",
		]),
		[resource.values.bucket],
	)
}

# METADATA
# title: Deny S3 bucket without restrict public buckets
# description: |
#  In order to keep the S3 bucket private, public buckets should be restricted.
# related_resources:
#  - description: Blocking public access to your Amazon S3 storage
#    ref: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
#  - description: aws_s3_bucket_public_access_block resource, hashicorp/aws Terraform provider
#    ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
#  - description: S3 Bucket Without Restriction Of Public Bucket - KICS
#    ref: https://docs.kics.io/latest/queries/terraform-queries/aws/1ec253ab-c220-4d63-b2de-5b40e0af9293/
#  - description: No Public Buckets - Trivy
#    ref: https://avd.aquasec.com/misconfig/aws/s3/avd-aws-0093/
# scope: rule
deny_no_restrict_public_buckets contains msg if {
	some resource in tfstate.managed_resources
	resource.type == "aws_s3_bucket_public_access_block"
	resource.values.restrict_public_buckets == false
	msg := sprintf(
		concat(" ", [
			"`aws_s3_bucket_public_access_block` `restrict_public_buckets`",
			"attribute of `aws_s3_bucket` `%v` should be set to `true`",
			"to ensure it is private",
		]),
		[resource.values.bucket],
	)
}
