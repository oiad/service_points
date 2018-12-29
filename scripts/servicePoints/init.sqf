/*
	Vehicle Service Point by Axe Cop
	Rewritten for single currency, gems, briefcase support and 1.0.6 epoch compatibility by salival - https://github.com/oiad/
	
	Requires DayZ Epoch 1.0.6.2

	This version adds support for both single currency and gems (from the epoch 1.0.6 update) as well as the original epoch briefcase currency system. 
	Instead of pricing things like the original way, prices are now done on a "worth" similar to how coins are done. The price value of items are below.
	
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
*/

private ["_folder","_servicePointClasses","_maxDistance","_actionTitleFormat","_actionCostsFormat","_message","_messageShown","_refuel_enable","_refuel_costs","_refuel_updateInterval","_refuel_amount","_repair_enable","_repair_costs","_repair_repairTime","_rearm_enable","_rearm_defaultcost","_rearm_costs","_rearm_magazineCount","_lastVehicle","_lastRole","_fnc_removeActions","_fnc_getCostsWep","_fnc_getCostsWep","_fnc_actionTitle","_fnc_isArmed","_fnc_getWeapons","_rearm_ignore","_cycleTime","_servicePoints","_vehicle","_role","_costs","_actionTitle","_weapons","_weaponName","_disabledText","_freeText"];

diag_log "Service Points: loading config...";

// general settings
_folder = "scripts\servicePoints\"; // folder where the service point scripts are saved, relative to the mission file
_servicePointClasses = ["Map_A_FuelStation_Feed","Land_A_FuelStation_Feed","FuelPump_DZ"]; // service point classes, You can also use dayz_fuelpumparray by its self for all the default fuel pumps.
_maxDistance = 50; // maximum distance from a service point for the options to be shown
_actionTitleFormat = "%1 (%2)"; // text of the vehicle menu, %1 = action name (Refuel, Repair, Rearm), %2 = costs (see format below)
_actionCostsFormat = "%2 %1"; // %1 = item name, %2 = item count
_message = localize "STR_CL_SP_MESSAGE"; // This is translated from your stringtable.xml in your mission folder root. Set to "" to disable
_cycleTime = 5; // Time in sections for how often the action menu will be refreshed and how often it will search for a nearby fuel station (setting this too low can make a lot of lag)
_disabledText = (localize "str_temp_param_disabled"); // Disabled text to show up when items are disabled, DO NOT CHANGE.
_freeText = (localize "strwffree"); // Free text to show up when items are free, DO NOT CHANGE.

// refuel settings
_refuel_enable = true; // enable or disable the refuel option
_refuel_costs = [
	["Land",_freeText], // All vehicles are free to refuel.
	["Air",1000] //1000 worth is 1 10oz gold for all air vehicles
];
_refuel_updateInterval = 1; // update interval (in seconds)
_refuel_amount = 0.05; // amount of fuel to add with every update (in percent)

// repair settings
_repair_enable = true; // enable or disable the repair option
_repair_repairTime = 2; // time needed to repair each damaged part (in seconds)
_repair_costs = [
	["Air",4000], // 4000 worth is 4 10oz gold.
	["AllVehicles",2000] // 2000 worth is 2 10oz gold for all other vehicles
];

// rearm settings
_rearm_enable = true; // enable or disable the rearm option
_rearm_defaultcost = 10000; // Default cost to rearm a weapon. (10000 worth == 1 briefcase)
_rearm_magazineCount = 2; // amount of magazines to be added to the vehicle weapon
_rearm_ignore = [(localize "str_dn_horn"),(localize "str_dn_laser_designator")]; // Array of weapon display names that are ignored in the rearm listing.

/*
	_ream_costs is an array based on the AMMO type. I.e M240, MK19, PKM, PKT, M134 etc. 
	You can disable certain ammo types from being able to be rearmed by making the price _disabledText
	example: ["M134",_disabledText]
*/

