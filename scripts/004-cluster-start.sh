#!/bin/bash

source scripts/.set-env.sh

cd ${CLUSTER_NAME}
kube-aws up


