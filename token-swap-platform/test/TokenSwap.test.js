const TokenSwap = artifacts.require("TokenSwap");

contract("TokenSwap", accounts => {
  it("should deploy the contract successfully", async () => {
    const instance = await TokenSwap.deployed();
    assert.ok(instance.address, "Contract was not deployed");
  });

  it("should return the correct name", async () => {
    const instance = await TokenSwap.deployed();
    const name = await instance.getName();
    assert.equal(name, "TokenSwap", "The contract name is incorrect");
  });
});

