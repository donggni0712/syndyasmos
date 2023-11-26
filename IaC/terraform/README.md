# Terraform for setting up k8s on an EC2 environment

## ec2 접속 후 확인사항

### kubeadm 떠있는 지

```
cat ~/.kube/config
```

### kubelet log

```
sudo journalctl -u kubelet
```

### containerd 설치

```
wget https://github.com/containerd/containerd/releases/download/v1.5.5/containerd-1.5.5-linux-amd64.tar.gz
tar -xvf containerd-1.5.5-linux-amd64.tar.gz
sudo cp -r bin/* /usr/bin/
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
```

# 수동 설치

```
sudo apt-get update && sudo apt-get install -y containerd apt-transport-https ca-certificates curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo tee /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubeadm=1.22.8-00 kubelet=1.22.8-00 kubectl=1.22.8-00
sudo mkdir -p /etc/containerd
sudo containerd config default > /etc/containerd/config.toml
sudo systemctl restart containerd

echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.d/99-kubernetes-ipv4-forward.conf
sudo modprobe br_netfilter
echo "br_netfilter" | sudo tee /etc/modules-load.d/modules.conf
sudo sysctl --system
sudo kubeadm init --ignore-preflight-errors=NumCPU,Mem

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config -f
sudo chmod 777 $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

```
