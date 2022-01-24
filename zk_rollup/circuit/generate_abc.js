const cjs = require("circomlibjs");
const fs = require('fs');
const ffj = require("ffjavascript");
const Scalar = ffj.Scalar;

const toHexString = bytes =>
  '0x' + bytes.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');

const fromHexString = hexString =>
  new Uint8Array(hexString.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));


async function main() {

  const inputs = {
    "a": 10,
    "b": 101
  }

  fs.writeFileSync('./input.json', JSON.stringify(inputs) , 'utf-8');
}

main().then(() => {
  console.log("Done")
})
