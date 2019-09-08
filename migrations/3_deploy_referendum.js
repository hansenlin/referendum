const Referendum = artifacts.require("./Referendum.sol");
const ACE = artifacts.require('./ACE.sol');

module.exports = async (deployer, aztec) => {
  const instance = await ACE.deployed();
  await deployer.deploy(Referendum, instance.address);
};
