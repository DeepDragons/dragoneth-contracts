### Contract address in Main Net

* RNG.sol (RNG)

0x91a56d01A4BC1f07ec731f86408b1114A1540e9C

* GenRNG.sol (GenRNG) + address RNG

0x995a600ebf8c49387f5adb6674e41d0432f74d91

* DragonETH.sol (DragonETH)

0x34887B4E8Fe85B20ae9012d071412afe702C9409

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

0xBf662FB1C4Ab0657bDA2Fbfec620F3a2E0589AbF

* DragonStats.sol (DragonStats) real!!! withot source code on etherscan


0x3c29ef59bebe160bbc59c02130b8f637fa11a978


* Necropolis.sol (Necropolis)

0xC8157b670C89F4efdC9B6F00a208036BA1CF8Dee

* Proxy4DAPP

0x2149984f403BEFaA4815D31630f4021c95511C8A

* FixMarketPlace

0x0463d394D383F8e56561120FF00834fef8a5AFaC

* wallet

0xd0d50AE97443AA9615d87129feb9681417e92F41

old_wallet 0x787afd5a10fa6b212c1161461bca9ddc52788aee


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

1. GenRNG		*func*	hasRole(address DragonETH,string "MainContract" ) == True
2. DragonETH		*func*	genRNGContractAddress == address GenRNG
3. DragonETH		*func*	dragonStatsContractAddress == address DragonStats
4. DragonETH		*func*	hasRole(address CrowdSaleDragonETH,string "CreateContract" ) == True
5. DragonStat		*func*	hasRole(address DragonETH,string "MainContract" ) == True
6. Necropolis		*func*	hasRole(address DragonETH,string "MainContract" ) == True


7. DragonETH		*func*	FMPcontractAddress == address FixMarketPlace
8. FixMarketPlace	*func*	MainContract == address DragonETH
### How to use remix with local files

Hint: https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html

Our MainNet node rpc http://178.62.250.108:8545

web socket 178.62.250.108:8546

geth attach http://178.62.250.108:8545

old OKO ethereum node http://81.171.12.251:8545

Old contract redeploy 04/06/2018:

* GenRNG.sol (GenRNG) 0xAB939a472D42d79d9b16c2dCa53b67D7c7a2598A

* wallet 0xC8157b670C89F4efdC9B6F00a208036BA1CF8Dee

Bug deploy

* Necropolis.sol (Necropolis) with source code

0x3cD20D014384C16537a9AC945d7c39e470183E79


Old contract first deploy:

* DragonETH.sol (DragonETH) 0x21c4a603cd7fcc16b2ff1f5f30e5b839b9222108

* CrowdSale.sol (CrowdSaleDragonETH) 0xeBabE9C9AD63851d56F7030C08D3D021c4436dd5

* DragonStats.sol (DragonStats) 0xd40447f919dF3708568078eE7d92C041067cc8a1 0x3c29ef59bebe160bbc59c02130b8f637fa11a978

* Necropolis.sol (Necropolis) 0x81f62207eB1E4274feA855943e260091306bE457 0x3cD20D014384C16537a9AC945d7c39e470183E79

