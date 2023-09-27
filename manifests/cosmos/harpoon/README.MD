# horcrux stuff
## gen signer keys
horcrux create-ecies-shards --shards 3

these go into the signers.yaml. 
via sops!

## gen priv-key
kujirad init test-1 --chain-id harpoon-4 -o

## gen priv-key shards
horcrux create-ed25519-shards --chain-id  harpoon-4 --key-file ./priv_validator_key.json --threshold 2 --shards 3


## **Remember**
sops -e -i shards.yaml
sops -e -i signers.yaml


# feeder
steps:
* create a new wallet somewhere. this will be used to submit price information.
** DO NOT USE YOUR VALIDATOR SEED **
* transfer some dust over to it
```
kujirad tx bank send kuji..from...wallet kujira1..new_feeder_key... 1000000ukuji --from foo --fees 250ukuji
```
* add the seed, validator address (kujivaloper..)  and the wallet in [price-feeder-secrets.yaml](./price-feeder-secrets.yaml)
* adjust [price-feeder.yaml](price-feeder.yaml) to your favorite price config (or just use the default) [default harpoon config](/external-docker/kujira-price-feeder/harpoon.toml)

* set your validator to allow the feeder address to submit prices on your behalf
```
kujirad tx  oracle set-feeder kujira1..new_feeder_key... --from harpoon-validator --fees 250ukuji
```

* deploy.. and cross your fingers.