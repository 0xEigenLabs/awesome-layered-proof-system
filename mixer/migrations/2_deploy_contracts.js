const Mixer = artifacts.require("Mixer");

module.exports = async function(deployer, network, accounts) {
    //if (network === "development") return;  // Don't deploy on tests

    // MiniMeTokenFactory send
    console.log("begin to deploy");
    let MixerFuture = Mixer.new("0x32f45Cd9f2878bB6b408Dcfbd5623eAb1389156E");

    // MiniMeTokenFactory wait
    let mixer = await MixerFuture;
    console.info("mixer: " + mixer.address);
    console.info();
};
