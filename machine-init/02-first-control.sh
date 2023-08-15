

sudo -i 
export KUBECONFIG=/etc/kubernetes/admin.conf
kubeadm config images pull
kubeadm init --control-plane-endpoint=api.medici.loan
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# from desktop
# all minus apiserver* & etcd/healthcheck & etcd/peer* etcd/server*
scp -r /etc/kubernets/admin.conf kube-config
scp -r /etc/kubernets/pki .

