# Service Points for Epoch 1.0.7
Service point script updated for 1.0.7 by Airwaves Man

Discussion thread on EpochMod: https://epochmod.com/forum/topic/43075-release-vehicle-service-point-refuel-repair-rearm-updated-for-106/

	(original github url: https://github.com/vos/dayz/tree/master/service_point)
	(original install/discussion url: https://epochmod.com/forum/topic/3935-release-vehicle-service-point-refuel-repair-rearm-script/)
	
**** *REQUIRES DAYZ EPOCH 1.0.7* ****

# Index:

* [Mission folder install](https://github.com/oiad/service_points#mission-folder-install)
* [BattlEye filter install](https://github.com/oiad/service_points#battleye-filter-install)
* [Old Releases](https://github.com/oiad/service_points#old-releases)
	
Major Changes:

	This version adds support for both single currency and gems (from the epoch 1.0.7 update) as well as the original epoch briefcase currency system. 
	Instead of pricing things like the original way, prices are now done on a "worth" similar to how coins are done. The price value of items are below.
	If you are using coins, I would recommend using the _currencyModifier variable since coins typically are 10x the value of briefcase based currency (1 brief == 100,000 coins)
	(You can either set this _currencyModifier variable to 1 then set the proper value or use the modifier, the modifier is mainly for dual currency servers)

	1 silver = 1 worth
	1 10oz silver = 10 worth
	1 gold = 100 worth
	1 10oz gold = 1,000 worth
	1 briefcase = 10,000 worth

	Please see dayz_code\configVariables.sqf for the value of gems (DZE_GemWorthArray) and their relevant worth if they are enabled.

	Example config settings for _refuel_costs, _repair_costs and _rearm_costs:

	All 3 sections can either be made free, disabled or a specifc price with the following examples:

	["Air",_freeText] will make the vehicle config class of "Air" free for the specific action.
	["Air",_disabledText] will make the vehicle config class of "Air" disabled for the specific action.
	["Air",2000] will make the vehicle config class of "Air" have a worth of 2000 for the specific action.
	["Armored_SUV_PMC",2000] will make the specific vehicle have a worth of 2000 for the specific action.
	["Armored_SUV_PMC",_freeText] will make the specific vehicle be free for the specific action.
	["Armored_SUV_PMC",_disabledText] will make the specific vehicle be disabled for the specific action.

	Valid vehicle config classes as an example: "Air", "AllVehicles", "All", "APC", "Bicycle", "Car", "Helicopter", "Land", "Motorcycle", "Plane", "Ship", "Tank"

**[>> Download <<](https://github.com/oiad/service_points/archive/master.zip)**

# Mission folder install:

1. In your \dayzinstallfolder\MPMissions\DayZ_Epoch_11.Chernarus folder (or similar), create a subfolder called "scripts/service_points" or use another name if a folder with other add-on scripts exists.

2. Download this repo by clicking on the "Clone or Download" button and then click "Download ZIP" or click: https://github.com/oiad/service_points/archive/master.zip

3. Place the files that you've downloaded below into the "scripts/service_points" folder

4. Find this line in your <code>init.sqf</code>:
	```sqf
	execFSM "\z\addons\dayz_code\system\player_monitor.fsm";
	```

	Add this line directly after it:
	```sqf
	execVM "scripts\servicePoints\init.sqf";
	```

5. Edit "scripts/servicePoints\init.sqf" and customize it to your preference.

# Battleye filter install: 

1. In your config\<yourServerName>\Battleye\scripts.txt around line 2: <code>5 addAction</code> add this to the end of it:

	```sqf
	!"_costs] call _fnc_actionTitle;\nSP_refuel_action = _vehicle addAction [_actionTitle,_folder + \"servicePointActions.sqf\",[\"refuel\""
	```

	So it will then look like this for example:

	```sqf
	5 addAction <CUT> !"_costs] call _fnc_actionTitle;\nSP_refuel_action = _vehicle addAction [_actionTitle,_folder + \"servicePointActions.sqf\",[\"refuel\""
	```
2. In your config\<yourServerName>\Battleye\scripts.txt around line 54: <code>1 nearestObjects</code> add this to the end of it:

	```sqf
	!"player;\nif (_vehicle != player) then {\n_servicePoints = (nearestObjects [getPosATL _vehicle,_servicePointClasses,_maxDistance]) "
	```
	So it will then look like this for example:
	
	```sqf
	1 nearestObjects <CUT> !"player;\nif (_vehicle != player) then {\n_servicePoints = (nearestObjects [getPosATL _vehicle,_servicePointClasses,_maxDistance]) "
	```	
3. In your config\<yourServerName>\Battleye\scripts.txt around line 85: <code>5 title</code> add this to the end of it:

	```sqf
	!"ate [\"_folder\",\"_servicePointClasses\",\"_maxDistance\",\"_actionTitleFormat\",\"_actionCostsFormat\",\"_message\",\"_messageShown\",\"_refu"
	```
	So it will then look like this for example:

	```sqf
	5 title <CUT> !"ate [\"_folder\",\"_servicePointClasses\",\"_maxDistance\",\"_actionTitleFormat\",\"_actionCostsFormat\",\"_message\",\"_messageShown\",\"_refu"
	```	
4. In your config\<yourServerName>\Battleye\scripts.txt around line 5: <code>5 addWeapon</code> add this to the end of it:

	```sqf
	!"do {_vehicle addMagazineTurret [_ammo,_turret];};\n_vehicle addWeaponTurret [\"CMFlareLauncher\",_turret];\n} else {\n{_vehicle remov"
	```
	So it will then look like this for example:

	```sqf
	5 addWeapon <CUT> !"do {_vehicle addMagazineTurret [_ammo,_turret];};\n_vehicle addWeaponTurret [\"CMFlareLauncher\",_turret];\n} else {\n{_vehicle remov"
	```		
5. In your config\<yourServerName>\Battleye\scripts.txt around line 64: <code>5 setDamage</code> add this to the end of it:

	```sqf

	!"Server \"PVDZ_veh_Save\";\n\nif (_allRepaired) then {\n_vehicle setDamage 0;\n_vehicle setVelocity [0,0,1];\n[format[localize \"STR_CL_S"
	```

	So it will then look like this for example:

	```sqf
	5 setDamage <CUT> !"Server \"PVDZ_veh_Save\";\n\nif (_allRepaired) then {\n_vehicle setDamage 0;\n_vehicle setVelocity [0,0,1];\n[format[localize \"STR_CL_S"
	```
6. In your config\<yourServerName>\Battleye\scripts.txt around line 17: <code>1 cashMoney</code> add this to the end of it:

	```sqf
	!"= [false, [], [], [], 0];\n_wealth = player getVariable [([\"cashMoney\",\"globalMoney\"] select Z_persistentMoney),0];\n\nif (Z_Single"
	```
	So it will then look like this for example:

	```sqf
	1 cashMoney <CUT> !"= [false, [], [], [], 0];\n_wealth = player getVariable [([\"cashMoney\",\"globalMoney\"] select Z_persistentMoney),0];\n\nif (Z_Single"
	```	
7. In your config\<yourServerName>\Battleye\scripts.txt around line 43: <code>1 globalMoney</code> add this to the end of it:

	```sqf
	!" [], [], 0];\n_wealth = player getVariable [([\"cashMoney\",\"globalMoney\"] select Z_persistentMoney),0];\n\nif (Z_SingleCurrency) the"
	```
	So it will then look like this for example:

	```sqf
	1 globalMoney <CUT>!" [], [], 0];\n_wealth = player getVariable [([\"cashMoney\",\"globalMoney\"] select Z_persistentMoney),0];\n\nif (Z_SingleCurrency) the"
	```		
Credits - Axe Cop, salival, Airwaves Man

# Old Releases:

**** *Epoch 1.0.6.2* ****
**[>> Download <<](https://github.com/oiad/service_points/archive/refs/tags/Epoch_1.0.6.2.zip)**



