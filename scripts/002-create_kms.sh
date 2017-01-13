#!/bin/bash

source scripts/.set-env.sh

aws kms --region=${AWS_REGION} --profile ${AWS_PROFILE} create-key --description="kube-aws assets"
