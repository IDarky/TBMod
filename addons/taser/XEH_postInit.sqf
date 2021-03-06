#include "script_component.hpp"
/*
    Part of the TBMod ( https://github.com/TacticalBaconDevs/TBMod )
    Developed by http://tacticalbacon.de
*/
["CAManBase", "HitPart", {
    {
        _x params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"];

        if (typeOf _projectile == "tb_ammo_taser") exitWith
        {
            if (_target != _shooter) then {[_target, [2, 0] select (isPlayer _target), 1] remoteExec ["rhs_fnc_flashbang_effect", _target]};
            [_target, true, 20, true] call ace_medical_fnc_setUnconscious;

            ["TB_informAdminsAndZeus", ["%1 hat %2 getasert!", [_shooter] call ace_common_fnc_getName, [_target] call ace_common_fnc_getName]] call CBA_fnc_globalEvent;
        };
    }
    forEach _this;
}] call CBA_fnc_addClassEventHandler;
