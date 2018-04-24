### Contract address in Kovan

* RNG.sol (RNG)

 0x28b283ebd59d864d553ff5075f029d8ebb3d89ba

 *Gas Used By Txn: 907918*

* GenRNG.sol (GenRNG) + address RNG

 0x686bfab6dcc3da1e3ec39d0353319c4a6277c726

 *Gas Used By Txn: 1075167*

* FixMarketPlace.sol (FixMarketPlace) + address wallet

 

 *Gas Used By Txn: 1218021*

* DragonETH.sol (DragonETH)

 0xbe9eaa87ce66061de642f0270845596385177dd5

 *Gas Used By Txn: 4816445*

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

 0x5d314091ef4bc62bc9f03ad32e07ccfb0cc981f7

 *Gas Used By Txn: 1259092*


* wallet
 
 0xDe089D1801e6Ed1d75076950c4717445d02aE984

* DragonStats.sol (DragonStats)
 
 0xe38154ea3a7eaf4bd7a9f019f7237c0970dd3aef

 *Gas Used By Txn: 1361774*


* Mutagen.sol (Mutagen)

 

 *Gas Used By Txn: 1257640*

* DragonsFightPlace.sol (DragonsFightPlace)

 

 *Gas Used By Txn: 1636625*

* DragonsFight.sol (DragonsFight)

 
 
 *Gas Used By Txn: 609959*

* Necropolis.sol (Necropolis)

0xc1807abba73def2576908fe33d1903e7b5a77b36

2 *Gas Used By Txn: 867597*

### Deployment

#### Deploy

*MVP*
0. MultiWallet.sol (MultiWallet)
1. DragonStats.sol (DragonStats)
2. Necropolis.sol (Necropolis)
3. RNG.sol (RNG)
4. GenRNG.sol (GenRNG) + address RNG
5. DragonETH.sol (DragonETH) + address wallet + address Necropolis + address DragonStats
6. CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH



*Other*

7. FixMarketPlace.sol (FixMarketPlace) + address wallet
8. Mutagen.sol
9. DragonsFightPlace.sol (DragonsFightPlace) + address wallet
10. DragonsFight.sol (DragonsFight)


#### Settings

*MVP*

1. RNG			*func*	adminAddRole(address GenRGN,string "GenRNG" )
2. GenRNG		*func*	adminAddRole(address DragonETH,string "MainContract" )
3. DragonETH		*func*	changeGenRNGcontractAddress(address GenRNG)
4. DragonETH		*func*	adminAddRole(address CrowdSaleDragonETH,string "CreateContract" )
5. DragonStat		*func*	adminAddRole(address DragonETH, string "MainContract")
6. Necropolis		*func*	adminAddRole(address DragonETH, string "MainContract")

*Other*

7. DragonETH		*func*	changeFMPcontractAddress(address FixMarketPlace)
8. FixMarketPlace 	*func*	ChangeAddressMainContract(address DragonETH)

8. DragonStat		*func*	adminAddRole(address DragonsFightPlace, string "FightContract")
9. DragonStat		*func*	adminAddRole(address DragonsFightPlace, string "ActionContract")
10. DragonsFightPlace	*func*	changeAddressMainContract(address DragonETH)
11. DragonsFightPlace	*func*	changeAddressMutagenContract(address Mutagen)
12. DragonsFightPlace	*func*	changeAddressFightContract(address DragonsFight)
13. DragonsFightPlace	*func*	changeAddressStatsContract(address DragonStats)
14. Mutagen		*func*	adminAddRole(address DragonsFightPlace, string "MintAgent")
добавить в основной контракт роль "ActionContract" для всех котрактов действия которые имеют право дергть сответсвующую функцию
добавить в контракт некрополь роль "DeathContract" Для DragonETH и остальных смертельных контрактов
добавить в контракт статистики роль "DeathContract" Для DragonETH и остальных смертельных контрактов

### Testing settings

1. GenRNG		*func*	Whitelist(address DragonETH) == True
2. DragonETH		*func*	genRNGContractAddress == address GenRNG
3. DragonETH		*func*	dragonStatsContractAddress == address DragonStats
4. DragonETH		*func*	hasRole(address CrowdSaleDragonETH,string "CreateContract" ) == True
5. DragonStat		*func*	hasRole(address DragonETH,string "MainContract" ) == True
6. Necropolis		*func*	hasRole(address DragonETH,string "MainContract" ) == True


7. DragonETH		*func*	FMPcontractAddress == address FixMarketPlace
8. FixMarketPlace	*func*	MainContract == address DragonETH
### How to use remix with local files

Hint: https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html


