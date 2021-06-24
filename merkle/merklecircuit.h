#ifndef MERKLECIRCULT_H
#define MERKLECIRCULT_H

#include <libff/common/default_types/ec_pp.hpp>
#include <libsnark/zk_proof_systems/ppzksnark/r1cs_gg_ppzksnark/r1cs_gg_ppzksnark.hpp>
#include <libsnark/gadgetlib1/gadgets/merkle_tree/merkle_tree_check_read_gadget.hpp>
#include <libsnark/gadgetlib1/gadgets/hashes/sha256/sha256_gadget.hpp>

using namespace libsnark;
namespace sample {
    template <typename FieldT, typename HashT>
        class MerkleCircuit {
        public:
            const size_t digest_size;
            const size_t tree_depth_;
            std::shared_ptr<digest_variable<FieldT>> root_digest_;
            std::shared_ptr<digest_variable<FieldT>> leaf_digest_;
            pb_variable_array<FieldT> address_bits_var_;
            std::shared_ptr<merkle_authentication_path_variable<FieldT, HashT>> path_var_;
            std::shared_ptr<merkle_tree_check_read_gadget<FieldT, HashT>> merkle_;

            MerkleCircuit(protoboard<FieldT>& pb, const size_t& depth):
                digest_size(HashT::get_digest_len()),
                tree_depth_(depth) {
                root_digest_ = std::make_shared<digest_variable<FieldT>>(pb, digest_size, "root");
                leaf_digest_ = std::make_shared<digest_variable<FieldT>>(pb, digest_size, "leaf");
                path_var_ = std::make_shared<merkle_authentication_path_variable<FieldT, HashT>>(pb, tree_depth_, "path");
                address_bits_var_.allocate(pb, tree_depth_, "address_bits");
                merkle_ = std::make_shared<merkle_tree_check_read_gadget<FieldT, HashT>>(pb, tree_depth_, address_bits_var_, *leaf_digest_, *root_digest_, *path_var_,
                        ONE, "merkle");
                pb.set_input_sizes(root_digest_->digest_size);
            }

            void generate_r1cs_constraints() {
                path_var_->generate_r1cs_constraints();
                merkle_->generate_r1cs_constraints();
            }

            void generate_r1cs_witness(protoboard<FieldT>& pb, libff::bit_vector& leaf,
                    libff::bit_vector& root, merkle_authentication_path& path,
                    const size_t address, libff::bit_vector& address_bits) {
                root_digest_->generate_r1cs_witness(root);
                leaf_digest_->generate_r1cs_witness(leaf);
                address_bits_var_.fill_with_bits(pb, address_bits);
                assert(address_bits_var_.get_field_element_from_bits(pb).as_ulong() == address);
                path_var_->generate_r1cs_witness(address, path);
                merkle_->generate_r1cs_witness();
            }
        };
}

#endif