_rearm_costs = [
	["GRAD",500000], // BM-21 Grad (ammo fixed?)
	["MLRS",500000], // MLRS
	["FlareLauncher",500], // Flares
	["SmokeLauncher",500], // Smokes
	["2A46M",250000], // 2A46M Cannon T-90
	["2A70",200000], // 2A70 100mm BMP3
	["D10",150000], // D-10 T-55
	["ZiS_S_53",100000], // ZiS-S-53 T-34
	["D81",200000], // D-81 T-72
	["M68",150000], // M68 MGS
	["M256",200000], // M256 M1Abrams
	["GSh301",50000], // GSh-301
	["GSh302",100000], // GSh-301
	["GSh23L",50000], // GSh-23L
	["GAU8",150000], // GAU-8
	["GAU12",50000], // GAU-12
	["GAU22",50000], // GAU-22 no localization available
	["M60",5000], // M60 no localization available
	["2A38M",50000], // 2A38M Gun
	["2A42",50000], // 2A42
	["2A72",50000], // 2A72 30mm
	["M621",50000], // M621
	["CTWS",50000], // CTWS
	["M230",50000], // M230
	["M197",50000], // M197
	["M242",50000], // M242
	["2A14",5000], // AZP-23 (40rnd)
	["AZP85",20000], // AZP-23
	["YakB",10000], // Yak-B
	["M134",10000], // M134
	["KORD",5000], // KORD
	["DSHKM",5000], // DSHKM
	["M3P",15000], // M3P
	["M2",5000], // M2 Machinegun
	["KPVT",50000], // KPVT
	["AGS17",10000], // AGS-17
	["AGS30",5000], // AGS-30
	["M32_heli",5000], // M32
	["MK19",5000], // Mk19
	["BAF_L94A1",10000], // L94A1 Chain Gun
	["SGMT",5000], // SGMT no localization available
	["DT_veh",5000], // DT
	["PKT_veh",5000], // PKM
	["PKT",5000], // PKT
	["M240_veh",5000], // M240
	["2A70Rocket",150000], // 9M117M1 Arkan
	["2A46MRocket",150000], // 9M119M Refleks rocket
	["S8Launcher",100000], // S-8
	["80mmLauncher",50000], // S-8
	["57mmLauncher_128",400000], // S-5
	["57mmLauncher_64",200000], // S-5
	["57mmLauncher",500000], // S-5
	["FFARLauncher_14",50000], // Hydra
	["FFARLauncher",100000], // Hydra
	["VikhrLauncher",500000], // Vikhr 9A121
	["AT9Launcher",450000], // Ataka-V 9M120
	["AT6Launcher",350000], // Shturm 9K114
	["AT5Launcher",250000], // Konkurs 9M113
	["AT2Launcher",150000], // Falanga 3M11
	["CRV7_PG",500000], // CRV7
	["HellfireLauncher",500000], // AGM-114 Hellfire
	["TOWLauncherSingle",350000], // M220 TOW
	["TOWLauncher",150000], // M220 TOW
	["MaverickLauncher",500000], // AGM-65 Maverick
	["Ch29Launcher_Su34",500000], // Kh-29L
	["Ch29Launcher",400000], // Kh-29L
	["SidewinderLaucher_AH64",700000], // AIM-9L Sidewinder
	["SidewinderLaucher_AH1Z",300000], // AIM-9L Sidewinder
	["SidewinderLaucher",500000], // AIM-9L Sidewinder
	["R73Launcher_2",300000], // R-73
	["R73Launcher",500000], // R-73
	["9M311Laucher",500000], // Tunguska 9M311
	["StingerLauncher_twice",300000], // FIM-92F Stinger
	["Igla_twice",300000], // Igla
	["D30",300000], // D-30
	["M119",300000], // M119
	["SPG9",1000], // SPG-9
	["BombLauncherF35",15000], // GBU-12
	["Mk82_BombLauncher",15000], // GBU-12
	["bombLauncher",15000], // GBU-12
	["AirBombLauncher",7500], // FAB-250
	["HeliBombLauncher",2500], // FAB-250
	["CamelGrenades",2000], // Grenade

	["MissileLauncher",500000],
	["RocketPods",100000],
	["CannonCore",50000],
	["Mgun",5000]
];

_lastVehicle = objNull;
_lastRole = [];
_messageShown = false;

SP_refuel_action = -1;
SP_repair_action = -1;
SP_rearm_actions = [];

_fnc_removeActions = {
	if (isNull _lastVehicle) exitWith {};
	_lastVehicle removeAction SP_refuel_action;
	SP_refuel_action = -1;
	_lastVehicle removeAction SP_repair_action;
	SP_repair_action = -1;
	{
		_lastVehicle removeAction _x;
	} forEach SP_rearm_actions;
	SP_rearm_actions = [];
	_lastVehicle = objNull;
	_lastRole = [];
};

_fnc_getCosts = {
	private ["_getVehicle","_getCosts","_cost","_getTypeName"];
	_getVehicle = _this select 0;
	_getCosts = _this select 1;
	_cost = [];
	{
		_getTypeName = _x select 0;
		if (_getVehicle isKindOf _getTypeName) exitWith {
			_cost = _x select 1;
		};
	} forEach _getCosts;
	_cost
};

