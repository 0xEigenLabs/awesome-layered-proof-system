const { waffle, ethers } = require("hardhat");
const chai = require("chai");
const cls = require("circomlibjs");

const assert = chai.assert;
const provider = waffle.provider

const SEED = "mimc";

describe("MiMC Smart contract test", function () {
  let mimc;
  let mimcjs;
  let account
  let mimcGenContract

  this.timeout(100000);

  before(async () => {
    account = await ethers.getSigner();
    mimcjs = await cls.buildMimc7()
    mimcGenContract = cls.mimc7Contract;
  });

  it("Should deploy the contract", async () => {
    const C = new ethers.ContractFactory(
            mimcGenContract.abi,
            mimcGenContract.createCode(SEED, 91),
            account
          );

    mimc = await C.deploy();

    console.log("mimc address: ", await mimc.address)
  });

  it("Shold calculate the mimic correctly", async () => {
    //TODO edit leaf and depth
    const res = await mimc["MiMCpe7"](1,1);
    const res2 = await mimcjs.hash(1,1,91);
    console.info(res.toString())
    assert.equal(res.toString(), mimcjs.F.toString(res2));
  });
});

