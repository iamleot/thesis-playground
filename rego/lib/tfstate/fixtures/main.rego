# METADATA
# title: Test fixtures of Terraform state
# description: |
#  Package that provides text fixtures to test lib.tfstate functionality.
# related_resources:
#  - description: JSON Output Format
#    ref: https://developer.hashicorp.com/terraform/internals/json-format
#  - description: JSON Output Format
#    ref: https://opentofu.org/docs/internals/json-format/
# entrypoint: true
package lib.tfstate.fixtures

import rego.v1

# METADATA
# description: |
#  Base tfstate without any values and checks.
#
#  Intended to be used as a base for all other tfstate-s.
tfstate_base := {
	"format_version": "1.0",
	"terraform_version": "1.8.6",
	"values": {},
	"checks": [],
}

# METADATA
# description: |
#  `root_module` with 2 resources.
root_module := {"resources": [
	{
		"address": "fake_foo_resource.this",
		"mode": "managed",
		"type": "fake_foo_resource",
		"name": "this",
		"provider_name": "registry.opentofu.org/test/fake",
		"schema_version": 0,
		"values": {"id": "foo_resource"},
		"sensitive_values": {},
	},
	{
		"address": "fake_bar_resource.this",
		"mode": "managed",
		"type": "fake_bar_resource",
		"name": "this",
		"provider_name": "registry.opentofu.org/test/fake",
		"schema_version": 0,
		"values": {"id": "bar_resource"},
		"sensitive_values": {},
	},
]}

# METADATA
# description: |
#  `child_module` with 3 resources, 2 managed and 1 data.
child_module := {"resources": [
	{
		"address": "module.child.fake_foo_resource.this",
		"mode": "managed",
		"type": "fake_foo_resource",
		"name": "this",
		"provider_name": "registry.opentofu.org/test/fake",
		"schema_version": 0,
		"values": {"id": "foo_resource"},
		"sensitive_values": {},
	},
	{
		"address": "module.child.fake_bar_resource.this",
		"mode": "managed",
		"type": "fake_bar_resource",
		"name": "this",
		"provider_name": "registry.opentofu.org/test/fake",
		"schema_version": 0,
		"values": {"id": "bar_resource"},
		"sensitive_values": {},
	},
	{
		"address": "module.child.data.fake_baz_resource.this",
		"mode": "data",
		"type": "fake_baz_resource",
		"name": "this",
		"provider_name": "registry.opentofu.org/test/fake",
		"schema_version": 0,
		"values": {"id": "baz_resource"},
		"sensitive_values": {},
	},
]}

# METADATA
# description: |
#  tfstate with some resources, all in a root module.
tfstate_root := object.union(
	tfstate_base,
	{"values": {"root_module": root_module}},
)

# METADATA
# description: |
#  tfstate with some resources, a root module and a child module.
tfstate_root_child := object.union(
	tfstate_base,
	{"values": {"root_module": object.union(
		root_module,
		{"child_modules": [child_module]},
	)}},
)
