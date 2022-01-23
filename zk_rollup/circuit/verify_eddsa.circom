include "../../circomlib/circuits/eddsamimc.circom";
include "../../circomlib/circuits/mimc.circom";

template VerifyEdDSAMiMC() {
    signal input Ax;
    signal input Ay;
    signal input R8x;
    signal input R8y;
    signal input S;
    signal input M;
    signal input enabled;

    component verifier = EdDSAMiMCVerifier();
    verifier.enabled <== enabled;
    verifier.Ax <== Ax;
    verifier.Ay <== Ay;
    verifier.R8x <== R8x;
    verifier.R8y <== R8y;
    verifier.S <== S;
    verifier.M <== M;
}


component main = VerifyEdDSAMiMC();
