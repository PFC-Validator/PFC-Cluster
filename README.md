# PFC-Cluster

this is my 'working' (more like work in progress) kubernets cluster

## for setting it up
* [ansible](./ansible) for machine installs
* [cluster-init](./cluster-init) for cluster install

## for running things
* [flux](./clusters/main-cluster/flux-system) - controls what is running 
* [kube infra](./manifests/infrastructure)
* [cosmos nodes](./manifests/cosmos/) - running RPC and validators

please note. we put our validator key shards in the 'secret' area, as we run the horcrux signers in the cluster itself. 

I mention this as if this screws up you could tombstone, or some hacker could come in and steal them, and we are still improving the overall security footprint of this install. buyer beware, no warranties, your risk etc etc.

### still to do
* price oracles
* relaying
* making horcrux more automated
* more testing

# thank you too
this relies heavily on:
- [Strangelove](https://twitter.com/strangelovelabs)'s [cosmos-operator](https://github.com/strangelove-ventures/cosmos-operator/), [horcrux](https://github.com/strangelove-ventures/horcrux/), and [heighlinger](https://github.com/strangelove-ventures/heighliner/)
- [Polkachu](https://twitter.com/polka_chu)'s [ansible](https://github.com/polkachu/cosmos-validators/) setup and snapshots/backups they provide


# revision history
3. ansible machine installs - current

2. working ok, manual manual machine installs:
    - didn't survive 40% machine failure at once
    - exposed kubeconfig

1. mainly manual - result bricked by cilium


# feel free to use
I don't claim to be an expert in any of this. I put this out in the hopes that others will use it, and ideally improve on it. 