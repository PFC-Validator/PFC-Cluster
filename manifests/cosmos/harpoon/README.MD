# gen signer keys
horcrux create-ecies-shards --shards 3

base64 < cosigner_0/ecies_keys.json
base64 < cosigner_1/ecies_keys.json
base64 < cosigner_2/ecies_keys.json

these go into the signers.yaml. 
via sops!

# gen priv-key
kujirad init test-1 --chain-id harpoon-4 -o

# gen priv-key shards
horcrux create-ed25519-shards --chain-id  harpoon-4 --key-file ./priv_validator_key.json --threshold 2 --shards 3

base64 < cosigner_0/harpoon-4_shard.json
base64 < cosigner_1/harpoon-4_shard.json
base64 < cosigner_2/harpoon-4_shard.json 

# **Remember**
sops -e -i shards.yaml
sops -e -i signers.yaml