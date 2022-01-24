const fs = require('fs');
const utils = require("ffjavascript").utils;
const {randomBytes} = require("crypto");
const BigNumber = require("bignumber.js");

const toHexString = bytes =>
  "0x" + bytes.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');

const toDecimalString = b => BigInt(toHexString(b)).toString(10)

const fromHexString = hexString =>
  new Uint8Array(hexString.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));

const cls = require("circomlibjs");
function Bits2Num(n, in1) {
    var lc1=0;

    var e2 = 1;
    for (var i = 0; i < n; i++) {
        lc1 += Number(in1[i]) * e2;
        e2 = e2 + e2;
    }
    return lc1
}

async function main() {
  let mimcjs = await cls.buildMimc7();
  // calculate cmt nullifierHash
  const path2_root_pos = [1, 1, 1, 1, 1, 0, 1, 1]
  const secret = 10;
  const LEAF_NUM = 8;
  //console.log(path2_root_pos.join(""))
  // 255 = 11111111b
  //const cmt_index = parseInt(path2_root_pos.reverse().join(""), 2)
  const cmt_index = Bits2Num(LEAF_NUM, path2_root_pos)
  //console.log("cmt index", cmt_index)
  const nullifierHash = mimcjs.hash(cmt_index, secret)
  //console.log("nullifierHash", nullifierHash)

  let cmt = mimcjs.hash(nullifierHash, secret)

  function generate_salt(num, length = 512) {
    let ret = []
    for (var i = 0; i < num; i ++) {
      const buf = randomBytes(length/8).toString('hex');
      ret.push(new BigNumber(buf, 16).toString(10))
    }
    return ret
  }

  // generates salt to encrypt each leaf
  let nums = generate_salt(8, 154)

  // get merkle root
  let root = mimcjs.hash(secret, 0);
  console.log("1111", mimcjs.F.toString(root))

  for (var i = 0; i < Number(LEAF_NUM); i++) {
    //console.log(root)
    if (path2_root_pos[i] === 1) {
      root = mimcjs.hash(root, nums[i])
    } else {
      root = mimcjs.hash(nums[i], root)
    }
  }

  const inputs = {
    "root": mimcjs.F.toString(root),
    "nullifierHash": mimcjs.F.toString(nullifierHash),
    "secret": secret,
    "paths2_root": nums,
    "paths2_root_pos": path2_root_pos
  }

  console.info(inputs)

  fs.writeFileSync(
    "./input.json",
    JSON.stringify(inputs),
    "utf-8"
  );
}

main().then(() => {
  console.log("Done")
})
