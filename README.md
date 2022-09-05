# Kubeflow POC

## Refs

[Kubeflow](https://www.kubeflow.org/) official site

[local Deployment of Kubeflow Pipelines](https://www.kubeflow.org/docs/components/pipelines/installation/localcluster-deployment) in the official doc  
- page last updated Mar 7, 2022 (minor URL fixes)

[Kubernetes Documentation](https://kubernetes.io/docs/home/) official doc


## YouTube 

### HighPrio 
and devops oriented with beefy content, albeit 2 years old 

#### Hands-on Serving Models Using KFserving 
Theofilos Papapanagiotou // MLOps Meetup #40   
[YT link](https://www.youtube.com/watch?v=VtZ9LWyJPdc) | 58 min 
2,978 views Oct 30, 2020   
MLOps community meetup #40! Last Wednesday, we talked to Theofilos Papapanagiotou, Data Science Architect at Prosus, about Hands-on Serving Models Using KFserving.

### YT Channel Radovan Parrak
Good Intro for high altitude view, mostly targets Data Scientists from radovan.parrak@credo.be

#### Kubeflow Tutorial | Model Development
[YT link](https://www.youtube.com/watch?v=gprgs7fua3I) | 25 min
2,712 views Oct 21, 2021  
This video walks you through a simple modeling example in Kubeflow Notebooks.

#### Kubeflow Tutorial | Model Serving
[YT link](https://youtu.be/hRmmzItkPkA) | 14 min
703 views  Oct 21, 2021   
In this video, I walk you through a simple model engineering process using Kubeflow Fairing (Note: nowadays, there is a better way to serve models, with Kubeflow Serving)

`At 11:25 switch POV from Data Scientist to devops`

#### Data Analytics in Retail Banking Conference | Building Sustainable ML Platforms
[YT link](https://youtu.be/wLTjJqWuw0I)
11 views Oct 21, 2021  
My talk on how to build a sustainable ML cloud platform from open-source components at the Data Analytics in Retail Banking conference (https://www.uni-global.eu/portfolio-p....

## Local Installation 
The official doc suggests 3 options for Local Installation:

1. based on `kind`
1. based on Rancher's `k3s`
1. based on `k3ai`, noted alpha  

The doc doesn't say that you need to choose one of the 3, at first glance yu may assume 
that you have to go through all of them  ... 


### toolset macOS
[kustomize](https://kustomize.io/)   
- Note the above link redirects to [kubectl docs](https://kubectl.docs.kubernetes.io/installation/)

~~~
brew install kubernetes-cli
# setup kubectl completion, prerq. `brew install bash-completion`:
kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
# if bash-completion is correctly configured in bashrc or bash_profile,
# source the corresponding rc file 

brew install kustomize
~~~


## Kubeflow on AWS

https://www.kubeflow.org/docs/distributions/aws/


