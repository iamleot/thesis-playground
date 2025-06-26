# METADATA
# title: AWS S3 policies
# description: |
#  Policies for AWS S3.
# entrypoint: true
package policy.aws.s3

import rego.v1

import data.lib.tfstate

# METADATA
# title: Deny bucket without public access block
# description: |
#  S3 bucket should have an associated public access block in order to keep it
#  private.
# related_resources:
#  - description: Blocking public access to your Amazon S3 storage
#    ref: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
#  - description: aws_s3_bucket resource, hashicorp/aws Terraform provider
#    ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
#  - description: aws_s3_bucket_public_access_block resource, hashicorp/aws Terraform provider
#    ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
#  - description: Specify Public Access Block - Trivy
#    ref: https://avd.aquasec.com/misconfig/aws/s3/avd-aws-0094/
#  - description: S3 Bucket does not have public access blocks - Checkov
#    ref: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/s3-bucket-should-have-public-access-blocks-defaults-to-false-if-the-public-access-block-is-not-attached
# scope: rule
deny_bucket_without_public_access_block contains msg if {
	some bucket in tfstate.managed_resources
	bucket.type == "aws_s3_bucket"
	count([bucket_public_access_block |
		some bucket_public_access_block in tfstate.managed_resources
		bucket_public_access_block.type == "aws_s3_bucket_public_access_block"
		bucket.values.id == bucket_public_access_block.values.id
	]) == 0
	msg := sprintf(
		"`aws_s3_bucket` `%v` should have an associated `aws_s3_bucket_public_access_block`",
		[bucket.values.id],
	)
}

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
#  - description: AWS S3 Buckets has block public access setting disabled - Checkov
#    ref: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/s3-policies/bc-aws-s3-19
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
#  - description: S3 Bucket Allows Public Policy - KICS
#    ref: https://docs.kics.io/latest/queries/terraform-queries/aws/1a4bc881-9f69-4d44-8c9a-d37d08f54c50/
#  - description: Block Public Policy - Trivy
#    ref: https://avd.aquasec.com/misconfig/aws/s3/avd-aws-0087/
#  - description: AWS S3 Bucket BlockPublicPolicy is not set to True - Checkov
#    ref: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/s3-policies/bc-aws-s3-20
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
#  - description: AWS S3 bucket IgnorePublicAcls is not set to True - Checkov
#    ref: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/s3-policies/bc-aws-s3-21
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
#  - description: AWS S3 bucket RestrictPublicBucket is not set to True - Checkov
#    ref: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/s3-policies/bc-aws-s3-22
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
