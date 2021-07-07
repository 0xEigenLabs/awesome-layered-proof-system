###  Requirement

- circom
	- 0.5.45
- python
	- 3.6.12
- nodejs
	- v12.0.0
- solidity
	- v0.5.16
- truffle
    - v5.3.14

hasher：mimc7

### Steps

- compose circuits
	- mixer.circom
	- get_merkle_root.circom

- compose contracts
	- mixer
	- Merkle

### Circuits


#### generate public input，Private input

```
$ yarn generate
```

#### Compile

```
$ cd circuit;  ./run.sh mixer
```

#### Test

```
$ yarn call_mimic ${mixer address}
$ yarn call_mimc ${mixer address}
$ yarn deploy_mimc
```

### Reference
1. https://keen-noyce-c29dfa.netlify.com/#2
2. https://blog.iden3.io/first-zk-proof.html
