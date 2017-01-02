#!/bin/bash

export AWS_PROFILE=<insert_aws_profile>
AWS_REGION=<insert_aws_region>

#Message Queue Persistence Volume
MQ_CAPACITY=1
aws ec2 create-volume --availability-zone ${AWS_REGION} --size ${MQ_CAPACITY} --volume-type gp2
