# Kujira Price feeder
This work is based on [Defiant Labs](https://github.com/DefiantLabs/oracle-price-feeder)'s Docker container. 
The config file was based [Polkachu's price feeds](https://github.com/polkachu/cosmos-validators/blob/main/roles/support_price_feeder/templates/sei/mainnet.toml.j2), and the one we used on our validators.

The aim of this is to provide a 'running' container that you can just pass in environment variables and it will work.

The major thing to be aware of is that this container can either use a file (mounted in /config) or a https url to download the config. see [price-feed.sh](./price-feed.sh) for variables it substitutes.  A (working) example of the config file for [kaiyo](./kaiyo.toml) and  [harpoon](./harpoon.toml) networks are available. These URLs are designed to work with the latest version of the docker container.

## warning
when new oracle versions (for example 0.7.1) of the docker container get released, will will create a tagged version of this repo with the older version. 
we will also be modifying the toml file as needed to add new features/fix bugs. If you would prefer a stable version, please host the version you prefer somewhere.


## warning x2
we pass in a SEED as an environment variable. This seed should *not* be your validator wallet. It should be a wallet with a tiny bit of dust in it.. do not put your validator seed phrases anyone on the cloud.