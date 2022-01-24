include "../../circomlib/circuits/eddsamimc.circom";
include "../../circomlib/circuits/mimc.circom";

template VerifyEdDSAMiMC(k) {
    signal input Ax;
    signal input Ay;
    signal input R8x;
    signal input R8y;
    signal input S;

    signal private input preimage[k];

    component M = MultiMiMC7(k,91);
    M.in[0] <== preimage[0];
    M.in[1] <== preimage[1];
    M.in[2] <== preimage[2];
    M.in[3] <== preimage[3];
    M.in[4] <== preimage[4];


    component verifier = EdDSAMiMCVerifier();
    verifier.enabled <== 1;
    verifier.Ax <== Ax;
    verifier.Ay <== Ay;
    verifier.R8x <== R8x;
    verifier.R8y <== R8y;
    verifier.S <== S;
    verifier.M <== M.out;
}


component main = VerifyEdDSAMiMC(5);
