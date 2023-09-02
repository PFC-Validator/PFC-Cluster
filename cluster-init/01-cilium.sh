## brew install cilium-cli
source env.sh
helm repo add cilium https://helm.cilium.io/

#helm install                                         \
#    cilium                                                      \
#    cilium/cilium                                               \
#    --version 1.14.0                                            \
#    --namespace kube-system                                     \
#    --set ipam.mode=kubernetes                                  \
#    --set hostFirewall.enabled=true                             \
#    --set hubble.relay.enabled=true                             \
#    --set hubble.ui.enabled=true                                \
#    --set hubble.peerService.clusterDomain=${CLUSTER_DOMAIN}    \
#    --set etcd.clusterDomain=${CLUSTER_DOMAIN}                  \
#    --set kubeProxyReplacement=strict                           \
#    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
#    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
#    --set cgroup.autoMount.enabled=false                        \
#    --set cgroup.hostRoot=/sys/fs/cgroup                        \
#    --set k8sServiceHost="${KUBERNETES_API_SERVER_ADDRESS}"     \
#    --set k8sServicePort="${KUBERNETES_API_SERVER_PORT}"


cilium install  --set hubble.relay.enabled=true \
       --set hubble.ui.enabled=true     \
       --set hostFirewall.enabled=true \
       --set hubble.metrics.enabled="{dns,drop,tcp,flow,icmp,http}"  


cilium status --wait
#cilium connectivity test
#cilium hubble enable
cilium hubble enable --ui
exit
#kubectl apply -f ./cilium-control-plane.yaml

#kubectl exec -n kube-system  cilium-796pc