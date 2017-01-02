#!/bin/bash

ACTION=$1

if [[ $ACTION == 'update' ]]; then
  NAMESPACE=$2
  APP=$3
  DEFINITION_FILE=$(echo apps/${NAMESPACE}/[0-9][0-9][0-9]-${APP}.yaml)
  kubectl delete rc ${APP} -n ${NAMESPACE}
  kubectl create -f ${DEFINITION_FILE} -n ${NAMESPACE}


else
  echo 'Provisioner:'
  echo
  echo '  To update app'
  echo '    ./scripts/provision-local.sh update <namespace> <application>'
  echo
fi
