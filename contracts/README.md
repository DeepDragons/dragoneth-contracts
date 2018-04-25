### Contract address in Kovan

* RNG.sol (RNG)

0xfa7ab11d6adb67c602d03cb180a4f4a3c98f1a41

 *Gas Used By Txn: 907918*

* GenRNG.sol (GenRNG) + address RNG

0xd2a88c34855450d73b1c13667d0b11d289848489 

 *Gas Used By Txn: 1075167*

* FixMarketPlace.sol (FixMarketPlace) + address wallet

 

 *Gas Used By Txn: 1218021*

* DragonETH.sol (DragonETH)

0x573b84ebc275d5a3976d663f509b4d0a80d9ffbf

 *Gas Used By Txn: 5236615*

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

0xaa31890265ba43ac65babf34adfb358efcc504a6

 *Gas Used By Txn: 1259092*


* wallet
 
 0xDe089D1801e6Ed1d75076950c4717445d02aE984

* DragonStats.sol (DragonStats)
 
0xf275c0751a1738c1a7e2050cf1bc3c113e186719

 *Gas Used By Txn: 1361774*


* Mutagen.sol (Mutagen)

 

 *Gas Used By Txn: 1257640*

* DragonsFightPlace.sol (DragonsFightPlace)

 

 *Gas Used By Txn: 1636625*

* DragonsFight.sol (DragonsFight)

 
 
 *Gas Used By Txn: 609959*

* Necropolis.sol (Necropolis)

0x9104e19f97bbb0bcaab74145e3e1b922324fcc9e

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


