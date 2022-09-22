#!/usr/bin/env bash

# Version Parameters - change according to src 
export ISTIO_VERSION=1.15.0
export PIPELINE_VERSION=1.8.5
export CLUSTER_NAME=kubeflow-cluster
export SLEEP_SEC=10   # quiesence after deleting a cluster

# colors
GREEN="\033[32m"
EMBLU="\033[48;5;57m"
FGYEL="\033[38;5;227m"
RESET="\033[0;37m"

printf "${GREEN}Started :$RESET "; date "+%F %H:%M:%S"

function delete_prev_cluster
{
	old_cluster=$(kind get clusters | paste -d ' ' -s -)
	for kf in $old_cluster; do
		printf "Delete kind cluster ${FGYEL}$kf${RESET} "
		read -p "[y]: " ANS; [[ -z $ANS ]] && ANS="y";
		if [[ $ANS == "y" ]]; then
			kind delete cluster --name $kf
		else
			printf "Baining out..."
			exit 0
		fi
		printf "sleeping $SLEEP_SEC...\n"
		sleep $SLEEP_SEC
	done
}

function kustomize_kubeflow_pipelines
{
	kubectl apply -k "github.com/kubeflow/pipelines/manifests/kustomize/cluster-scoped-resources?ref=$PIPELINE_VERSION"
	kubectl wait --for condition=established --timeout=60s crd/applications.app.k8s.io
	kubectl apply -k "github.com/kubeflow/pipelines/manifests/kustomize/env/platform-agnostic-pns?ref=$PIPELINE_VERSION"
}

function create_istio_ingress
{
	cd istio
	curl -L https://istio.io/downloadIstio | sh -
	istio-${ISTIO_VERSION}/bin/istioctl install --set profile=minimal -y

	kubectl apply -f ingress.yaml
	kubectl apply -f gateway.yaml
	kubectl apply -f virtualservice.yaml
	cd ..
}

# Delete the old cluster
#kind delete clusters kubeflow-cluster
delete_prev_cluster
stt=$(date '+%s')

# Create the new cluster
time kind create cluster --name $CLUSTER_NAME --config kind-cluster-config.yaml

#time kustomize_kubeflow_pipelines

#time create_istio_ingress
ent=$(date '+%s')

printf "${EMBLU}Cluster $CLUSTER_NAME creation complete${RESET}.\n"
#Expect 3-4 mins for istio to become RUNNINg\n"
#printf "The kubeflow dashboard should be at  ${FGYEL}http://kubeflow.local.gd${RESET}\n"

et=$(date "+%F %H:%M:%S")
printf "${GREEN}Finished:$RESET $et, elapsed $((ent - stt)) seconds\n"
