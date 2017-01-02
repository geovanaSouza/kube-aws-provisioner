#!/bin/bash

export AWS_PROFILE=<insert_aws_profile>
CLUSTER_NAME=<insert_cluster_name>

cd ${CLUSTER_NAME}
kube-aws up


