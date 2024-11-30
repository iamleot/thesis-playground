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
# scope: rule
resources contains resource if {
	[_, value] := walk(tfstate)
	some resource in value.resources
}