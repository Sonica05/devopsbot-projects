# Kubernetes Cluster Setup on AWS EC2 (1 Master, 2 Workers)

This project demonstrates how to manually create a Kubernetes cluster using **Amazon Linux 2 EC2 instances**. It includes setting up one master node and two worker nodes, connected over private IPs, using Weave CNI.

---

## 🏗️ Infrastructure

- 1 Master Node: `master.tg.com`
- 2 Worker Nodes: `wn1.tg.com`, `wn2.tg.com`
- Private IPs configured in `/etc/hosts`

---

## ⚙️ Prerequisites

- AWS account
- Key pair (.pem) for SSH
- Security Group allowing:
  - Port 22 (SSH)
  - Port 6443 (K8s API)
  - Weave ports 6783, 6784 (TCP/UDP)

---

## 🚀 🔧 Step-by-Step Guide

### [Step 1] Launch 3 EC2 Instances

1. Login to AWS Console

2. Launch 3 Amazon Linux 2 EC2 instances (t2.medium recommended)

3. Name them:
-master.tg.com
, wn1.tg.com
& wn2.tg.com

4. Enable Security Group:
Allow SSH (22), K8s (6443), Weave (6783/UDP, 6783-6784/TCP), and all internal communication

### [Step 2] Connect EC2 to MobaXterm

1. Open MobaXterm → Start new SSH session

2. Use .pem file (click on Advanced SSH settings → Use private key)

3. Save sessions for all 3 instances

### [Step 3] Pre-work Setup (on all nodes)

a. Set hostname

```bash
# On respective nodes
sudo hostnamectl set-hostname master.tg.com
sudo hostnamectl set-hostname wn1.tg.com
sudo hostnamectl set-hostname wn2.tg.com

```
b. Add host entries
```bash
sudo vi /etc/hosts
# Add:
172.31.24.17   master.tg.com
172.31.24.132  wn1.tg.com
172.31.29.2    wn2.tg.com
```

### [Step 4] SSH Key Setup (On Master Node)

Generate key on master:
```bash
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
```

Copy the public key, and on wn1 and wn2, paste it into::
```bash
vi ~/.ssh/authorized_keys
```
Then test:
```bash
ssh root@wn1.tg.com
ssh root@wn2.tg.com
```

### [Step 5] Kernel Module Update (All Nodes)
```bash
sudo vi /etc/sysctl.d/k8s.conf
# Add:
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1

sudo sysctl --system
```
### [Step 6] Install Docker (All Nodes)
```bash
sudo yum install docker -y
sudo systemctl enable --now docker
```
###  [Step 7] Add Kubernetes Repo (All Nodes)
```bash
sudo vi /etc/yum.repos.d/k8s.repo
# Add:
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl
```
### [Step 8] Install Kubernetes Components (All Nodes)
```bash
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
```
### [Step 9] Initialize Cluster (Master Node)
```bash
sudo kubeadm init
```
Copy and note the kubeadm join command
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
### [Step 10] Apply CNI (Weave) - Master Node
```bash
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```
### [Step 11] Join Worker Nodes
Run the kubeadm join command on wn1 and wn2.

| If lost:
```bash
sudo kubeadm token create --print-join-command
```


### [Step 12] Verify Cluster - Master Node
```bash
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get ns
kubectl api-resources | less

```




