%module chain
%{
#include <bitcoin/bitcoin.hpp>
%}

%import "bitcoin-math-ext.i"
%import "bitcoin-math-ext-typemap.i"
%import "bitcoin-config-ext.i"
%import "bitcoin-config-ext-typemap.i"
%import "bitcoin-utility-ext.i"
%import "bitcoin-utility-ext-typemap.i"
%import "bitcoin-wallet-ext.i"
%import "bitcoin-wallet-ext-typemap.i"

%include "bitcoin-chain-ext.i"

%include "../../../../include/bitcoin/bitcoin/chain/chain_state.hpp"

%ignore libbitcoin::chain::payment_record::payment_record(chain::payment_record&& other);
%ignore libbitcoin::chain::payment_record::operator=(payment_record&& other);
%rename(assign) libbitcoin::chain::payment_record::operator=(const payment_record& other);
%rename(eq) libbitcoin::chain::payment_record::operator==(const payment_record& other) const;
%rename(ne) libbitcoin::chain::payment_record::operator!=(const payment_record& other) const;
%ignore libbitcoin::chain::payment_record::factory(std::istream& stream, bool wire=true);
%ignore libbitcoin::chain::payment_record::factory(reader& source, bool wire=true);
%ignore libbitcoin::chain::payment_record::from_data(std::istream& stream, bool wire=true);
%ignore libbitcoin::chain::payment_record::from_data(reader& source, bool wire=true);
%ignore libbitcoin::chain::payment_record::to_data(std::ostream& stream, bool wire=true) const;
%ignore libbitcoin::chain::payment_record::to_data(writer& sink, bool wire=true) const;
%include "../../../../include/bitcoin/bitcoin/chain/payment_record.hpp"

%ignore libbitcoin::chain::stealth_record::stealth_record(chain::stealth_record&& other);
%ignore libbitcoin::chain::stealth_record::stealth_record(size_t height, uint32_t prefix,
        hash_digest&& ephemeral_public_key, short_hash&& public_key_hash,
        hash_digest&& transaction_hash);
%ignore libbitcoin::chain::stealth_record::stealth_record(size_t height, uint32_t prefix,
        const ec_compressed& ephemeral_public_key,
        short_hash&& public_key_hash, hash_digest&& transaction_hash);
%ignore libbitcoin::chain::stealth_record::operator=(stealth_record&& other);
%rename(assign) libbitcoin::chain::stealth_record::operator=(const stealth_record& other);
%rename(eq) libbitcoin::chain::stealth_record::operator==(const stealth_record& other) const;
%rename(ne) libbitcoin::chain::stealth_record::operator!=(const stealth_record& other) const;
%ignore libbitcoin::chain::stealth_record::factory(std::istream& stream, bool wire=true);
%ignore libbitcoin::chain::stealth_record::factory(reader& source, bool wire=true);
%ignore libbitcoin::chain::stealth_record::from_data(std::istream& stream, bool wire=true);
%ignore libbitcoin::chain::stealth_record::from_data(reader& source, bool wire=true);
%ignore libbitcoin::chain::stealth_record::from_data(reader& source, size_t start_height, const binary& filter);
%ignore libbitcoin::chain::stealth_record::to_data(std::ostream& stream, bool wire=true) const;
%ignore libbitcoin::chain::stealth_record::to_data(writer& sink, bool wire=true) const;
%include "../../../../include/bitcoin/bitcoin/chain/stealth_record.hpp"

%ignore libbitcoin::chain::witness::witness(witness&& other);
%ignore libbitcoin::chain::witness::witness(data_stack&& stack);
%ignore libbitcoin::chain::witness::witness(data_chunk&& encoded, bool prefix);
%ignore libbitcoin::chain::witness::operator=(witness&& other);
%rename(assign) libbitcoin::chain::witness::operator=(const witness& other);
%rename(eq) libbitcoin::chain::witness::operator==(const witness& other) const;
%rename(ne) libbitcoin::chain::witness::operator!=(const witness& other) const;
%rename(get) libbitcoin::chain::witness::operator[](size_t index) const;
%ignore libbitcoin::chain::witness::factory(std::istream& stream, bool prefix);
%ignore libbitcoin::chain::witness::factory(reader& source, bool prefix);
%ignore libbitcoin::chain::witness::from_data(std::istream& stream, bool prefix);
%ignore libbitcoin::chain::witness::from_data(reader& source, bool prefix);
%ignore libbitcoin::chain::witness::to_data(std::ostream& stream, bool prefix) const;
%ignore libbitcoin::chain::witness::to_data(writer& sink, bool prefix) const;
%include "../../../../include/bitcoin/bitcoin/chain/witness.hpp"

namespace libbitcoin {
namespace chain {
%template(BlockVector) std::vector<libbitcoin::chain::block>;
%template(SizeTVector) std::vector<size_t>;

%template(PointVector) std::vector<libbitcoin::chain::point>;
%template(PointValueVector) std::vector<libbitcoin::chain::point_value>;
%template(TransactionVector) std::vector<libbitcoin::chain::transaction>;
}
}

%pragma(java) jniclasscode=%{
  static {
    try {
        System.loadLibrary("bitcoin-chain");
    } catch (UnsatisfiedLinkError e) {
      System.err.println("Native code library failed to load. \n" + e);
      System.exit(1);
    }
  }
%}
