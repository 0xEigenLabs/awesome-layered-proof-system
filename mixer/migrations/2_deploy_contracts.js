const Mixer = artifacts.require("Mixer");

module.exports = async function(deployer, network, accounts) {
    //if (network === "development") return;  // Don't deploy on tests

    // MiniMeTokenFactory send
    console.log("begin to deploy");
    let MixerFuture = Mixer.new("0xCd27B526f12BfEb656A899C580E8e5f8398e3fFe");

    // MiniMeTokenFactory wait
    let mixer = await MixerFuture;
    console.info("mixer: " + mixer.address);
    console.info();
};