_fnc_getCostsWep = {
	private ["_weapon","_getCostsWep","_returnCostWep","_typeName"];
	_weapon = _this select 0;
	_getCostsWep = _this select 1;
	_returnCostWep = _rearm_defaultcost;
	{
		_typeName = _x select 0;
		if (_weapon isKindOf _typeName) exitWith {
			_returnCostWep = _x select 1;
		};
	} forEach _getCostsWep;
	_returnCostWep
};

_fnc_actionTitle = {
	private ["_actionName","_actionCosts","_costsText","_return"];
	_actionName = _this select 0;
	_actionCosts = _this select 1;
	if (typeName _actionCosts == "STRING") then {
		_costsText = _actionCosts; 
	} else {
		_costsText = if (Z_SingleCurrency) then {format ["%1 %2",[_actionCosts] call BIS_fnc_numberText,CurrencyName]} else {format ["%1",[_actionCosts,true] call z_calcCurrency]};
	};
	_return = format [_actionTitleFormat,_actionName,_costsText];
	_return
};

_fnc_getWeapons = {
	private ["_gWeaponsVehicle","_gWeaponsRole","_gWeapons","_gWeaponName","_gTurret","_gWeaponsTurret"];
	_gWeaponsVehicle = _this select 0;
	_gWeaponsRole = _this select 1;
	_gWeapons = [];
	if (count _gWeaponsRole > 1) then {
		_gTurret = _gWeaponsRole select 1;
		_gWeaponsTurret = _gWeaponsVehicle weaponsTurret _gTurret;
		{
			_gWeaponName = getText (configFile >> "CfgWeapons" >> _x >> "displayName");
			if !(_gWeaponName in _rearm_ignore) then {
				_gWeapons set [count _gWeapons, [_x,_gWeaponName,_gTurret]];
			}; 
		} forEach _gWeaponsTurret;
	};
	_gWeapons
};

while {true} do {
	_vehicle = vehicle player;
	if (_vehicle != player) then {
		_servicePoints = (nearestObjects [getPosATL _vehicle,_servicePointClasses,_maxDistance]) - [_vehicle];
		if (count _servicePoints > 0) then {
			if (assignedDriver _vehicle == player) then {
				_role = ["Driver", [-1]];
			} else {
				_role = assignedVehicleRole player;
			};
			if (((str _role) != (str _lastRole)) || {_vehicle != _lastVehicle}) then {
				call _fnc_removeActions;
			};
			_lastVehicle = _vehicle;
			_lastRole = _role;
			if ((SP_refuel_action < 0) && {_refuel_enable}) then {
				_costs = [_vehicle,_refuel_costs] call _fnc_getCosts;
				_actionTitle = [localize "config_depot.sqf8",_costs] call _fnc_actionTitle;
				SP_refuel_action = _vehicle addAction [_actionTitle,_folder + "servicePointActions.sqf",["refuel",_costs,_refuel_updateInterval,_refuel_amount],-1,false,true];
			};
			if ((SP_repair_action < 0) && {_repair_enable}) then {
				_costs = [_vehicle,_repair_costs] call _fnc_getCosts;
				_actionTitle = [localize "config_depot.sqf1",_costs] call _fnc_actionTitle;
				SP_repair_action = _vehicle addAction [_actionTitle,_folder + "servicePointActions.sqf",["repair",_costs,_repair_repairTime],-1,false,true];
			};
			if ((count _role > 1) && {count SP_rearm_actions == 0} && {_rearm_enable}) then {
				_weapons = [_vehicle,_role] call _fnc_getWeapons;
				{
					_weaponName = _x select 1;
					_costs = [_x select 0,_rearm_costs] call _fnc_getCostsWep;
					_actionTitle = [format["%1 %2",localize "config_depot.sqf5",_weaponName],_costs] call _fnc_actionTitle;
					SP_rearm_action = _vehicle addAction [_actionTitle,_folder + "servicePointActions.sqf",["rearm",_costs,_rearm_magazineCount,_x],-1,false,true];
					SP_rearm_actions set [count SP_rearm_actions, SP_rearm_action];
				} forEach _weapons;
			};
			if (!_messageShown && {_message != ""}) then {
				_messageShown = true;
				_vehicle vehicleChat _message;
			};
		} else {
			call _fnc_removeActions;
			_messageShown = false;
		};
	} else {
		call _fnc_removeActions;
		_messageShown = false;
	};
	uiSleep _cycleTime;
};
