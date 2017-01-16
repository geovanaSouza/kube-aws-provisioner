# Kube aws provisioner.

## Setup Aws

- Rename scripts/.set-env.sh.template to scripts/.set-env.sh replacing the environment variables 

- Execute first script to instal clients needed in local dektop
```
./scripts/001-desktop_local_configuration.sh
```
- Creating initial files to cluster
```
./scripts/002-cluster-init.sh
```
- Start up k8s cluster
```
./scripts/003-cluster-provisioner.sh
```

## Update app
```
./scripts/provision-local.sh update <namespace> <application>
```

## Accessing kube-dashboard
```
kubectl proxy
```
Open http://localhost:8001/ui/
