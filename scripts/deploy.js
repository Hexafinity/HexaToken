const { ethers } = require('hardhat');

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deployer address: ', deployer.address);

  const Token = await ethers.getContractFactory('ERC20Token');
  const Erc20Token = await Token.deploy(deployer.address, "TEST", "TST", "1000000", 2, 1, deployer.address);
  console.log("Deployed Erc20Token Address :- ", Erc20Token.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
});
