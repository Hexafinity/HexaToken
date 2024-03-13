const { expect } = require('chai');
const { ethers } = require('hardhat');

describe("ERC20 tokens", function () {
  beforeEach(async function () {
    ERC20Token = await ethers.getContractFactory('ERC20Token');
    [ownerAddress, userAddress1, userAddress2] = await ethers.getSigners();

    token = await ERC20Token.deploy(ownerAddress.address, "TEST", "TST", "100000", 2, 1, ownerAddress.address);
  });

  describe("Transfer functionality ", function () {
    it("Tranfer from Account 1 to Account 2(If Owner)", async function () {
      await token.transfer(userAddress1.address, "10000000000000000000");
      expect(await token.balanceOf(ownerAddress.address)).to.be.equal("99990000000000000000000");
      expect(await token.balanceOf(userAddress1.address)).to.be.equal("10000000000000000000");
    });

    it("Tranfer from Account 1 to Account 2(If non-Owner)", async function () {
      await token.transfer(userAddress1.address, "1000000000000000000000");

      await token.connect(userAddress1).transfer(userAddress2.address, "100000000000000000000");
      expect(await token.balanceOf(userAddress1.address)).to.be.equal("900000000000000000000");
      expect(await token.balanceOf(userAddress2.address)).to.be.equal("99700000000000000000");
      expect(await token.balanceOf(ownerAddress.address)).to.be.equal("99000200000000000000000");
    });
  });
});