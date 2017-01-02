# Kube aws provisioner.

## Setup Aws

- Installing clients needed in local dektop
```
./scripts/001-desktop_provider_configuration.sh
```
- Creating certificates in ARN
```
./scripts/002-create_kms.sh
```
- Creating initial files to cluster
```
./scripts/003-cluster-init.sh
```
- Start up k8s cluster
```
./scripts/004-cluster-start.sh
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
