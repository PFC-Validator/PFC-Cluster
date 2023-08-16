# based on 
# https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/
export DEBIAN_FRONTEND=noninteractive 
apt update 
apt upgrade -y

hostnamectl set-hostname "w-her-fsn-01.xXX.xxx"     

ssh-import-id-gh  pfc-developer
echo 'export EDITOR=vi' >> /etc/bash.bashrc
export EDITOR=vi
echo Domains=medici.loan >> /etc/systemd/resolved.conf 
systemctl restart systemd-resolved

adduser user  --disabled-password --gecos ""
usermod -aG sudo  user
usermod -aG adm  user
mkdir -m=700 /home/user/.ssh 
cp /root/.ssh/authorized_keys /home/user/.ssh
chown -R user:user /home/user/.ssh

tee /etc/sudoers.d/sudo-user-conf <<EOF
# user is admin
user ALL=(ALL:ALL) NOPASSWD:ALL
EOF

tee /etc/ssh/sshd_config.d/sshd-config.conf <<EOF
PermitRootLogin no
PasswordAuthentication no
EOF

systemctl  restart sshd

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF


modprobe overlay
modprobe br_netfilter
tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt update
sudo apt install -y containerd.io

# Configure containerd so that it starts using systemd as cgroup.

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# kubernetes repo
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
sudo apt-add-repository -y "deb http://apt.kubernetes.io/ kubernetes-xenial main"

# Install Kubectl, Kubeadm and Kubelet
apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

export KUBECONFIG=/etc/kubernetes/admin.conf
