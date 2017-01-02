#!/bin/bash

CLUSTER_NAME=<insert_cluster_name>
AWS_REGION=<insert_aws_region>
export AWS_PROFILE=<insert_aws_profile>
AWS_ZONE=<insert-aws_zone>
AWS_KEY=<insert_aws_key_name>
EXTERNAL_DNS=<insert_dns_cluster_external>
ARN="<insert_arn>"

kube-aws init \
--cluster-name=${CLUSTER_NAME} \
--external-dns-name=${EXTERNAL_DNS} \
--region=${AWS_REGION} \
--availability-zone=${AWS_ZONE} \
--key-name=${AWS_KEY} \
--kms-key-arn=${ARN}

mkdir -p ${CLUSTER_NAME}
mv cluster.yaml ${CLUSTER_NAME}/

cd ${CLUSTER_NAME}
kube-aws render
kube-aws validate
