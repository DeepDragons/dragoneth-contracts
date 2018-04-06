module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,     // 7545 ganache
      gas: 6721975,
      gasPrice: 20000000000,
      network_id: "*" // Match any network id
    },
    test: {
      host: "127.0.0.1",
      port: 9545,     // 9545 truffle develop
    //  gas: 6712388,
    //  gasPrice: 65000000000,
      network_id: "*" // match any network
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
