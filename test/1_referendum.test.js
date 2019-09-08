const { PrivateRangeProof, JoinSplitProof, note } = require('aztec.js');
const dotenv = require('dotenv');
dotenv.config();
const secp256k1 = require('@aztec/secp256k1');

const Referendum = artifacts.require("./Referendum.sol");


contract('Private Vote', accounts => {

  let referendumContract;
  const owner = secp256k1.accountFromPrivateKey(process.env.GANACHE_TESTING_ACCOUNT_0);
  const sender = accounts[1];


  beforeEach(async () => {
    referendumContract = await Referendum.deployed();
  });

  it('vote proof', async() => {

    await referendumContract.register.sendTransaction({ from: sender });
    await referendumContract.proposePolicy.sendTransaction("leave EU", { from: owner.address });

    const originalNote = await note.create(owner.publicKey, 1);
    const utilityNote = await note.create(owner.publicKey, 1);
    const comparisonNote = await note.create(owner.publicKey, 0);
    
    const proof = new PrivateRangeProof(originalNote, comparisonNote, utilityNote, sender);
    const data = proof.encodeABI();

    await referendumContract.vote.sendTransaction(0, data, { from: sender });
  })

  it('compile results proof', async() => {

    const originalNote = await note.create(owner.publicKey, 1)

    let sumValue = 1;

    const sumNote = await note.create(owner.publicKey, sumValue);
    const proof = new JoinSplitProof([originalNote], [sumNote], owner.address, 0, owner.address);
    const data = proof.encodeABI(referendumContract.address);

    await referendumContract.compileResult.sendTransaction(0, data, { from: owner.address });
  })
});

