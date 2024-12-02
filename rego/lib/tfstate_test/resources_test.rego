package lib.tfstate_test

import rego.v1

import data.lib.tfstate

test_resources_count_empty if {
	count(tfstate.resources) == 0 with input as {}
}

test_resources_count_real_tfstate if {
	count(tfstate.resources) == 70 with input as data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]
}

test_data_resources_count_empty if {
	count(tfstate.data_resources) == 0 with input as {}
}

test_data_resources_count_real_tfstate if {
	count(tfstate.data_resources) == 12 with input as data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]
}

test_managed_resources_count_empty if {
	count(tfstate.managed_resources) == 0 with input as {}
}

test_managed_resources_count_real_tfstate if {
	count(tfstate.managed_resources) == 58 with input as data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]
}

test_all_resources_count_real_tfstate if {
	resources := tfstate.resources with input as data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]
	data_resources := tfstate.data_resources with input as data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]
	managed_resources := tfstate.managed_resources with input as data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]

	count(resources) == count(data_resources) + count(managed_resources)
}
