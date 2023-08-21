
scp -r pki/..list of files it needs /etc/kubernets/pki 

# from initial init page (if it hasn't timed out )

export KUBECONFIG=/etc/kubernetes/admin.conf

kubeadm join api.xxx.xxx:6443 --token XXXX \
	--discovery-token-ca-cert-hash sha256:xxxx \
	--control-plane

otherwise
kubeadm token list
kubeadm token create
sudo kubeadm init phase upload-certs --upload-certs
