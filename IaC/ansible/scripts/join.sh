#!/bin/bash

# 필수 의존성 설치
sudo apt-get update && sudo apt-get install -y containerd apt-transport-https ca-certificates curl

# gpg 키 다운로드 및 저장
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Kubernetes apt repository 추가
sudo tee /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# 패키지 정보 업데이트 및 k8s 설치
sudo apt-get update
sudo apt-get install -y kubeadm=1.27.6-00 kubelet=1.27.6-00

# containerd 설정 및 재시작
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# 네트워크 설정
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.d/99-kubernetes-ipv4-forward.conf
sudo modprobe br_netfilter
echo "br_netfilter" | sudo tee /etc/modules-load.d/modules.conf

# 설정 적용
sudo sysctl --system

# kubeadm join 명령어 (이 부분은 실제 값을 사용해야 함)
# sudo kubeadm join <master-ip>:6443 --token <token> \
#    --discovery-token-ca-cert-hash sha256:<hash>
