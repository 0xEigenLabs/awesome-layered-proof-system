include "./leaf_existence.circom";
include "./get_merkle_root.circom";

include "../../circomlib/circuits/mimc.circom";
include "../../circomlib/circuits/eddsamimc.circom";

template Deposit(n, k) {
    signal input accounts_root;

    signal input accounts_pubkeys[2**k][2];
    signal input deposit[k];
    //TODO token_type

    signal input sender_pubkey[2];
    signal input sender_balance;
    signal input amount;
    signal input signature_R8x;
    signal input signature_R8y;
    signal input signature_S;

    signal input sender_proof_pos[k];
    signal input sender_proof[i];

    signal output new_accounts_root;

    component senderExistence = LeafExistence(k, 3);
    senderExistence.preimage[0] <== sender_pubkey[0];
    senderExistence.preimage[1] <== sender_pubkey[1];
    senderExistence.preimage[2] <== sender_balance;

    senderExistence.root <== accounts_root;

    for (var i = 0; i < k; i ++) {
        senderExistence.path2_root_pos[i] <== sender_proof_pos[i];
        senderExistence.path2_root[i] <== sender_proof[i];
    }

    component signatureCheck = EdDSAMiMCVerifier();
    signatureCheck.Ax <== sender_pubkey[0];
    signatureCheck.Ay <== sender_pubkey[1];
    signatureCheck.R8x <== signatureCheck.R8x;
    signatureCheck.R8y <== signatureCheck.R8y;
    signatureCheck.S <== signature_S;

    component hash = MultiMiMC7(3, 91);
    hash.in[0] <== sender_pubkey[0];
    hash.in[1] <== sender_pubkey[1];
    hash.in[2] <== sender_balance;
    signatureCheck.M <== hash.out;

    sender_balance + amount >= sender_balance;
    component newSenderLeaf = MultiMiMC7(3,91){
        newSenderLeaf.in[0] <== sender_pubkey[0];
        newSenderLeaf.in[1] <== sender_pubkey[1];
        newSenderLeaf.in[2] <== sender_balance + amount;
    }

    component computed_intermediate_root = GetMerkleRoot(k);
    computed_intermediate_root.leaf <== newSenderLeaf.out;
    for (var i = 0; i < k; i ++) {
        computed_intermediate_root.paths2_root_pos[i] <== sender_proof_pos[i];
        computed_intermediate_root.path2_root[i] <= sender_proof[i];
    }
    new_accounts_root <= computed_intermediate_root.out
}

component main {
    public {
        accounts_root,
        accounts_pubkeys
    }
} = Deposit(1)
