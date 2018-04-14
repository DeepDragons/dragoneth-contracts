### Contract address in Ropsten

* RNG.sol (RNG)

 0x10e391eb0289a13b37f84442f45a480fe7e2a083

 *Gas Used By Txn: 607300*

* GenRNG.sol (GenRNG) + address RNG

 0x1519c35984f3cbf9e5afc2e9104f2f1293029289

 *Gas Used By Txn: 889266*

* FixMarketPlace.sol (FixMarketPlace) + address wallet

 0xa3e8cfbc93efb4b1c40e830a372608dbde1c726c

 *Gas Used By Txn: 1218021*

* DragonETH.sol (DragonETH)

 0x834cc5856b2a08aa62439555914081f7604f48ec

 *Gas Used By Txn: 2388930*

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

 0x2e85c4898938738b54ffcc2d9ceb0f9d35278e94

 *Gas Used By Txn: 763391*


* wallet
 
 0x638a05783dB75e08095A45362E3f207601277dAe

* DragonStats.sol (DragonStats)
 
 0x3adca8a6cd338bf8456e2eaadf8a06bb9d831411

 *Gas Used By Txn: 1319489*


* Mutagen.sol (Mutagen)

 0x7b411d2a493f88c3a69d28e0debbca98c3263322

 *Gas Used By Txn: 1257640*

* DragonsFightPlace.sol (DragonsFightPlace)

 0x0da46dc0b028f41994d2a6b536496dfe89f5cabb

 *Gas Used By Txn: 1636625*

* DragonsFight.sol (DragonsFight)

 0x7995234f5871138c2b80e1829eddaa40b5976690
 
 *Gas Used By Txn: 609959*

### Deployment

#### Deploy

*MVP*

1. RNG.sol (RNG)
2. GenRNG.sol (GenRNG) + address RNG
3. FixMarketPlace.sol (FixMarketPlace) + address wallet 
4. DragonETH.sol (DragonETH)
5. CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH
6. DragonStats.sol (DragonStats)
7. Mutagen.sol

*Other*

8. DragonsFightPlace.sol (DragonsFightPlace) + address wallet
9. DragonsFight.sol (DragonsFight)


#### Settings

*MVP*

1. RNG			*func*	addAddressToWhitelist(address GenRNG)
2. GenRNG		*func*	addAddressToWhitelist(address DragonETH)
3. FixMarketPlace 	*func*	ChangeAddressMainContract(address DragonETH)
4. DragonETH		*func*	adminAddRole(address CrowdSaleDragonETH,string "CreateAgent" )
5. DragonETH		*func*	changeGenRNGcontractAddress(address GenRNG)
6. DragonETH		*func*	changeFMPcontractAddress(address FixMarketPlace)
7. DragonETH		*func*	changeDragonStatsContractAddress(address DragonStats)
8. DragonStat		*func*	adminAddRole(address DragonETH, string "MainContract")

*Other*

8. DragonStat		*func*	adminAddRole(address DragonsFightPlace, string "FightContract")
9. DragonStat		*func*	adminAddRole(address DragonsFightPlace, string "ActionContract")
10. DragonsFightPlace	*func*	changeAddressMainContract(address DragonETH)
11. DragonsFightPlace	*func*	changeAddressMutagenContract(address Mutagen)
12. DragonsFightPlace	*func*	changeAddressFightContract(address DragonsFight)
13. DragonsFightPlace	*func*	changeAddressStatsContract(address DragonStats)
14. Mutagen		*func*	adminAddRole(address DragonsFightPlace, string "MintAgent")

### How to use remix with local files

Hint: https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html


