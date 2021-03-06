#include "../script_component.hpp"
/*
    Part of the TBMod ( https://github.com/TacticalBaconDevs/TBMod )
    Developed by http://tacticalbacon.de

    ToDo:
    - Unsung Minen sind CfgAmmos auf dem Boden
        - zu finden per Default das ist dan aber alle CfgWeapons (allMissionObjects "Default")
    - minen werden als Modul gesetzt... die Mine ist eine _ammo und das Modul der sichtbare Bubble
*/
params [
        ["_save", false, [false]],
        ["_name", "", [""]],
        ["_transfer", false, [false]],
        ["_overwriteLocal", false, [false]]
    ];

if (!isServer && !_overwriteLocal) exitWith {"[TBMod_persistence] NUR auf dem Server ausführen" remoteExecCall ["systemChat"]};
if (!canSuspend) exitWith {"[TBMod_persistence] Skript muss per SPAWN ausgeführt werden" remoteExecCall ["systemChat"]};
if (_name == "") exitWith {"[TBMod_persistence] Kein Name angegeben" remoteExecCall ["systemChat"]};

EGVAR(tasks,pause) = true;

if (_save) then
{
    private _saveArray = [
        [],     // disconnectCache
        [],     // Markers
        [],     // Objects
        [],     // Vehicles
        []      // Tasks
    ];

    // save current players
    _saveArray set [0, [_save] call FUNC(persistencePlayers)];

    // save marker
    _saveArray set [1, [_save] call FUNC(persistenceMarkers)];

    // save objects
    _saveArray set [2, [_save] call FUNC(persistenceObjects)];

    // save vehicles
    _saveArray set [3, [_save] call FUNC(persistenceVehicles)];
    
    // save tasks
    _saveArray set [4, [_save] call FUNC(persistenceTasks)];

    // save storagearray
    profileNamespace setVariable [format ["TBMod_persistence_%1", _name], _saveArray];

    private _names = profileNamespace getVariable [QGVAR(savedNames), []];
    _names pushBackUnique _name;
    profileNamespace setVariable [QGVAR(savedNames), _names];

    saveProfileNamespace;
    if (_transfer && !_overwriteLocal && isDedicated) then {
        [_name, false] call FUNC(transferManager);
    };
}
else // load
{
    if (_overwriteLocal) exitwith {systemChat "[TBMod_persistence] Speicherstand kann nicht geladen werden. Grund: _overwriteLocal == true"};
    if (_transfer && isDedicated) then {
        [_name, true] call FUNC(transferManager);
    };

    private _loadArray = profileNamespace getVariable [format ["TBMod_persistence_%1", _name], [[], [], [], [], []]];

    private _objArray = (allMissionObjects "Static") + (allMissionObjects "Thing") + vehicles;
    _objArray = _objArray arrayIntersect _objArray;

    // vorhandene nicht benannte Fahrzeuge löschen
    (_objArray select {vehicleVarName _x == "" && _x getVariable ["ace_arsenal_virtualitems", []] isEqualTo []}) call CBA_fnc_deleteEntity;

    // benannte Fahrzeuge simulation temp deaktivieren
    TB_persistence_tempSimulationDisabled = [];
    {
        _x enableSimulationGlobal false;
        TB_persistence_tempSimulationDisabled pushBackUnique _x;
    }
    forEach (_objArray select {vehicleVarName _x != "" && simulationEnabled _x});

    // ki/units simulation deaktivieren
    TB_persistence_tempSimulationDisabled = [];
    {
        _x enableSimulationGlobal false;
        TB_persistence_tempSimulationDisabled pushBackUnique _x;
    }
    forEach (allunits select {simulationEnabled _x});

    // Marker laden
    [_save, _loadArray select 1] call FUNC(persistenceMarkers);

    // das Löschen der Fahrzeuge dauert etwas, um Explosionen zu verhindern kurz warten
    uiSleep 1;

    // Objekte laden
    [_save, _loadArray select 2] call FUNC(persistenceObjects);

    uiSleep 1;

    // Fahrzeuge organisieren
    [_save, _loadArray select 3] call FUNC(persistenceVehicles);

    uiSleep 1;
    
    // Tasks laden
    [_save, _loadArray select 4] call FUNC(persistenceTasks);

    uiSleep 1;

    // temp silumlierte Objekte wieder zurücksetzen
    {_x enableSimulationGlobal true} forEach TB_persistence_tempSimulationDisabled;

    uiSleep 1;

    // Teleport players
    [_save, _loadArray select 0] call FUNC(persistencePlayers);
};
EGVAR(tasks,pause) = false;

(format ["[TBMod_persistence] Es wurde Slot %1 ge%2.", _name, ["laden", "speichert"] select _save]) remoteExecCall ["systemChat"];
