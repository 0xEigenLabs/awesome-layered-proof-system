include "./leaf_existence.circom";
include "./get_merkle_root.circom";
include "./verify_eddsa.circom";

include "../../circomlib/circuits/mimc.circom";
include "../../circomlib/verify_eddsamimc.circom";

// create template
template ProcessTx(k){
  // STEP 0: Initialise signals
  signal input accounts_root;
  signal private input intermediate_root;
  signal private input accounts_pubkeys[2**k, 2];
  signal private input accounts_balances[2**k];

  // transactions input
  signal private input sender_pubkey[2];
  signal private input sender_balance;
  signal private input receiver_pubkey[2];
  signal private input receiver_balance;
  signal private input amount;
  signal private input signature_R8x;
  signal private input signature_R8y;
  signal private input signature_S;
  signal private input sender_proof[k];
  signal private input sender_proof_pos[k];
  signal private input receiver_proof[k];
  signal private input receiver_proof_pos[k];

  // final account tree root as output
  signal output new_accounts_root;

  // STEP 1: Check sender's account existence
  componet senderExistence = LeafExistence(k, 3);
  senderExistence.preimage[0] <== sender_pubkey[0];
  senderExistence.preimage[1] <== sender_pubkey[1];
  senderExistence.preimage[2] <== sender_balance;

  senderExistence.root <== accounts_root;
  for (var i = 0; i < k; i ++) {
    senderExistence.paths2_root_pos[i] <== sender_proof_pos[i];
    senderExistence.paths2_root[i] <== sender_proof[i];
  }

  // STEP 2: Check sender's account signature
  component signatureCheck = VerifyEdDSAMiMC(5);

  signatureCheck.Ax <== sender_pubkey[0];
  signatureCheck.Ay <== sender_pubkey[1];

  signatureCheck.R8x <== signature_R8x;
  signatureCheck.R8y <== signature_R8y;
  signatureCheck.S <== signature_S;

  signatureCheck.preimage[0] <== sender_pubkey[0];
  signatureCheck.preimage[1] <== sender_pubkey[1];
  signatureCheck.preimage[2] <== receiver_pubkey[0];
  signatureCheck.preimage[3] <== receiver_pubkey[1];
  signatureCheck.preimage[4] <== amount;

  // STEP 3: Debit sender's account and create updated leaf

  // STEP 4: Update accounts tree root with changes to sender's balance ie Debit sender's account
  // Let's call this new root "intermediate root"

  // STEP 5: Verify if receiver's account exists in intermediate root

  // STEP 6: Credit receiver's account

  // STEP 7: Update account's root with updates to receiver's account

  // STEP 8: Output final root
}

// create main so that we can call it directly
component main = ProcessTx(1);
