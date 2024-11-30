package lib.tfstate_test

import rego.v1

import data.lib.tfstate

test_resources_count_empty if {
	count(tfstate.resources) == 0 with input as {}
}

test_resources_count_real_tfstate if {
	count(tfstate.resources) == 70 with input as data.lib.tfstate_test.testdata["eks-attach-policy-to-nodes"]
}
