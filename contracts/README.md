### Contract address in Main Net

* RNG.sol (RNG)

 0x8775b37b5726535c8b83ec05da45d69e4fa62095

 *Gas Used By Txn: 733254*
 0.000733254

* GenRNG.sol (GenRNG) + address RNG

 0xf3f0cfa81a8d4524383828b0766e651bec37416f

 *Gas Used By Txn: 1735106*
 0.006940424

* FixMarketPlace.sol (FixMarketPlace) + address wallet

 0x01bd5ca2f532749e3e9b32ca605c21a70f4683a7

 *Gas Used By Txn: 1385343*
 0.001385343

* DragonETH.sol (DragonETH)

 0xc8fdebfc676731b329335930b9de670f956b04e1

 *Gas Used By Txn: 2749905*
 0.002749905

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

 0x54bab51f0ba35fa8b0057f3fea158ae2321bbdc0

 *Gas Used By Txn: 861451*
 0.000861451

* wallet Renat
 
 0x1a069d69F42C0D7848cF1f14CbE9d6B1615D4E17

* DragonStats.sol (DragonStats)
 
 0x26ca36809ada2ff648263e2c501bb1c45e6153eb

 *Gas Used By Txn: 1319489*
 0.001382163

* Mutagen.sol (Mutagen)

 

 *Gas Used By Txn: 1257640*

* DragonsFightPlace.sol (DragonsFightPlace)

 

 *Gas Used By Txn: 1636625*

* DragonsFight.sol (DragonsFight)

 
 
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

1. RNG			*func*	addAddressToWhitelist(address GenRNG) 0.000045602
2. GenRNG		*func*	addAddressToWhitelist(address DragonETH) 0.000045602
3. FixMarketPlace 	*func*	ChangeAddressMainContract(address DragonETH) 0.000043949
4. DragonETH		*func*	adminAddRole(address CrowdSaleDragonETH,string "CreateAgent" ) 0.000049098
5. DragonETH		*func*	changeGenRNGcontractAddress(address GenRNG) 0.000044474
6. DragonETH		*func*	changeFMPcontractAddress(address FixMarketPlace) 0.000044496
7. DragonETH		*func*	changeDragonStatsContractAddress(address DragonStats) 0.000045046
8. DragonStat		*func*	adminAddRole(address DragonETH, string "MainContract") 0.00004883

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

0.000340606 покупка дракона
