#!/bin/bash

source scripts/.set-env.sh
if [ -f info/.kms_key ];then
  source info/.kms_key
fi

create_kms(){
  status_key=$(aws kms --region=${AWS_REGION} --profile=${AWS_PROFILE} describe-key --key-id ${KUBE_KMS} | jq .KeyMetadata.KeyState | tr -d '"' 2> /dev/null)
  if [[ ${status_key} != 'Enabled' ]];then
    export KUBE_KMS=$(aws kms --region=${AWS_REGION} --profile ${AWS_PROFILE} create-key --description="${CLUSTER_NAME} kube-aws key" --output json --query 'KeyMetadata.KeyId' | tr -d '"')
    export KUBE_ARN=$(aws kms --region=${AWS_REGION} --profile=${AWS_PROFILE} describe-key --key-id ${KUBE_KMS} | jq .KeyMetadata.Arn | tr -d '"')
    echo "export KUBE_KMS=${KUBE_KMS}" > info/.kms_key
    echo "export KUBE_ARN=${KUBE_ARN}" >> info/.kms_key
    echo KMS Key created: ${KUBE_KMS}
  else
    echo Key already exist. Using ${KUBE_ARN}
  fi
}

create_bucket(){
  status_bucket=$(aws s3  ls | grep ${AWS_BUCKET} | awk '{print $3}')
  if [[ ${status_bucket} != ${AWS_BUCKET} ]];then
    aws s3api create-bucket --bucket ${AWS_BUCKET} --region ${AWS_REGION} --create-bucket-configuration LocationConstraint=${AWS_REGION}
  else
    echo Bucket already exist. Using ${AWS_BUCKET}
  fi
}

cluster_init(){
  if [ ! -d ${CLUSTER_NAME} ];then
    kube-aws init \
      --cluster-name=${CLUSTER_NAME} \
      --external-dns-name=${EXTERNAL_DNS} \
      --region=${AWS_REGION} \
      --availability-zone=${AWS_ZONE} \
      --key-name=${AWS_KEY} \
      --kms-key-arn=${KUBE_ARN}
    
    mkdir -p k8s_${CLUSTER_NAME}
    mv cluster.yaml k8s_${CLUSTER_NAME}/
    
  else
    echo Cluster already was initialized!
  fi
}

create_kms
create_bucket
cluster_init
