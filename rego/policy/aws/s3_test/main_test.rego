package policy.aws.s3_test

import rego.v1

import data.policy.aws.s3

test_deny_no_block_public_acls_match if {
	resources := [{
		"type": "aws_s3_bucket_public_access_block",
		"values": {
			"bucket": "fake_bucket",
			"block_public_acls": false,
		},
	}]

	s3.deny_no_block_public_acls with data.lib.tfstate.managed_resources as resources
}

test_deny_no_block_public_policy_match if {
	resources := [{
		"type": "aws_s3_bucket_public_access_block",
		"values": {
			"bucket": "fake_bucket",
			"block_public_policy": false,
		},
	}]

	s3.deny_no_block_public_policy with data.lib.tfstate.managed_resources as resources
}

test_deny_no_ignore_public_acls_match if {
	resources := [{
		"type": "aws_s3_bucket_public_access_block",
		"values": {
			"bucket": "fake_bucket",
			"ignore_public_acls": false,
		},
	}]

	s3.deny_no_ignore_public_acls with data.lib.tfstate.managed_resources as resources
}

test_deny_no_restrict_public_buckets_match if {
	resources := [{
		"type": "aws_s3_bucket_public_access_block",
		"values": {
			"bucket": "fake_bucket",
			"restrict_public_buckets": false,
		},
	}]

	s3.deny_no_restrict_public_buckets with data.lib.tfstate.managed_resources as resources
}

test_s3_bucket_public_access_block_mismatch if {
	resources := [{
		"type": "aws_s3_bucket_public_access_block",
		"values": {
			"bucket": "fake_bucket",
			"block_public_acls": true,
			"block_public_policy": true,
			"ignore_public_acls": true,
			"restrict_public_buckets": true,
		},
	}]

	count(s3.deny_no_block_public_acls) == 0 with data.lib.tfstate.managed_resources as resources
	count(s3.deny_no_block_public_policy) == 0 with data.lib.tfstate.managed_resources as resources
	count(s3.deny_no_ignore_public_acls) == 0 with data.lib.tfstate.managed_resources as resources
	count(s3.deny_no_restrict_public_buckets) == 0 with data.lib.tfstate.managed_resources as resources
}
