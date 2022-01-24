const cjs = require("circomlibjs");
const fs = require('fs');
const ffj = require("ffjavascript");
const Scalar = ffj.Scalar;

const toHexString = bytes =>
  '0x' + bytes.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');

const fromHexString = hexString =>
  new Uint8Array(hexString.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));


async function main() {

  eddsa = await cjs.buildEddsa();
  const prvKey = fromHexString("0001020304050607080900010203040506070809000102030405060708090002");

  const pubKey = eddsa.prv2pub(prvKey);

  const prvKey2 = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");
  const pubKey2 = eddsa.prv2pub(prvKey2);

  const msgBuf = fromHexString("000102030405060708090000");

  const msg = eddsa.babyJub.F.e(Scalar.fromRprLE(msgBuf, 0));

  const signature = eddsa.signMiMC(prvKey, msg);

  const inputs = {
    Ax: toHexString(pubKey[0]),
    Ay: toHexString(pubKey[1]),
    R8x: toHexString(signature.R8[0]),
    R8y: toHexString(signature.R8[1]),
    S: signature.S.toString(),
    M: toHexString(msg)

    //preimage: [
    //  toHexString(pubKey[0]),
    //  toHexString(pubKey[1]),
    //  toHexString(pubKey[0]),
    //  toHexString(pubKey[1]),
    //  toHexString(msg)
    //]
  }

  fs.writeFileSync('./input.json', JSON.stringify(inputs) , 'utf-8');
}

main().then(() => {
  console.log("Done")
})
