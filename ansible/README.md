# pfc-ansible

# install ansible
python3 -m pip install ansible

# layout

as certain providers provider machines in different states, we first do very basic things to get the machine into same state

## machine_init

creates 'user' user on all machines, and hosting provider specific setup. 

machines are configured with swap **OFF**, (and for kube workers 100G allocated)

For ALL machines it will run sgdisk to create a partion for rook/ceph to use (if your not using k8s, then it should be a no-op)

inventory file should be specified as

hetzner, ovh, leaseweb

once it passes 'machine_init' there may still be remnants of old install. TBD to clean them up

## kubernetes

utilizes a different format for the inventory  ./machines/machine_post.yaml.sample
we have aimed to set this up to be run once (and will skip destructive parts when re-run on a machine)

these scripts should install:
- a single 'master' first, 
- then add other machines into the control plane
- add workers

**note** the aim for this is for kubernetes to be installed once, and not have the machines rebooted constantly when new ones are added


### end state
ideally kubernetes machines should be available via kubectl in a 'Ready' state (once cluster is initialized). For new clusters, see ../cluster-init.

files in the './files' directory should not be exposed.

### next steps

The ./files/kubeconfig.yaml is like your root password to your cluster. don't share it. it is recommended to create regular users instead of just using this file everywhere. but if you're playing, just copy/merge it over to $HOME/.kube/config on your local machine.



# TBD
some clusters still require their own dedicated machines
scripts to install custom machines ideally they should be similar in setup to ./kubernetes.yaml, where machines do post install, and sit in their own 'host' config 
