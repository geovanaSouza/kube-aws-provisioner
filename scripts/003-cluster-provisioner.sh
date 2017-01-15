#!/bin/bash

source scripts/.set-env.sh

cd ${CLUSTER_NAME}
kube-aws up
aws ec2 create-volume --availability-zone ${AWS_REGION} --size ${MQ_CAPACITY} --volume-type gp2

