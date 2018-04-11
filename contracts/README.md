### Contract address

* RNG.sol (RNG)

 0x10e391eb0289a13b37f84442f45a480fe7e2a083

 *Gas Used By Txn: 607300*

 https://ropsten.etherscan.io/tx/0xa9fc19175a882e619f157a45d83ac3309bcd635442d67a2df9b2cf8cb9e414fa

* GenRNG.sol (GenRNG) + address RNG

 0x1519c35984f3cbf9e5afc2e9104f2f1293029289

 *Gas Used By Txn: 889266*

 https://ropsten.etherscan.io/tx/0xa66b27adc1fc9f7daaf6e5317babee85a8bf8841da3eec8018bcb307d012535e

* FixMarketPlace.sol (FixMarketPlace) + address wallet

 0xa3e8cfbc93efb4b1c40e830a372608dbde1c726c

 *Gas Used By Txn: 1218021*

 https://ropsten.etherscan.io/tx/0x1e4b9b450c9db2b5bb43bf661134f01f7300486328c97b33d833e9d2bc7b55c9

* DragonETH.sol (DragonETH)

 0x3dbf45dc3665441455bd32e71568a2f4bdbd12b6

 *Gas Used By Txn: 2147468*

 https://ropsten.etherscan.io/tx/0xed1b1c15e0347899fc6cbe2aad74375fc3b19eb58fe23a0b7229f1c7de3f9f1d

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

 0x1d71e3aebe526275054d5ba3422df642d534efba

 *Gas Used By Txn: 638814*

https://ropsten.etherscan.io/tx/0x9d98e9794761e09ef065566dbeada87d2c0c612f5863a45fd91929b92d31b128


* wallet
 
 0x638a05783dB75e08095A45362E3f207601277dAe

### Deployment

#### Deploy

1. RNG.sol (RNG)
2. GenRNG.sol (GenRNG) + address RNG
3. FixMarketPlace.sol (FixMarketPlace) + address wallet 
4. DragonETH.sol (DragonETH)
5. CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

#### Settings

1. RNG            *func*	addAddressToWhitelist(address GenRNG)
2. GenRNG         *func*	addAddressToWhitelist(address DragonETH)
3. FixMarketPlace *func*	ChangeAddressMainContract(address DragonETH)
4. DragonETH      *func*	adminAddRole(address CrowdSaleDragonETH,string "CreateAgent" )
5. DragonETH      *func*	changeGenRNGcontractAddress(address GenRNG)
6. DragonETH      *func*	changeFMPcontractAddress(address FixMarketPlace)

### How to use remix with local files

Hint: https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html


