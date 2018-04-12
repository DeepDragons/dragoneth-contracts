### Contract address

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

 0x3dbf45dc3665441455bd32e71568a2f4bdbd12b6

 *Gas Used By Txn: 2147468*

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

 0x1d71e3aebe526275054d5ba3422df642d534efba

 *Gas Used By Txn: 638814*


* wallet
 
 0x638a05783dB75e08095A45362E3f207601277dAe

* DragonStats.sol (DragonStats)
 
 0xe32b7978ac808c691c014a887cf80a91c8239647

 *old Gas Used By Txn: 1319489*


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
6. DragonStats.sol (DragonStats) + address DragonETH
7. Mutagen.sol

*Other*

7. DragonsFightPlace.sol (DragonsFightPlace) + address wallet
8. DragonsFight.sol (DragonsFight)


#### Settings

*MVP*

1. RNG			*func*	addAddressToWhitelist(address GenRNG)
2. GenRNG		*func*	addAddressToWhitelist(address DragonETH)
3. FixMarketPlace 	*func*	ChangeAddressMainContract(address DragonETH)
4. DragonETH		*func*	adminAddRole(address CrowdSaleDragonETH,string "CreateAgent" )
5. DragonETH		*func*	changeGenRNGcontractAddress(address GenRNG)
6. DragonETH		*func*	changeFMPcontractAddress(address FixMarketPlace)

*Other*

7. DragonStat		*func*	adminAddRole(address DragonsFightPlace, string "FightContract")
8. DragonStat		*func*	adminAddRole(address DragonsFightPlace, string "ActionContract")
8. DragonsFightPlace	*func*	changeAddressMainContract(address DragonETH)
8. DragonsFightPlace	*func*	changeAddressMutagenContract(address Mutagen)
9. DragonsFightPlace	*func*	changeAddressFightContract(address DragonsFight)
10. DragonsFightPlace	*func*	changeAddressStatsContract(address DragonStats)
11. Mutagen		*func*	adminAddRole(address DragonsFightPlace, string "MintAgent")

### How to use remix with local files

Hint: https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html


