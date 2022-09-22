# Kubeflow POC

## Objective 

- run `Kubeflow` locally on mac  
- with the experience collected locally, run it in AWS, preferably **EKS**

## Contents

- [Kubeflow POC](#kubeflow-poc)
  - [Objective](#objective)
  - [Contents](#contents)
  - [Changelog](#changelog)
  - [Background and References](#background-and-references)
  - [Options for Local Installation](#options-for-local-installation)
    - [Official Kubeflow doc](#official-kubeflow-doc)
    - [Other options for Local Installation](#other-options-for-local-installation)
    - [Candidate Reduction](#candidate-reduction)
    - [macOS Virtualization Considerations](#macos-virtualization-considerations)
    - [Version and Look-ahead Considerations](#version-and-look-ahead-considerations)
    - [Documentation and macOS Specific Targeting](#documentation-and-macos-specific-targeting)
      - [`k3s`](#k3s)
      - [`kind`](#kind)
  - [Prerequisite toolset on macOS](#prerequisite-toolset-on-macos)
    - [Install kubectl and kustomize](#install-kubectl-and-kustomize)
    - [Install Docker Desktop](#install-docker-desktop)
      - [Version](#version)
      - [Settings](#settings)
  - [Using Kubeflow with `kind`](#using-kubeflow-with-kind)
    - [Install `kind`](#install-kind)
    - [Create Cluster](#create-cluster)
  - [Deploy Kubeflow Pipelines](#deploy-kubeflow-pipelines)
    - [Connect to the Kubeflow Pipelines UI](#connect-to-the-kubeflow-pipelines-ui)
  - [Record of State After Deployment](#record-of-state-after-deployment)
    - [deployments](#deployments)
    - [pods](#pods)
  - [~~~](#)
  - [TODOs](#todos)
  - [Using Kubeflow with `k3s`+ `k3d`](#using-kubeflow-with-k3s-k3d)
  - [Kubeflow on AWS](#kubeflow-on-aws)
  - [References](#references)
    - [YouTube](#youtube)
      - [Hands-on Serving Models Using KFserving](#hands-on-serving-models-using-kfserving)
      - [YT Channel _Radovan Parrak_ / credo.be](#yt-channel-radovan-parrak--credobe)

## Changelog
* 2022-09-06 `v0.1.0 tested by Keith on his Mac (spec TBD, probably M1)`
* 2022-09-08 `v0.1.1 tested on Intel mbp 2019 i7@2.6GHz X 6 core, 16G RAM`

## Background and References
see [References](#References) by EOF

## Options for Local Installation 

### Official Kubeflow doc
The official doc suggests 3 options for local installation on a laptop. 
The doc **doesn't state** that you need to choose **one** of the 3. At first glance you may assume 
that you have to go through all of them  ... 

1. based on [`kind`](https://kind.sigs.k8s.io/)
1. based on Rancher's [`k3s`](https://k3s.io/)
1. based on [`k3ai`](https://k3ai.github.io/docs/intro), noted alpha  

### Other options for Local Installation
After close examination of the docs of the above options (details below), and given
the poor impression, I extended the search. The findings so far are summarized below: 

~~**miniKF**~~   
Was an option in the past, recent doc dropped it entirely. This option relied on
[`minikube`](https://minikube.sigs.k8s.io/docs/start/) installation.  
I may explore minikube some other time. 

**Plethora of others**  
A few other standalone candidates are listed in a 
[Linkedin blog post](https://www.linkedin.com/pulse/run-kubernetes-locally-minikube-microk8s-k3s-k3d-kind-sangode) 
_Run Kubernetes Locally using - minikube, microk8s, k3s, k3d, k0s, kind, crc, minishift, firekube_   
This short blog merely enumerates the many alternatives to start off a local installation. 

- `minikube` is discussed above. 
- `microk8s` from Canonical may worth a closer examination. 
- `minishift` from RedHat may worth a closer examination. 
- `k3s` + `k3d` are discussed below. 
- `kind` is discussed below. 

### Candidate Reduction 
**`k3ai`**   
I eliminate the `k3ai` option since: 

- it's tagged `alpha` and WIP   
- its github repo isn't active (last commit 6 months ago) 
- it's layered on top of `k3s`
- the site isn't convincing. understatement. 

That said, there's MLOps section that may be worth examining more closely if all other fails. 


**Rancher's `k3s`**  
is a certified Kubernetes distribution, and thus a serious contender. But:  
- the documentation targets Linux only, and `k3d` is required to fill in 
for macOS
- as we see in the version table below, it's lagging one minor behind the 
official Kubernetes (1.24.4 vs 1.25.0)

**`kind`**   
is a `kubernetes-sigs` project, tightly following the official Kubernetes.   
Its documentation
sucks, but it's listed as the 1st installation option and let's hope there's a reason... 

### macOS Virtualization Considerations 
Both `kind` and `k3s` are layered on top of some virtualization because native container 
enablement is in the Linux Kernel (namespaces and cgroups). 

On macOS, there are only 2 practical alternatives to virtualization: 

- **HyperKit** which is the core component of _Docker Desktop for Mac_   
- **Virtualbox** which used to be the solution (this covers also the vagrant option)  

Virtualbox does and will not work on Apple Silicon (M1 chips), so we're left with Docker Desktop. 


---
### Version and Look-ahead Considerations 

Snapshot of versions of different tools/products, as of this writing, are presented in
the _version table_ below:

| product        | k8s version | release date | comments         |
|----------------|---------|--------------|------------------|
| Kubernetes     | 1.25.0  | 2022-08-23   | k8s latest official
| Docker Desktop | 1.25.0  | 2022-09-01   | bundled with Docker Desktop 4.12.0 (85629)
|----------------|---------|--------------|------------------|
| EKS latest     | 1.23.7  | 2022-08-11   | AWS eks.1
| k8s 1.23       | 1.23.9  | 2022-07-13   | latest official k8s fix for rel 1.23
| k8s 1.23.7     | 1.23.7  | 2022-05-26   | official k8s minor used by EKS 
|----------------|---------|--------------|------------------|
| k3s latest     | 1.24.4  | 2022-08-25   | [v1.24.4+k3s1](https://github.com/k3s-io/k3s/releases)
| kind latest    | 1.25.0  | 2022-08-25   | version of the default node image, in kind [v0.15.0](https://github.com/kubernetes-sigs/kind/releases)

Given that AWS lags 2 releases behind the k8s version used on macOS, let's expect issues
when deploying there .... 


---
### Documentation and macOS Specific Targeting
Evaluation of the 2 installation options for Local Deployment matters a lot.  
Both `kind` and `k3s` target mainly Linux and the documentation targeting macOS
is sloppy.

#### `k3s`
The doc doesn't even mention macOS, the wrapper `k3d` should handle that.  

#### `kind` 
I edit the following list while reading and executing the steps in the 
[getting started doc](https://kind.sigs.k8s.io/docs/user/quick-start/)
and linked pages. 

- Installation Prerequisites  
The doc doesn't list the _prerequisites_ (at all). Let alone whether _Docker Desktop_
is a prerequisite.  
**It is**, and once installed we see the `kind-control-plane` is listed as node in 
Docker Desktop's dashboard. 

- Non-AMD64 Architectures  
If true, this may drop this option.  
The [known issues](https://kind.sigs.k8s.io/docs/user/known-issues)
page says this:
    > KIND does not currently ship pre-built images for non-amd64 architectures. In the future we may,
    > but currently demand has been low and the cost to build has been high.  

  This statement is assumed to be obsolete, as the [release page](https://github.com/kubernetes-sigs/kind/releases)
lists `kind-darwin-arm64`

- Docker Desktop for macOS and container networks   
Another known issue is described as: 
    > the container networks are not exposed to the host and you cannot reach the `kind` nodes via IP. You
    > can work around this limitation by configuring extra port mappings though.

  This needs to be tested... 

- Docker Desktop Resource Limit Adjustment   
The quick-start page has this: 
    > If you are building Kubernetes (for example - kind build node-image) on MacOS or Windows then you
    > need a minimum of 6GB of RAM dedicated to the virtual machine (VM) running the Docker engine. 
    > **8GB is recommended**

  This statement is obsolete, the current default mem setting is 8GB. 

- Ambiguity running `kubeflow` pipeline  
Back to kubeflow's 
[Local Deployment](https://www.kubeflow.org/docs/components/pipelines/installation/localcluster-deployment/#1-installing-kind) _Install kind_ section, there's a disturbing note: 
    > Note: kind uses `containerd` as a default container-runtime hence you **cannot use the standard
    > kubeflow pipeline manifests**.

  The _`cannot use the standard kubeflow pipeline manifests`_ is troubling, need to test what it means



## Prerequisite toolset on macOS

### Install kubectl and kustomize

[kustomize](https://kustomize.io/) requires `kubectl`  
- Note that _kustomize_ is part of Kubernetes (despite the link and site look). 

~~~
brew install kubernetes-cli kustomize k9s
~~~

**kubectl completion**

I'm using `bash`, so prerq. is `brew install bash-completion`:
~~~
kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
~~~
if bash-completion is correctly configured in bashrc or bash_profile,
source the corresponding rc file and **verify**:
~~~
kubectl v[tab]   # should complete to version
~~~

### Install Docker Desktop 
Available in _Globality Self-Service_, or from 
[Docker Desktop page](https://docs.docker.com/desktop/install/mac-install/):

1. Download the binary: Intel or M1 (file is not a universal binary!) 
1. Install 
1. Launch 

You may need to register with Docker Hub

#### Version
For reference (mid Sept 2022), I'm using Docker Desktop Version 4.12.0 (85629)


#### Settings 

**Kubernetes** don't Enable[!], it's not used.

For **Resources** the default values are below, I didn't change: 

 Resource       | Value 
----------------|---------:
CPUs            |  6
Memory          |  8G
Swap            |  1G
Disk image size | 60G

Disk image location: `~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw`  
The actual file size may be smaller than shown by `ls` (sparse file). 
For reference, on my system it's 22GB. 



**Docker Engine**

The json config of the _Docker Engine_ is copied in `docker-desktop_engine-config.yaml` in this repo. 


## Using Kubeflow with `kind` 

### Install `kind` 
I followed the [Kind Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
to install **version v0.15.0** 
The doc isn't clear, the instructions below are verified to work. 

~~~sh
brew install kind
~~~
this takes ~20 secs: 

### Create Cluster
This will bootstrap a Kubernetes **single-node** cluster using a pre-built node image. 
One node is enough to support the demo ... 

**Note** `kind` doesn't provide means to freeze/pause the cluster. Once created,
you can only delete it. However, it survives Docker and macOS restarts. 

Run: 

~~~sh
$ kind create cluster --name kftest01
~~~

Sample output: 
~~~
Creating cluster "kftest01" ...
 ✓ Ensuring node image (kindest/node:v1.25.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kftest01"
You can now use your cluster with:

kubectl cluster-info --context kind-kftest01

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/


Thanks for using kind! 😊
~~~

Verify with `kubectl`: 
~~~
$ kubectl config get-clusters
NAME
kind-kftest01


$ kubectl cluster-info --context kind-kftest01
Kubernetes control plane is running at https://127.0.0.1:65051
CoreDNS is running at https://127.0.0.1:65051/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
~~~

using `kind`:
~~~
$ kind get clusters
kftest02
~~~



## Deploy Kubeflow Pipelines
Now that you have a Kubernetes cluster up and running,
run the script `deploy-kubeflow-pipelines.sh` or copy the code snippet from the 
[source](https://www.kubeflow.org/docs/components/pipelines/installation/localcluster-deployment/#deploying-kubeflow-pipelines). 

The script runs `PIPELINE_VERSION=1.8.5`, which as of this writing, is latest. 

Noteworthy: 

- It takes a few minutes for the containers to download and connect
- A new namespace is created, `kubeflow`

You can monitor the state with: 
~~~
kubectl get po -n kubeflow
~~~

If you see containers' status of `ContainerCreating` and even `CrashLoopBackOff` simply wait. 

### Connect to the Kubeflow Pipelines UI

**port-forwarding** run this foreground task in a separate terminal or tab:
~~~
kubectl port-forward -n kubeflow svc/ml-pipeline-ui 8080:80
~~~

**browser** goto `http://localhost:8080`

You may choose a port other than 8080. Adjust the port-forwarding and URL accordingly. 

## Record of State After Deployment 

Inventory for the record

### deployments
~~~
$ kubectl -n kubeflow get deployment
NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
cache-deployer-deployment         1/1     1            1           5h34m
cache-server                      1/1     1            1           5h34m
metadata-envoy-deployment         1/1     1            1           5h34m
metadata-grpc-deployment          1/1     1            1           5h34m
metadata-writer                   1/1     1            1           5h34m
minio                             1/1     1            1           5h34m
ml-pipeline                       1/1     1            1           5h34m
ml-pipeline-persistenceagent      1/1     1            1           5h34m
ml-pipeline-scheduledworkflow     1/1     1            1           5h34m
ml-pipeline-ui                    1/1     1            1           5h34m
ml-pipeline-viewer-crd            1/1     1            1           5h34m
ml-pipeline-visualizationserver   1/1     1            1           5h34m
mysql                             1/1     1            1           5h34m
workflow-controller               1/1     1            1           5h34m
~~~

### pods
~~~
$ kubectl -n kubeflow get po
NAME                                               READY   STATUS    RESTARTS        AGE
cache-deployer-deployment-6775db7d9f-2qjsk         1/1     Running   0               5h33m
cache-server-d9b96559b-rz4dm                       1/1     Running   0               5h33m
metadata-envoy-deployment-d848cdb-m9khh            1/1     Running   0               5h33m
metadata-grpc-deployment-784b8b5fb4-knnf8          1/1     Running   7 (5h27m ago)   5h33m
metadata-writer-6447bd6f55-tjlhr                   1/1     Running   2 (5h25m ago)   5h33m
minio-65dff76b66-zfb4q                             1/1     Running   0               5h33m
ml-pipeline-685b7b74d-nw52k                        1/1     Running   7 (5h26m ago)   5h33m
ml-pipeline-persistenceagent-bd9f8d4d7-qbj6s       1/1     Running   2 (5h25m ago)   5h33m
ml-pipeline-scheduledworkflow-544c8bbc58-jvdfm     1/1     Running   0               5h33m
ml-pipeline-ui-6c895bb85b-9754x                    1/1     Running   0               5h33m
ml-pipeline-viewer-crd-79db74f698-jqqn2            1/1     Running   0               5h33m
ml-pipeline-visualizationserver-74fbc54649-xrrvw   1/1     Running   0               5h33m
mysql-67f7987d45-b62kf                             1/1     Running   0               5h33m
workflow-controller-594fd96fd5-pjmw8               1/1     Running   1 (3h56m ago)   5h33m
~~~
---
## TODOs 

Instructions for Testing and Notebook demo 

Improve on the Cluster Creation:   
- dedicated worker node or 2 
- resource monitoring 
- tune docker server resources (CPUs and RAM) 





## Using Kubeflow with `k3s`+ `k3d`
TBC


## Kubeflow on AWS

**TBC**

[Kubeflow page](https://www.kubeflow.org/docs/distributions/aws/) 


## References

[Kubeflow](https://www.kubeflow.org/) official site

[local Deployment of Kubeflow Pipelines](https://www.kubeflow.org/docs/components/pipelines/installation/localcluster-deployment) in the official doc  
- page last updated Mar 7, 2022 (minor URL fixes)

[Kubernetes Documentation](https://kubernetes.io/docs/home/) official doc


### YouTube 

**HighPrio**  and devops oriented with beefy content, albeit 2 years old 

#### Hands-on Serving Models Using KFserving 
Theofilos Papapanagiotou // MLOps Meetup #40   
[YT link](https://www.youtube.com/watch?v=VtZ9LWyJPdc) | 58 min 
2,978 views Oct 30, 2020   
MLOps community meetup #40! Last Wednesday, we talked to Theofilos Papapanagiotou, Data Science Architect at Prosus, about Hands-on Serving Models Using KFserving.

#### YT Channel _Radovan Parrak_ / credo.be
Good Intro for high altitude view, mostly targets Data Scientists from radovan.parrak@credo.be

**Kubeflow Tutorial | Model Development**

[YT link](https://www.youtube.com/watch?v=gprgs7fua3I) | 25 min
2,712 views Oct 21, 2021  
This video walks you through a simple modeling example in Kubeflow Notebooks.


**Kubeflow Tutorial | Model Serving**

[YT link](https://youtu.be/hRmmzItkPkA) | 14 min
703 views  Oct 21, 2021   
In this video, I walk you through a simple model engineering process using Kubeflow Fairing (Note: nowadays, there is a better way to serve models, with Kubeflow Serving)

`At 11:25 switch POV from Data Scientist to devops`


**Data Analytics in Retail Banking Conference | Building Sustainable ML Platforms**

[YT link](https://youtu.be/wLTjJqWuw0I)
11 views Oct 21, 2021  
My talk on how to build a sustainable ML cloud platform from open-source components at the Data Analytics in Retail Banking conference (https://www.uni-global.eu/portfolio-p....
