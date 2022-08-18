#!/usr/bin/env bash

set -o errexit

REPO_ROOT="${REPO_ROOT:-$(dirname "${BASH_SOURCE}")/../..}"
BINDIR="${BINDIR:-${REPO_ROOT}/bin}"
IMG="${IMG:-quay.io/jetstack/cert-manager-google-cas-issuer:latest}"
E2E_LOG_DIR="${E2E_LOG_DIR:-${REPO_ROOT}/_artifacts/e2e/logs}"

export PATH="${BINDIR}:${PATH}"


KUBECONFIG=${BINDIR}/kubeconfig.yaml

function export_logs {
  echo "Exporting e2e test logs"
  rm -rf ${E2E_LOG_DIR}
  mkdir -p ${E2E_LOG_DIR}
  kind export logs --name casissuer-e2e ${E2E_LOG_DIR}
}

cd $REPO_ROOT

kind version
kind create cluster --name casissuer-e2e
kind export kubeconfig --name casissuer-e2e --kubeconfig $KUBECONFIG
kind load docker-image --name casissuer-e2e $IMG
kubectl --kubeconfig $KUBECONFIG apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.yaml
kustomize build config/crd | kubectl --kubeconfig $KUBECONFIG apply -f -
cd config/manager; kustomize edit set image controller=${IMG}
kustomize build config/default | kubectl --kubeconfig $KUBECONFIG apply -f -
timeout 5m bash -c 'until $(KUBECTL) --kubeconfig $KUBECONFIG --timeout=120s wait --for=condition=Ready pods --all --namespace kube-system; do sleep 1; done'
timeout 5m bash -c 'until $(KUBECTL) --kubeconfig $KUBECONFIG --timeout=120s wait --for=condition=Ready pods --all --namespace cert-manager; do sleep 1; done'
trap export_logs EXIT
ginkgo -nodes 1 test/e2e/ -- --kubeconfig $$(pwd)/$KUBECONFIG --project jetstack-cas --location europe-west1 --capoolid issuer-e2e
$(KUBECTL) --kubeconfig $KUBECONFIG cluster-info dump --all-namespaces --output-directory ${E2E_LOG_DIR}/kubectl-cluster-info-dump --output yaml
$(KUBECTL) --kubeconfig $KUBECONFIG describe cert-manager --all-namespaces > ${E2E_LOG_DIR}/cert-manager-resources.yaml
$(KIND) delete cluster --name casissuer-e2e
