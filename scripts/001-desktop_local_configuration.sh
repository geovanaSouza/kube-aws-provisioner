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
  kube_aws_local=$(/usr/local/bin/kube-aws version)
  if [[ ${kube_aws_local} != "kube-aws version ${KUBE_AWS_VERSION}" ]];then
    rm -rf /tmp/kube-aws
    mkdir -p /tmp/kube-aws
    wget -O /tmp/kube-aws/kube-aws-${PLATAFORM}-amd64.tar.gz https://github.com/coreos/kube-aws/releases/download/${KUBE_AWS_VERSION}/kube-aws-${PLATAFORM}-amd64.tar.gz
    tar vxzfp /tmp/kube-aws/kube-aws-${PLATAFORM}-amd64.tar.gz -C /tmp/kube-aws
    chmod +x /tmp/kube-aws/${PLATAFORM}-amd64/kube-aws
    sudo mv /tmp/kube-aws/${PLATAFORM}-amd64/kube-aws /usr/local/bin/kube-aws
    rm -rf /tmp/kube-aws
  fi
}

install_jq(){
  if [[ ${PLATAFORM} == 'linux' ]];then
    sudo apt-get install jq
  elif [[ ${PLATAFORM} == 'darwin' ]];then
    sudo brew install jq
  fi
}

install_aws(){
  env -u AWS_PROFILE aws --version
  if [ $? -ne 0 ];then
    sudo pip install awscli
  fi
}

configure_aws_profile(){
  aws configure list --profile ${AWS_PROFILE} 2> /dev/null
  if [ $? != 0 ]; then
    echo "[${AWS_PROFILE}]" >> ~/.aws/credentials
    echo "aws_access_key_id = ${AWS_ACCESS_KEY}" >> ~/.aws/credentials
    echo "aws_secret_access_key = ${AWS_SECRET_KEY}" >> ~/.aws/credentials
    echo "[profile ${AWS_PROFILE}]" >> ~/.aws/config
    echo "output = json" >> ~/.aws/config
    echo "region = ${AWS_REGION}" >> ~/.aws/config
  fi
}

check_plataform
install_kube-aws
install_jq
install_aws
configure_aws_profile
