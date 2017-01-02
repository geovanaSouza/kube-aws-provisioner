#!/bin/bash

AWS_REGION=<insert_aws_region>
AWS_PROFILE=<insert_aws_profile>

aws kms --region=${AWS_REGION} --profile ${AWS_PROFILE} create-key --description="kube-aws assets"
