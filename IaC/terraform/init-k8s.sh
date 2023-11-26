cd ~
sudo apt-get update && sudo apt-get install -y containerd apt-transport-https ca-certificates curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo tee /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubeadm=1.22.8-00 kubelet=1.22.8-00 kubectl=1.22.8-00
sudo mkdir -p /etc/containerd
sudo containerd config default > tee /etc/containerd/config.toml
sudo systemctl restart containerd

echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.d/99-kubernetes-ipv4-forward.conf
sudo modprobe br_netfilter
echo "br_netfilter" | sudo tee /etc/modules-load.d/modules.conf
sudo sysctl --system
sudo kubeadm init --ignore-preflight-errors=NumCPU,Mem

until kubectl -n kube-system get pods -l component=kube-apiserver | grep -w "Running"; do
    echo "Waiting for kube-apiserver to be in Running state..."
    sleep 10
done

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chmod 777 $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml