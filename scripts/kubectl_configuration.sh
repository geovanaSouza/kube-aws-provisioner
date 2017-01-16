#!/bin/bash

source scripts/.set-env.sh

kubectl_version=v1.4.6
MASTER_HOST=${EXTERNAL_DNS}
CERTS_PATH=<insert_your_certs_path>
CA_CERT=${CERTS_PATH}/ca.pem
ADMIN_KEY=${CERTS_PATH}/admin-key.pem
ADMIN_CERT=${CERTS_PATH}/admin.pem
DEFAULT_CONTEXT=<insert_your_k8s_context>

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

copy_key(){
  mkdir -p ${CERTS_PATH}
  cp k8s_${CLUSTER_NAME}/credentials/ca.pem ${CERTS_PATH}/
  cp k8s_${CLUSTER_NAME}/credentials/admin-key.pem ${CERTS_PATH}/
  cp k8s_${CLUSTER_NAME}/credentials/admin.pem ${CERTS_PATH}/
}

install_kubectl(){
  check_plataform
  if [ ! -f "/usr/local/bin/kubectl"  ];then
    curl -O https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/${PLATAFORM}/amd64/kubectl
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
  fi
}

configure_kubectl(){
  kubectl config set-cluster ${DEFAULT_CONTEXT}-cluster --server=https://${MASTER_HOST} --certificate-authority=${CA_CERT}
  kubectl config set-credentials ${DEFAULT_CONTEXT}-admin --certificate-authority=${CA_CERT} --client-key=${ADMIN_KEY} --client-certificate=${ADMIN_CERT}
  kubectl config set-context ${DEFAULT_CONTEXT} --cluster=${DEFAULT_CONTEXT}-cluster --user=${DEFAULT_CONTEXT}-admin
  kubectl config use-context ${DEFAULT_CONTEXT}
}

install_kubectl
copy_key
configure_kubectl


