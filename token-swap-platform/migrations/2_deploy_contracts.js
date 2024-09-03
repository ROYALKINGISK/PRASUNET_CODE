const TokenSwap = artifacts.require("TokenSwap");

module.exports = function(deployer) {
  // Replace these with the actual addresses of your ERC-20 tokens
  const token1Address = "0xYourToken1AddressHere";
  const token2Address = "0xYourToken2AddressHere";

  deployer.deploy(TokenSwap, token1Address, token2Address);
};

