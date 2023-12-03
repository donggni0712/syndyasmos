# key 사용. 권한 설정
mkdir -p $HOME/.kube

sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config -f

sudo chmod 777 $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

# CNI 설치 및 적용 (calico 사용)
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml