# if token is in TTL 
export KUBECONFIG=/etc/kubernetes/admin.conf

kubeadm join api.medici.loan:6443 --token xx.xxx \
	--discovery-token-ca-cert-hash sha256:xxx

# otherwise 
kubeadm token list
kubeadm token create