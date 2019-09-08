const ACE = artifacts.require('./ACE.sol');
const PrivateRange = artifacts.require('./PrivateRange.sol');
const JoinSplit = artifacts.require('./JoinSplit.sol');

const utils = require('@aztec/dev-utils');

const {
  constants,
  proofs: {
    PRIVATE_RANGE_PROOF,
    JOIN_SPLIT_PROOF,
  },
} = utils;

module.exports = async deployer => {
  await deployer.deploy(ACE);
  await deployer.deploy(JoinSplit);
  await deployer.deploy(PrivateRange);
  const ACEContract = await ACE.deployed(constants.CRS)
  await ACEContract.setCommonReferenceString(constants.CRS);
  await ACEContract.setProof(JOIN_SPLIT_PROOF, JoinSplit.address);
  await ACEContract.setProof(PRIVATE_RANGE_PROOF, PrivateRange.address);
};
