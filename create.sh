#!/usr/bin/env bash

# Version Parameters - change according to src 
#export ISTIO_VERSION=1.15.0
#xport PIPELINE_VERSION=1.8.5
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
			printf "Bailing out..."
			exit 0
		fi
		printf "sleeping $SLEEP_SEC...\n"
		sleep $SLEEP_SEC
	done
}


# Delete the old cluster
delete_prev_cluster
stt=$(date '+%s')

# Create the kind cluster
time kind create cluster --name $CLUSTER_NAME --config kind-cluster-config.yaml

# populate the cluster with kubeflow, with over 60 pods
cd manifests-1.6.0
while ! kustomize build example | kubectl apply -f -; do
	echo "Retrying to apply resources"
	sleep $SLEEP_SEC done

ent=$(date '+%s')

printf "${EMBLU}Cluster $CLUSTER_NAME creation complete${RESET}. use k9s to wait for all pods RUNNING\n"
printf "This may take 8 minutes or more\n\n" 
printf "The kubeflow dashboard should be at ${FGYEL}http://localhost:8080${RESET}\n"
printf "once you run port-forwarding:\n"
printf "    kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80\n"

et=$(date "+%F %H:%M:%S")
printf "${GREEN}Finished:$RESET $et, elapsed $((ent - stt)) seconds\n\n"
