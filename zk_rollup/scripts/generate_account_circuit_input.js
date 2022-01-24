const eddsa = require("../../circomlib/src/eddsa.js");
const fs = require('fs');
const utils = require("ffjavascript").utils;

const msg = BigInt(9990);

const prvKey = Buffer.from("0000000000000000000000000000000000000000000000000000000000000001", "hex");
const pubKey = eddsa.prv2pub(prvKey);

const prvKey2 = Buffer.from("0000000000000000000000000000000000000000000000000000000000000002", "hex");
const pubKey2 = eddsa.prv2pub(prvKey2);

const signature = eddsa.signMiMC(prvKey, msg);

const inputs = {
            Ax: pubKey[0].toString(),
            Ay: pubKey[1].toString(),
            R8x: signature.R8[0].toString(),
            R8y: signature.R8[1].toString(),
            S: signature.S.toString(),
            preimage: [
              pubKey[0].toString(),
              pubKey[1].toString(),
              pubKey2[0].toString(),
              pubKey2[1].toString(),
              msg.toString()
            ]
}

fs.writeFileSync('./input.json', JSON.stringify(inputs) , 'utf-8');
