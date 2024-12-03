# METADATA
# title: AWS EKS policies
# description: |
#  Policies for AWS EKS.
# entrypoint: true
package policy.aws.eks

import rego.v1

import data.lib.tfstate

# METADATA
# description: |
#  EKS node IAM roles assumes that they have the `AmazonEKSWorkerNodePolicy`
#  IAM AWS managed policy attached.
node_roles := [role |
	some policy in tfstate.managed_resources
	some role in tfstate.managed_resources
	policy.type == "aws_iam_role_policy_attachment"
	policy.values.policy_arn == "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
	role.type == "aws_iam_role"
	policy.values.role == role.values.name
]

# METADATA
# title: Deny extra IAM policies to EKS node IAM role
# description: |
#  The EKS node IAM role should have only the following IAM policies:
#   - AmazonEKSWorkerNodePolicy
#   - AmazonEC2ContainerRegistryPullOnly
#   - (optional) AmazonEKS_CNI_Policy
#  Attaching other IAM policies permit all pods to use underlying IAM
#  actions.
# related_resources:
#  - description: Amazon EKS node IAM role
#    ref: https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html
#  - description: aws_eks_node_group resource, hashicorp/aws Terraform provider
#    ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
# scope: rule
deny_extra_policies_in_node_roles contains msg if {
	some node_role in node_roles
	some resource in tfstate.managed_resources
	resource.type == "aws_iam_role_policy_attachment"
	resource.values.role == node_role.values.name
	not resource.values.policy_arn in {
		"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
		"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
		"arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
		"arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
	}
	msg := sprintf(
		"`aws_iam_role` `%v` is a node role and should not have `aws_iam_role_policy_attachment` `%v` attached to it",
		[node_role.values.name, resource.values.policy_arn],
	)
}
