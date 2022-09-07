# kubernetes

## Content
#### 1. kind install

```
[ $(uname -m) = x86_64 ]&& curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.13.0/kind-darwin-amd64
chmod +x ./kind
mv ./kind /some-dir-in-your-PATH/kind
```

### #2. kind create cluster

```
./kind create cluster --image kindest/node:v1.24.0
```

#### 3. kubernetes terminology

3.1 kubectl
- allow us to talk to api-server
- kubeconfig include context (point to dev/uat/prod)

3.2 control plane
- The control plane manages the worker nodes and the Pods in the cluster
- the control plane usually runs across multiple computers and a cluster usually runs multiple nodes  
- the api server run in control plane alongside with the scheduler and other controller
- make sure the desired state matches the actual state

3.3 apply objects as yaml files
- A pod is a workload that we want to deploy to kubernetes and can be (script, code, application)
- A pod has a name, label, metadata (annotations)
- A process in pod is called container
- A pod can contain more than one container
- A container can have 
  + environment variables 
  + ports to receive network traffic 
  + resources define request value of how much cpu and memory needed and limits k8s will throttle pods use more cpu and kill pod go
    over their memory limit
  + liveness probe ensure that container are alive and k8s will restart the pod if the probe condition is not met
  + readiness probes tell k8s when the pod is ready to take traffic, this is for pods that may need to initialize data
    or get ready to accept network connection
  + startup probe executed only at the start and designed for slow starting container with an unpredictable initialization process
  + volume mounts allow us to mount files into specific paths of the container, volume need to be defined
  + volume is medium of storage attached to a pod, volume can be a folder on the host where the pod is running,
  a persistent volume, configuration or secret
  + configurations are defined as config map allowed to store configuration for pods as files or key value pair
  that can be mapped to environment variable,
  + secret is similar can store files tls certificate or key value pair that can be mapped to environment variable 
- Ways to run pods:
  + cronjob: schedule a job -> your own custom schedule, schedule triggered a jobs get created and a job can
    run on one or more pods
  + deployment: run a job constantly as webserver/proxy/application -> have replicas tells kubernetes number of
    pods run concurrently
- nodes are machines where containers run as pods
  + pods are distributed across nodes in the cluster
  + nodes can be physical, on-prem or virtual cloud machines
  + pods are created, they may move around -> okey for webserver but not for databases or caches (statefulsets solve this problem)
- statefulsets: same to deployment but allows to pin pods to nodes when a pod restart it get recreated on the same node to ensure
  its storage is reattached to the same pod
  + statefulset can also have replicas and pod information as described earlier
  + volumeclaim templates: dynamically provision storage for a new pod when scales up using storage class
  + storageclass: abstract storage cluster offer as (azure file, file share, aws block-storage, gce disk, 
    nfs network share, local file storage), defined at a cluster level, can be consumed by platform,
    to consume storage class in a pod -> define a persistent volume
  + A persistent volume indicates its storage class and represents a size of the storage available to the cluster
      every pod can have its own persistent volume or you can share persistent volume thro persistent volume claim
  + Persistent volume claims allow developers to claim storage from a persistent volume without having to provision
      or interact with storage itself
- daemonset: to run a pod on every nodes
  + set its own schedule mechanism to ensure pod run on every nodes (used for monitoring agents on each nodes 
    log collector to collect logs from each node or a daemon that provisions node storage)
- service: enable network communication between pods, how to access pods over network, to define service:
  + give a service name
  + select pod using label selector
  + define service port and map it to a pod container port, the pod the accessible over service name as dns + port
  + type of services available: 
    * cluster-ip (private communication) 
    * loadbalancer (public communication) 
    * headless service (each pod to have dns without balancing)
    * nodeport (pod can be reached by public ip and port of the node) -> very limited
    * services are very basic -> should use proxy to serve traffic over url, https and route based on domain
    or url path
- ingress: rule set that allow that allows us to define how we want to accept traffic into the cluster without
  having to configure proxies and routes to various services. Rule to define:
  + define host domain
  + url path
  + target service endpoint
  + port
  + this allows us to accept traffic on a single loadbalancer service and route request to different private services
- ingress controller: manage ingress objects which watches the state of ingresses and updates its core proxy whenever ingresses gets
added deleted or updates. Type of ingress controller
  + nginx
  + traffic
  + enviy
  + haproxy
- controllers: are pods tha run in controller loop
  + control loop is a non-terminating loop that regulates the state of the system
  + a controller tracks at least one kubernetes resource type 
  + ingress controller tracks ingress objects
  + we can even build our own controller -> if you wish to extend kubernetes
- namespace: provide a wayt to divide cluster resources among user/team/department
  + deploy monitoring pods to a monitoring namespace
  + deploy ingress controller to its own namespace
  + all control plane pods are in the cube-system namespace
  + name should be unique per namespace
  + permission to namespace using RBAC
  + Roles and rolebinding permission to objects in a namespace  
  + cluster role and cluster rolebinding permission across all namespace
## Reference

[Lib] Kubernetes SIGs - [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) \
[Code] Kubernetes SIGs - [kind](https://github.com/kubernetes-sigs/kind/) \
[Vid] That DevOps Guy - [Kubernetes Terminology](https://www.youtube.com/watch?v=Ero82CCQIGk) \
[Blog] Nic Vermande - [How To Build a CI/CD Pipeline for Kubernetes Stateful Applications](https://betterprogramming.pub/how-to-build-a-ci-cd-pipeline-for-kubernetes-stateful-applications-aef6c8c5edc2) \
[]