package policy.aws.eks_test

import rego.v1

import data.policy.aws.eks

test_deny_extra_policies_in_node_roles_match if {
	resources := [
		{
			"type": "aws_iam_role_policy_attachment",
			"values": {
				"role": "fake_role",
				"policy_arn": "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
			},
		},
		{
			"type": "aws_iam_role_policy_attachment",
			"values": {
				"role": "fake_role",
				"policy_arn": "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
			},
		},
		{
			"type": "aws_iam_role",
			"values": {"name": "fake_role"},
		},
	]

	eks.deny_extra_policies_in_node_roles with data.lib.tfstate.managed_resources as resources
}

test_deny_extra_policies_in_node_roles_mismatch if {
	resources := [
		{
			"type": "aws_iam_role_policy_attachment",
			"values": {
				"role": "fake_role",
				"policy_arn": "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
			},
		},
		{
			"type": "aws_iam_role",
			"values": {"name": "fake_role"},
		},
	]

	count(eks.deny_extra_policies_in_node_roles) == 0 with data.lib.tfstate.managed_resources as resources
}
