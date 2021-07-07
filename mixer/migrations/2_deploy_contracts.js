const Mixer = artifacts.require("Mixer");

module.exports = async function(deployer, network, accounts) {
    //if (network === "development") return;  // Don't deploy on tests

    // MiniMeTokenFactory send
    console.log("begin to deploy");
    let MixerFuture = Mixer.new("0x4F5FD0eA6724DfBf825714c2742A37E0c0d6D7d9");

    // MiniMeTokenFactory wait
    let mixer = await MixerFuture;
    console.info("mixer: " + mixer.address);
    console.info();
};
