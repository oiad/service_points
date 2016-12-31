# Service Points
Axe Cops service point script updated for 1.0.6 by salival

Discussion thread on EpochMod: https://epochmod.com/forum/topic/43075-release-vehicle-service-point-refuel-repair-rearm-updated-for-106/

	(original github url: https://github.com/vos/dayz/tree/master/service_point)
	(original install/discussion url: https://epochmod.com/forum/topic/3935-release-vehicle-service-point-refuel-repair-rearm-script/)
	
**** *REQUIRES DAYZ EPOCH 1.0.6* ****
	
Major Changes:

	This version adds support for both single currency and gems (from the epoch 1.0.6 update) as well as the original epoch briefcase currency system. 
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

	["Air","free"] will make the vehicle config class of "Air" free for the specific action.
	["Air","disabled"] will make the vehicle config class of "Air" disabled for the specific action.
	["Air",2000] will make the vehicle config class of "Air" have a worth of 2000 for the specific action.
	["Armored_SUV_PMC",2000] will make the specific vehicle have a worth of 2000 for the specific action.
	["Armored_SUV_PMC","free"] will make the specific vehicle be free for the specific action.
	["Armored_SUV_PMC","disabled"] will make the specific vehicle be disabled for the specific action.

	Valid vehicle config classes as an example: "Air", "AllVehicles", "All", "APC", "Bicycle", "Car", "Helicopter", "Land", "Motorcycle", "Plane", "Ship", "Tank"

Installation Steps -

1) In your \dayzinstallfolder\MPMissions\dayz_1.Chernarus folder (or similar), create a subfolder called "scripts/service_points" or use another name if a folder with other add-on scripts exists.

2) Download this repo by clicking on the "Clone or Download" button and then click "Download ZIP" or click: https://github.com/oiad/service_points/archive/master.zip

3) Place the files that you've downloaded below into the "scripts/service_points" folder

4) Add this to your init.sqf in the "if (!isDedicated) then { PUT HERE SOMEWHERE (at the end is ok) }" block (so it will only be started on your client and not the server):

	if (!isDedicated) then {
		// ... some other stuff ...
		// add the next line somewhere in this block
		execVM "service_point\service_point.sqf";
	};

5) Edit "scripts/service_points/service_point.sqf" and customize it to your preference.
	
6) You're done! enjoy the new script! :)

Credits - Axe Cop, salival
