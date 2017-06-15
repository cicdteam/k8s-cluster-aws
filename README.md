...will be soon


Deploy Kubernetes cluster (1.6.5) over AWS. 

---

### TL;DR

- inspect and edit [settings](settings) file and [settings.local](settings.local.example) file
- create AWS infrastructure by `./deploy-infra deploy`
- create Kubernetes master node by `./deploy-master deploy`
- create -Kubernetes worker nodes by `./deploy-worker deploy`
- get config for local `kubectl` by `./getkubeconfig`

- play with cluster

- destroy everything by `./deploy-worker destroy && ./deploy-master destroy && ./deploy-infra destroy`


>NOTE: all scripts except `getkubeconfig` will show usage info if run them without arguments


### Tools used

- Terrafrom
- kubeadm
- Bash
