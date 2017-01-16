#!/bin/bash

source scripts/.set-env.sh

cd k8s_${CLUSTER_NAME}
kube-aws render
kube-aws validate --s3-uri s3://${AWS_BUCKET}

kube-aws status 2> /dev/null
if [ $? -ne 0 ];then
  kube-aws up --s3-uri s3://${AWS_BUCKET}
fi

kube-aws status > ../info/kube.txt
#aws ec2 create-volume --availability-zone ${AWS_REGION} --size ${MQ_CAPACITY} --volume-type gp2

