# PFC-Cluster

this is my 'working' (more like work in progress) kubernets cluster

* [ansible](./ansible) for machine installs
* [cluster-init](./cluster-init) for cluster install

this relies heavily on 
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