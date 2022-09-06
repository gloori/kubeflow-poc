# Kubeflow POC

## Refs

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

#### YT Channel Radovan Parrak
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
- its site isn't convincing. 

**Rancher's `k3s`**  
is a certified Kubernetes distribution, and thus a serious contender. But:  
- the documentation targets Linux only, and `k3d` is required to fill in 
for macOS
- as we see in the version table below, it's lagging one minor behind the 
official Kubernetes (1.24.4 vs 1.25.0)

**`kind`**   
is a kubernetes-sigs project tightly following the official Kubernetes.   
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

Snapshot of versions of different tools/products, as of this writing, are presnted in
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
It is, and once installed we see the `kind-control-plane` is listed as node in 
Docker Desktop's dashboard. 

- Non-AMD64 Architectures  
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

This statement is obsolete, the current default RAM is 8GB. 

- Ambiguity running `kubeflow` pipeline  
Back to kubeflow's 
[Local Deployment](https://www.kubeflow.org/docs/components/pipelines/installation/localcluster-deployment/#1-installing-kind) Install kind page, there's a disturbing note: 
    > Note: kind uses containerd as a default container-runtime hence you cannot use the standard
    > kubeflow pipeline manifests.



## Prerequisite toolset on macOS

### kubectl and kustomize
[kustomize](https://kustomize.io/) requires `kubectl`  
- Note the above link redirects to [kubectl docs](https://kubectl.docs.kubernetes.io/installation/)

~~~
brew install kubernetes-cli
brew install kustomize
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

### Docker Desktop 
Available in _Globality Self-Service_, or from 
[Docker Desktop page](https://docs.docker.com/desktop/install/mac-install/):

1. Download the binary: Intel or M1 (file is not a universal binary!) 
1. Install 
1. Launch 

You may need to register with Docker Hub


## Using Kubeflow with `kind` 

### Instal `kind` 
Follow [Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/#installation).   
This takes ~20 secs: 
~~~sh
brew install kind
~~~

### Create Cluster
This will bootstrap a Kubernetes cluster using a pre-built node image:

Sample output: 
~~~
$ kind create cluster
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.25.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Thanks for using kind! 😊
~~~

Verify with `kubectl`: 
~~~
$ kubectl config get-clusters
NAME
kind-kind
docker-desktop

$ kubectl cluster-info --context kind-kind
Kubernetes control plane is running at https://127.0.0.1:65051
CoreDNS is running at https://127.0.0.1:65051/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
~~~

using `kind`:
~~~
$ kind get clusters
kind
~~~






## Kubeflow on AWS
[Kubeflow page](https://www.kubeflow.org/docs/distributions/aws/) 


