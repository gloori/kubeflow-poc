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

1. based on `kind`
1. based on Rancher's `k3s`
1. based on `k3ai`, noted alpha  

### Other 

**miniKF**   
was an option in the past, recent doc dropped it entirely. This option relied on
[`minikube`](https://minikube.sigs.k8s.io/docs/start/) installation. 

I may explore this direction later. 

**Plethora**  
Listed in a [Linkedin blog post](https://www.linkedin.com/pulse/run-kubernetes-locally-minikube-microk8s-k3s-k3d-kind-sangode) __Run Kubernetes Locally using - minikube, microk8s, k3s, k3d, k0s, kind, crc, minishift, firekube__ 

This short blog just enumerate the many alternatives to start off a local installation. 

### Candidate Reduction 
I eliminate the `k3ai` option as it's layered on top of `k3s`, it's WIP and the site isn't 
convincing. 

Rancher's `k3s` is a certified Kubernetes distribution

### macOS Virtualization Considerations 
Both `kind` and `k3s` are layered on top of some virtualization because native container 
enablement is in the Linux Kernel (namespaces and cgroups). On macOS some shim is required. 

On macOS, there are only 2 practical alternatives to virtualization: 

- **HyperKit** which is bundled with __Docker Desktop__   
- **Virtualbox**, which covers also the vagrant option.  

Virtualbox does and will not work on Apple Silicon (M1 chips), so we're left with HyperKit. 


### Version and Look-ahead Considerations 

Snapshot of versions of different tools/products as of this writing:

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

Given that AWS lags 2 releases behind the k8s version used on macOS, expect issues.... 



### Documentation and macOS specificity's 
Both `kind` and `k3s` target mainly Linux. 

- `k3s` doc doesn't even mention macOS 
- `kind` .... 


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

## Kubeflow on AWS
[Kubeflow page](https://www.kubeflow.org/docs/distributions/aws/) 


