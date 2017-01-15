#!/bin/bash

source scripts/.set-env.sh

aws kms --region=${AWS_REGION} --profile ${AWS_PROFILE} create-key --description="kube-aws assets"

kube-aws init \
--cluster-name=${CLUSTER_NAME} \
--external-dns-name=${EXTERNAL_DNS} \
--region=${AWS_REGION} \
--availability-zone=${AWS_ZONE} \
--key-name=${AWS_KEY} \
--kms-key-arn=${AWS_ARN}

mkdir -p ${CLUSTER_NAME}
mv cluster.yaml ${CLUSTER_NAME}/

cd ${CLUSTER_NAME}
kube-aws render
kube-aws validate
