pragma circom 2.0.0;
include "../../circomlib/circuits/eddsamimc.circom";

component main {public [Ax, Ay, R8x, R8y, S, M]} = EdDSAMiMCVerifier();
