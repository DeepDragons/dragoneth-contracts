var RNG = artifacts.require("RNG");
var GenRNG = artifacts.require("GenRNG");
var FixMarketPlace = artifacts.require("FixMarketPlace");
var DragonETH = artifacts.require("DragonETH");
var CrowdSale = artifacts.require("CrowdSaleDragonETH");
var Test = artifacts.require("ERC721Token")

// Not work, f**ing truffle
module.exports = function (deployer, network, accounts) {
           deployer.deploy(RNG).then(function() {
    return deployer.deploy(GenRNG, RNG.address);
  }).then(function() {
    return deployer.deploy(FixMarketPlace, accounts[0]);
  }).then(function() {
    return deployer.deploy(DragonETH, accounts[0], accounts[0]);
  });
}; 
/* module.exports = function (deployer, network, accounts) {
  deployer.deploy(RNG);
  deployer.deploy(GenRNG, RNG.address);
}; */
