### Contract address in Ropsten

* RNG.sol (RNG)

 

 *Gas Used By Txn: 607300*

* GenRNG.sol (GenRNG) + address RNG

 

 *Gas Used By Txn: 889266*

* FixMarketPlace.sol (FixMarketPlace) + address wallet

 

 *Gas Used By Txn: 1218021*

* DragonETH.sol (DragonETH)

 

 *Gas Used By Txn: 2388930*

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

 

 *Gas Used By Txn: 763391*


* wallet
 
 0x638a05783dB75e08095A45362E3f207601277dAe

* DragonStats.sol (DragonStats)
 
 

 *Gas Used By Txn: 1319489*


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
4. DragonETH.sol (DragonETH) + address wallet
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
добавить в основной контракт роль "ActionContract" для всех котрактов действия которые имеют право дергть сответсвующую функцию
добавить в контракт некрополь роль "DeathContract" Для DragonETH и остальных смертельных контрактов

### How to use remix with local files

Hint: https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html


