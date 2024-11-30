package lib.tfstate_test

import rego.v1

import data.lib.tfstate

test_resources_count_empty if {
	count(tfstate.resources) == 0 with input as {}
}

test_resources_count_real_tfstate if {
	resources := tfstate.resources with input as data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]
	count(resources) == 70

	# Check actual Terraform resources, i.e. the `resource` one that are
	# also showed via `plan` and `apply` output.
	managed_resources := [resource | some resource in resources; resource.mode == "managed"]
	count(managed_resources) == 58

	# Check actual Terraform data (resources), i.e. the `data` one that are
	# not showed via `plan` and `apply` output.
	data_resources := [resource | some resource in resources; resource.mode == "data"]
	count(data_resources) == 12

	count(resources) == count(managed_resources) + count(data_resources)
}
