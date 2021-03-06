#include "script_component.hpp"
/*
    Part of the TBMod ( https://github.com/TacticalBaconDevs/TBMod )
    Developed by http://tacticalbacon.de
*/
class CfgPatches
{
    class ADDON
    {
        name = "TBMod ZeusModules";

        units[] = {
            "TB_zeus_base",
            "TB_zeus_nachschubAbwurf",
            "TB_zeus_disablePath",
            "TB_zeus_prioSichtbarkeit",
            "TB_zeus_handleAsPlayerMedical",
            "TB_zeus_applyLoadout",
            "TB_zeus_handleAsPlayerMedical",
            "TB_zeus_moduleUnflipVehicle",
            "TB_zeus_adjustAceCargo",
            "TB_zeus_limitDamage",
            "TB_zeus_switchMove",
            "TB_zeus_defineAmmo",
            QGVAR(base),
            QGVAR(createTransmitter),
            QGVAR(setViewDistance)
        };

        requiredAddons[] = {
            "TBMod_main",
            "TBMod_nachschub"
        };
        addonRootClass = "TBMod_main";
    };
};

PRELOAD_ADDONS;

// Configs
#include "configs\CfgVehicles.hpp"
#include "configs\ExtendedEventHandlers.hpp"
#include "configs\CfgFactionClasses.hpp"
#include "configs\ACE_ZeusActions.hpp"
#include "configs\CfgFunctions.hpp"