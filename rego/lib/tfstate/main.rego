# METADATA
# title: Helper library for Terraform state processing
# description: |
#  Rego library to parse OpenTofu and Terraform state in JSON format.
# related_resources:
#  - description: JSON Output Format
#    ref: https://developer.hashicorp.com/terraform/internals/json-format
#  - description: JSON Output Format
#    ref: https://opentofu.org/docs/internals/json-format/
# entrypoint: true
package lib.tfstate

import rego.v1

import input as tfstate

# METADATA
# description: |
#  Walk the Terraform state and flatten all Terraform resources.
#
#  Please note that the Terraform resources in the state can be Terraform
#  `resource` or `data` based on their `mode`:
#   - `resource`: the resource of kind "managed"
#   - `data`: the data resource of kind "data"
# scope: rule
resources contains resource if {
	[_, value] := walk(tfstate)
	some resource in value.resources
}

# METADATA
# description: |
#  Return data resources, AKA actual `data` in Terraform.
# scope: rule
data_resources contains resource if {
	some resource in resources
	resource.mode == "data"
}

# METADATA
# description: |
#  Return managed resources, AKA actual `resource` in Terraform.
# scope: rule
managed_resources contains resource if {
	some resource in resources
	resource.mode == "managed"
}
