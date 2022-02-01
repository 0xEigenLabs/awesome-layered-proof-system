include "./leaf_existence.circom";
include "./get_merkle_root.circom";

include "../../circomlib/circuits/mimc.circom";
include "../../circomlib/circuits/eddsamimc.circom";

// create template
template ProcessTx(k){
  // STEP 0: Initialise signals
  signal input accounts_root;
  signal input intermediate_root;
  signal input accounts_pubkeys[2**k][2];
  signal input accounts_balances[2**k];

  // transactions input
  signal input sender_pubkey[2];
  signal input sender_balance;
  signal input receiver_pubkey[2];
  signal input receiver_balance;
  signal input amount;
  signal input signature_R8x;
  signal input signature_R8y;
  signal input signature_S;
  signal input sender_proof[k];
  signal input sender_proof_pos[k];
  signal input receiver_proof[k];
  signal input receiver_proof_pos[k];

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
  component signatureCheck = EdDSAMiMCVerifier();

  signatureCheck.Ax <== sender_pubkey[0];
  signatureCheck.Ay <== sender_pubkey[1];

  signatureCheck.R8x <== signature_R8x;
  signatureCheck.R8y <== signature_R8y;
  signatureCheck.S <== signature_S;

  component hash = MultiMiMC7(5, 91);
  hash.in[0] <== sender_pubkey[0];
  hash.in[1] <== sender_pubkey[1];
  hash.in[2] <== receiver_pubkey[0];
  hash.in[3] <== receiver_pubkey[1];
  hash.in[4] <== amount;
  signatureCheck.M <== hash.out;

  sender_balance - amount <= sender_balance;
  receiver_balance + amount >= receiver_balance;

  // STEP 3: Debit sender's account and create updated leaf
  component newSenderLeaf = MultiMiMC7(3,91){
      newSenderLeaf.in[0] <== sender_pubkey[0];
      newSenderLeaf.in[1] <== sender_pubkey[1];
      newSenderLeaf.in[2] <== sender_balance - amount;
  }

  // STEP 4: Update accounts tree root with changes to sender's balance ie Debit sender's account
  // Let's call this new root "intermediate root"
  component computed_intermediate_root = GetMerkleRoot(k);

  computed_intermediate_root.leaf <== newSenderLeaf.out;

  for (var i = 0; i < k; i++){
      computed_intermediate_root.paths2_root_pos[i] <== sender_proof_pos[i];
      computed_intermediate_root.paths2_root[i] <== sender_proof[i];
  }

  // check that computed_intermediate_root.out === intermediate_root
  computed_intermediate_root.out === intermediate_root;

  // STEP 5: Verify if receiver's account exists in intermediate root
  component receiverExistence = LeafExistence(k, 3);
  receiverExistence.preimage[0] <== receiver_pubkey[0];
  receiverExistence.preimage[1] <== receiver_pubkey[1];
  receiverExistence.preimage[2] <== receiver_balance;
  receiverExistence.root <== intermediate_root;
  for (var i = 0; i < k; i++){
      receiverExistence.paths2_root_pos[i] <== receiver_proof_pos[i];
      receiverExistence.paths2_root[i] <== receiver_proof[i];
  }

  // STEP 6: Credit receiver's account
  component newReceiverLeaf = MultiMiMC7(3,91){
      newReceiverLeaf.in[0] <== receiver_pubkey[0];
      newReceiverLeaf.in[1] <== receiver_pubkey[1];
      newReceiverLeaf.in[2] <== receiver_balance + amount;
  }

  // STEP 7: Update account's root with updates to receiver's account
  component computed_final_root = GetMerkleRoot(k);
  computed_final_root.leaf <== newReceiverLeaf.out;
  for (var i = 0; i < k; i++){
      computed_final_root.paths2_root_pos[i] <== receiver_proof_pos[i];
      computed_final_root.paths2_root[i] <== receiver_proof[i];
  }

  // STEP 8: Output final root
  new_accounts_root <== computed_final_root.out;
}

// create main so that we can call it directly
component main {
  public [
    accounts_root, intermediate_root
  ]
} = ProcessTx(1);
