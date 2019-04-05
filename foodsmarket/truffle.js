module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 9545,
      network_id: "5777" // Match any network id
    }
  },
    compilers: {
    solc: {
      version: "0.5.3",    // Fetch exact version from solc-bin (default: truffle's version)
      optimizer: {
         enabled: false,
          runs: 200
      }
    }
   } 
};
