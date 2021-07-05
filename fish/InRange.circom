include "../circomlib/circuits/comparators.circom"
include "../circomlib/circuits/bitify.circom"


template InAuthorizedRange() {
    signal input latitudeRange[2]; // latitiude range
    signal input longitudeRange[2]; // longitide range

    signal private input fishingLocation[2];
    signal output out;

    // Max num bits would be 9, 2^9 = 512, which is greater than the max longitude range, 360
    component gt1 = GreaterEqThan(9);
    gt1.in[0] <== fishingLocation[0];
    gt1.in[1] <== latitudeRange[0];
    gt1.out === 1;

    component lt1 = LessEqThan(9);
    lt1.in[0] <== fishingLocation[0];
    lt1.in[1] <== latitudeRange[1];
    lt1.out === 1;


    // The fishing longitude has to be greater than or equal to
    // the min longitude of the authorized area
    component gt2 = GreaterEqThan(9);
    gt2.in[0] <== fishingLocation[1];
    gt2.in[1] <== longitudeRange[0];
    gt2.out === 1;

    // The fishing longitude has to be less than or equal to
    // the max longitude of the authorized area
    component lt2 = LessEqThan(9);
    lt2.in[0] <== fishingLocation[1];
    lt2.in[1] <== longitudeRange[1];
    lt2.out === 1;

    out <-- (gt1.out + gt2.out + lt1.out + lt2.out) * 1/4;
    out === 1;
}

component main = InAuthorizedRange();
