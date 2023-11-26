resource "aws_instance" "master-node" {
  ami           = "ami-0c9c942bd7bf113a2"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.k8s_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name      = "my-k8s-test"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "MasterNode"
  }

  provisioner "file" {
    source      = "./init-k8s.sh"
    destination = "/tmp/setup"
  }

  # Change permissions on bash script and execute from ec2-user.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup",
      "sudo /tmp/setup",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"  # AMI에 따라 변경될 수 있습니다. (예: "ubuntu" 등)
    private_key = file("./my-k8s-test.pem")  # 사용한 키 페어의 비공개 키 파일 경로
    host        = self.public_ip  # EC2 인스턴스의 공개 IP 주소를 사용
}
}

# resource "aws_instance" "worker-node" {
#   count         = 2
#   ami           = "ami-0c9c942bd7bf113a2"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.k8s_subnet.id
#   vpc_security_group_ids = [aws_security_group.k8s_sg.id]
#   key_name      = "my-k8s-test"
#   availability_zone = "ap-northeast-2a"

#   user_data = <<-EOT
#               #!/bin/bash
              # sudo apt-get update && sudo apt-get install -y containerd apt-transport-https ca-certificates curl
              # curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
              # sudo tee /etc/apt/sources.list.d/kubernetes.list <<EOF
              # deb https://apt.kubernetes.io/ kubernetes-xenial main
              # EOF
              # sudo apt-get update
              # sudo apt-get install -y kubeadm=1.22.8-00 kubelet=1.22.8-00 kubectl=1.22.8-00
              # sudo mkdir -p /etc/containerd
              # sudo containerd config default > /etc/containerd/config.toml
              # sudo systemctl restart containerd

              # echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.d/99-kubernetes-ipv4-forward.conf
              # sudo modprobe br_netfilter
              # echo "br_netfilter" | sudo tee /etc/modules-load.d/modules.conf
              # sudo sysctl --system

              # # NOTE: 아래의 join 명령은 실제 join 명령으로 대체되어야 합니다.
              # # master 노드에서 'kubeadm token create --print-join-command' 명령을 실행하여
              # # 얻은 값을 이곳에 붙여 넣어야 합니다.
              # sudo kubeadm join [master-ip]:6443 --token YOUR-TOKEN --discovery-token-ca-cert-hash YOUR-HASH

#               EOT

#   tags = {
#     Name = "WorkerNode-${count.index + 1}"
#   }
# }