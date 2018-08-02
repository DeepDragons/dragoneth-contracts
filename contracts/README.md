### Contract address in Kovan

* RNG.sol (RNG)

0x155282b55c6f69bb91868e328b4afd84ef18c6d8

* GenRNG.sol (GenRNG) + address RNG

0x34eb22a2cbd77773ec77688fd05f9422dca5d968

* DragonETH.sol (DragonETH)

0x2050a13468359b78441f3dc3e0035e389ba4b08b

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

0x45e73ad30e0662c7262f913dc5715d03872c3292

* DragonStats.sol (DragonStats)
 
0x33db6b612c427a13b767273f5138222eca247c7e

* Necropolis.sol (Necropolis)

0xec53b186e3a04547260e7e4acfa53e4d65671fb3

* MarketPlace.sol (FixMarketPlace)

0x03d7877d7fd14fb006f3a4c7d319e23afa3437dc

* DragonsFightPlace.sol (DragonsFightPlace)

0x175d18de9021fe270bed7a5c99091910c3ce121a


# Other

* DragonsFight.sol (DragonsFight)

0xb738c8f2382fd00cd9fd358764bf74a38e595260

* Mutagen.sol (Mutagen)

0xf02fd49f71429e52f76b1bc6907670bd1fd78bcd

# Wallets

* ProxyWallet

0x4fde93f4b6d3d5d39026cf49323d51c01b30ecb0

* wallet Igor
 
0x1DbEd156A8423abe1aCE32abeBD972f29CceCd78

* main Referer Igor
 
0xeC9FefdD828C28b4D1559548E5df6a460d83dB29

* Igor for larg ETH

0x638a05783dB75e08095A45362E3f207601277dAe

* wallet Alexandr

0x907aA122D7EE585E1dD7D50F8892d27633e04082

* wallet Ekaterina

0xF6E3eCB1a0F06a816B0a260c7f60AbFAE6e3f97a

* wallet Rinat?

0xA98060409a31FdF92754ADD44645d273578185C7

### Deployment

#### Deploy

*MVP*
0. MultiWallet.sol (MultiWallet)
0. ProxyWallet.sol (ProxyWallet) + address wallet
1. DragonStats.sol (DragonStats)
2. Necropolis.sol (Necropolis)
3. RNG.sol (RNG)
4. GenRNG.sol (GenRNG) + address RNG
5. DragonETH.sol (DragonETH) + address ProxyWallet + address Necropolis + address DragonStats
6. CrowdSale.sol (CrowdSaleDragonETH) + address ProxyWallet + address DragonETH



*Other*

7. FixMarketPlace.sol (FixMarketPlace) + address ProxyWallet
8. Mutagen.sol
9. DragonsFightPlace.sol (DragonsFightPlace) + address ProxyWallet
10. DragonsFight.sol (DragonsFight)


#### Settings

*MVP*

1. RNG			*func*	adminAddRole(address GenRGN,string "GenRNG" )
2. DragonETH		*func*	changeGenRNGcontractAddress(address GenRNG)
3. DragonETH		*func*	adminAddRole(address CrowdSaleDragonETH,string "CreateContract" )
4. GenRNG		*func*	adminAddRole(address DragonETH, string "MainContract" )
5. DragonStat		*func*	adminAddRole(address DragonETH, string "MainContract" )
6. Necropolis		*func*	adminAddRole(address DragonETH, string "MainContract" )
7. add main referer
8. set time to burn = 2
9. set time to rest = 2
10. set second in bloc = 5

*Other*

7. DragonETH		*func*	changeFMPcontractAddress(address FixMarketPlace)
8. FixMarketPlace 	*func*	ChangeAddressMainContract(address DragonETH)

8. DragonStat		*func*	adminAddRole(address DragonsFightPlace, string "FightContract" )
9. DragonStat		*func*	adminAddRole(address DragonsFightPlace, string "ActionContract" )
10. DragonETH		*func*	adminAddRole(address DragonsFightPlace, string "ActionContract" )
11. Mutagen		*func*	adminAddRole(address DragonsFightPlace, string "MintAgent" )
12. DragonsFightPlace	*func*	changeAddressMainContract(address DragonETH)
13. DragonsFightPlace	*func*	changeAddressMutagenContract(address Mutagen)
14. DragonsFightPlace	*func*	changeAddressFightContract(address DragonsFight)
15. DragonsFightPlace	*func*	changeAddressStatsContract(address DragonStats)

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

1. DragonStat		*func*	hasRole(address DragonsFightPlace, string "FightContract" ) == True
1. DragonStat		*func*	hasRole(address DragonsFightPlace, string "ActionContract" ) == True
1. DragonETH		*func*	hasRole(address DragonsFightPlace, string "ActionContract" ) == True
11. Mutagen		*func*	hasRole(address DragonsFightPlace, string "MintAgent" ) == True
12. DragonsFightPlace	*func*	dragonsFightContract == address DragonsFight
13. DragonsFightPlace	*func*	dragonsStatsContract == address DragonStats
14. DragonsFightPlace	*func*	mainContract == address DragonETH
15. DragonsFightPlace	*func*	mutagenContract == address Mutagen

### How to use remix with local files

Hint: https://remix.readthedocs.io/en/latest/tutorial_remixd_filesystem.html


Our Kovan node rpc http://178.128.194.136:8545

web socket 178.128.194.136:8546

geth attach http://178.128.194.136:8545

# Old contract:

* DragonETH.sol (DragonETH)

0xf4ef2d6cb587ced2b910704492d76e2d63629570

* CrowdSale.sol (CrowdSaleDragonETH) + address wallet + address DragonETH

0x299f27f810890b67b80d3d144cf008d0b12590f9

* DragonStats.sol (DragonStats)
 
0x25c9a5decd750f1c66f791ad1db6b037390333ea

* Necropolis.sol (Necropolis)

0x45b119733f51511f3cd40c72df8f3e0861e851d1

* MarketPlace.sol (FixMarketPlace)

0xf1433fdffbd2c1474e7f0b39147a989fec252d54

* DragonsFightPlace.sol (DragonsFightPlace)

0xc87f8b76af5d908898e4291c5d2a838a3d22eb1f


