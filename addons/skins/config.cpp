#include "script_component.hpp"
/*
    Part of the TBMod ( https://github.com/TacticalBaconDevs/TBMod )
    Developed by http://tacticalbacon.de
*/
class CfgPatches
{
    class ADDON
    {
        name = "TBMod Skins";
        author = "Eric";

        weapons[] = {
            "TB_Uniform_SEK_U",
            "TB_Uniform_Kommissar_U",
            "TB_Uniform_Polizist_U",
            "TB_Uniform_presi_U",
            "TB_Uniform_IS_1_black_U"
        };

        vehicles[] = {
            "TB_Uniform_Sek",
            "TB_Uniform_Kommissar",
            "TB_Uniform_rekrut",
            "TB_Uniform_presi",
            "TB_Soldier_IS_1_black",
            "TB_Vehicles_sek_light",
            "TB_Vehicles_polizei_hellcat",
            "TB_Vehicles_sek_hellcat",
            "TB_Vehicles_polizei_hunter",
            "TB_Vehicles_T100"
        };

        requiredAddons[] = {
            "TBMod_main"
        };
        addonRootClass = "TBMod_main";
    };
};

PRELOAD_ADDONS;

// Configs
#include "configs\CfgVehicles.hpp"
#include "configs\CfgWeapons.hpp"
#include "configs\CfgEditorCategories.hpp"
#include "configs\CfgEditorSubcategories.hpp"
