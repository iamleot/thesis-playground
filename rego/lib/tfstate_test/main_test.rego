package lib.tfstate_test

import rego.v1

import data.lib.tfstate
import data.lib.tfstate.fixtures

test_resources_count_empty if {
	count(tfstate.resources) == 0 with input as {}
}

test_resources_count_tfstate_base if {
	count(tfstate.resources) == 0 with input as fixtures.tfstate_base
}

test_resources_count_tfstate_root if {
	count(tfstate.resources) == 2 with input as fixtures.tfstate_root
}

test_data_resources_count_tfstate_root if {
	count(tfstate.data_resources) == 0 with input as fixtures.tfstate_root
}

test_managed_resources_count_tfstate_root if {
	count(tfstate.managed_resources) == 2 with input as fixtures.tfstate_root
}

test_resources_count_tfstate_root_child if {
	count(tfstate.resources) == 5 with input as fixtures.tfstate_root_child
}

test_data_resources_count_tfstate_root_child if {
	count(tfstate.data_resources) == 1 with input as fixtures.tfstate_root_child
}

test_managed_resources_count_tfstate_root_child if {
	count(tfstate.managed_resources) == 4 with input as fixtures.tfstate_root_child
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
	testdata := data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]

	resources := tfstate.resources with input as testdata
	data_resources := tfstate.data_resources with input as testdata
	managed_resources := tfstate.managed_resources with input as testdata

	count(resources) == count(data_resources) + count(managed_resources)
}
