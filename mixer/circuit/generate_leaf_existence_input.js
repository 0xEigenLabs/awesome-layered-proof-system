'use strict';
const fs = require("fs");
const mimcjs = require("../../circomlib/src/mimc7.js");

const nullifierHash = mimcjs.hash(255,0)

// root，paths2_root，paths2_root_pos could be stored on blockchain
// private: nullifierHash, leaf_index, secret

let secret = "0";
let rawdata = fs.readFileSync('/tmp/.primes.json');
let primes = JSON.parse(rawdata)

let root = mimcjs.hash(primes[0], secret);

for (var i = 0; i < 7; i++) {
    root = mimcjs.hash(root, primes[i])
}

const inputs = {
    "root":root.toString(),
    "nullifierHash":nullifierHash.toString(),

    "secret": secret,
    "paths2_root": [secret].concat(primes),
    "paths2_root_pos":[
    	1,
    	1,
    	1,
    	1,
    	1,
    	1,
    	1,
    	1
    ]
}

console.info(inputs)

fs.writeFileSync(
    "./input.json",
    JSON.stringify(inputs),
    "utf-8"
);

fs.writeFileSync(
    "./public.json",
    JSON.stringify([root.toString(), nullifierHash.toString()]),
    "utf-8"
);
