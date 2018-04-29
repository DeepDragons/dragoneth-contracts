### Contract address in Kovan

* RNG.sol (RNG)

0xfa7ab11d6adb67c602d03cb180a4f4a3c98f1a41

 *Gas Used By Txn: 907918*

* GenRNG.sol (GenRNG) + address RNG

0xd2a88c34855450d73b1c13667d0b11d289848489 

 *Gas Used By Txn: 1075167*

* FixMarketPlace.sol (FixMarketPlace) + address wallet

0x80d95fd025da6e779ea797ed6524806d459f69df

 *Gas Used By Txn: 1218021*

* DragonETH.sol (DragonETH)

0x99c4d4764a36407da659f686d49cb278477fe4ea

 *Gas Used By Txn: 5236615*

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

0x35c2b82146ece67e4526f35862abe8ef81244556

 *Gas Used By Txn: 1259092*


* wallet
 
0xDe089D1801e6Ed1d75076950c4717445d02aE984

* DragonStats.sol (DragonStats)
 
0x31ba781647bdabb0a2dcdae03ea95089352eb690

 *Gas Used By Txn: 1361774*


* Mutagen.sol (Mutagen)

0xd08ada3da9280d7bf1079e7c90a733eaf619f991 

 *Gas Used By Txn: 1257640*

* DragonsFightPlace.sol (DragonsFightPlace)

0xfbfa61e5d9eb2623f3a544d2733fb1c818d3db56

 *Gas Used By Txn: 1636625*

* DragonsFight.sol (DragonsFight)

0x58886abc2f5214ee140b1a92605b198152432993
 
 *Gas Used By Txn: 609959*

* Necropolis.sol (Necropolis)

0xd457c1424061130d53ed947245da0b6223a0152c

2 *Gas Used By Txn: 867597*

Contracts to kill:

0x58886abc2f5214ee140b1a92605b198152432993



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


