#!/bin/sh

#
# Generate amis.json files honored by moto by setting MOTO_AMIS_PATH with
# recommended Amazon Linux 2 images.
#

set -eu

#
# Print out hardcoded list of supported Kubernetes version by EKS.
#
# This should be manually synced based on:
# <https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html>
#
supported_kubernetes_version() {
	cat <<-EOF
		1.21
		1.22
		1.23
		1.24
	EOF
}

#
# Given a Kubernetes version as parameter print recommended Amazon Linux AMI
# using SSM.
#
# Implemented as documented in
# <https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html>
# by following the logic described for `AWS Management Console'.
#
amazon_linux_eks_optimized_images_ami() {
	local kubernetes_version="$1"

	aws ssm get-parameters \
		--names "/aws/service/eks/optimized-ami/${kubernetes_version}/amazon-linux-2/recommended/image_id" \
		--query 'Parameters[0].[Value]' \
		--output text
}

#
# Given a list of AMIs print out an amis.json as expected by moto's
# MOTO_AMIS_PATH.
#
moto_amis_json() {
	aws ec2 describe-images \
		--image-ids "$@" |
		jq '
	[ .Images[] |
		{
			"ami_id": .ImageId,
			"name": .Name,
			"description": .Description,
			"owner_id": .OwnerId,
			"public": .Public,
			"virtualization_type": .VirtualizationType,
			"architecture": .Architecture,
			"state": .State,
			"platform": .Platform,
			"image_type": .ImageType,
			"hypervisor": .Hypervisor,
			"root_device_name": .RootDeviceName,
			"root_device_type": .RootDeviceType,
			"sriov": .SriovNetSupport
		}
	]
	'
}

moto_amis_json $(for v in $(supported_kubernetes_version); do
	amazon_linux_eks_optimized_images_ami "${v}"
done)
