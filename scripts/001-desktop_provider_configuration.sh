#!/bin/bash

source scripts/.set-env.sh

check_plataform(){
  if [ "$(uname)" == "Darwin" ]; then
    PLATAFORM=darwin
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    PLATAFORM=linux
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Unsupported Platform"
    exit 1
  fi
}

install_kube-aws(){
  echo "###Importing CoreOs gpg key"
  echo
  gpg2 --keyserver pgp.mit.edu --recv-key FC8A365E
  
  FINGERPRINT=$(gpg2 --fingerprint FC8A365E | grep 'Key fingerprint' | awk -F '=' '{print $2}' | tr -d ' ')
  
  if [[ "$FINGERPRINT" != '18AD5014C99EF7E3BA5F6CE950BDD3E0FC8A365E' ]]; then
    echo Fingerprint invalid. Verify key integrity
  fi
  echo "####################"
  
  check_plataform
  if [ ! -f "/usr/local/bin/kube-aws"  ];then
    rm -rf /tmp/kube-aws
    mkdir -p /tmp/kube-aws
    wget -O /tmp/kube-aws/kube-aws-${PLATAFORM}-amd64.tar.gz https://github.com/coreos/coreos-kubernetes/releases/download/${KUBE_AWS_VERSION}/kube-aws-${PLATAFORM}-amd64.tar.gz
    tar vxzfp /tmp/kube-aws/kube-aws-${PLATAFORM}-amd64.tar.gz -C /tmp/kube-aws
    chmod +x /tmp/kube-aws/${PLATAFORM}-amd64/kube-aws
    sudo mv /tmp/kube-aws/${PLATAFORM}-amd64/kube-aws /usr/local/bin/kube-aws
    rm -rf /tmp/kube-aws
  fi
}

configure_aws_profile(){
  aws configure list --profile ${AWS_PROFILE}
  if [ $? != 0 ]; then
    echo "[${AWS_PROFILE}]" >> ~/.aws/credentials
    echo "aws_access_key_id = ${AWS_ACCESS_KEY}" >> ~/.aws/credentials
    echo "aws_secret_access_key = ${AWS_SECRET_KEY}" >> ~/.aws/credentials
    echo "[profile ${AWS_PROFILE}]" >> ~/.aws/config
    echo "output = json" >> ~/.aws/config
    echo "region = ${AWS_REGION}" >> ~/.aws/config
  fi
}

install_kube-aws
configure_aws_profile
