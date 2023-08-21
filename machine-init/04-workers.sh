# if token is in TTL 
export KUBECONFIG=/etc/kubernetes/admin.conf

kubeadm join api.xxx.xxx:6443 --token xx.xxx \
	--discovery-token-ca-cert-hash sha256:xxx

# otherwise (from controller?)
#kubeadm token list
#kubeadm token create
kubeadm token create --print-join-command
