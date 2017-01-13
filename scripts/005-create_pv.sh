#!/bin/bash

source scripts/.set-env.sh

aws ec2 create-volume --availability-zone ${AWS_REGION} --size ${MQ_CAPACITY} --volume-type gp2
