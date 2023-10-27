# Pisco validator

most of the pods are self-describing (i'm too lazy to explain them)

## Generate horcrux cluster
This uses a custom [horcrux docker container](https://github.com/PFC-Validator/horcrux-container) which creates the config for you based on your configuration.

You will also need to create a few secrets.
the first is based on the private key of the validator. You can use an existing one. just be careful not to the old service at the same time. (tombstombing isn't good)

### generate signer keys
```
horcrux create-ecies-shards --shards 3
```

these go into the signers.yaml. 
via sops!

### generate the  private key (optional)
here is an example
```
terrad init test-1 --chain-id pisco-1 -o
```

### generate the private key shards
```
horcrux create-ed25519-shards --chain-id  pisco-1 --key-file ./priv_validator_key.json --threshold 2 --shards 3
```
now copy these into the shards.yaml.


# **Remember**

sops -e -i shards.yaml
sops -e -i signers.yaml

