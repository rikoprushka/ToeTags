-- Default Configurations for ModOptions
local ToeTagSettings = {
    options_data = {
        advancedTitle = {
            name = "IGUI_ToeTag_Options_AdvancedTitle",
            tooltip = "IGUI_ToeTag_Options_AdvancedTitle_Tooltip",
            default = false,
        },
        recordAccount = {
            name = "IGUI_ToeTag_Options_RecordAccount",
            tooltip = "IGUI_ToeTag_Options_RecordAccount_Tooltip",
            default = false,
        },
        recordProfession = {
            name = "IGUI_ToeTag_Options_RecordProfession",
            tooltip = "IGUI_ToeTag_Options_RecordProfession_Tooltip",
            default = true,
        },
        recordDeathDate = {
            name = "IGUI_ToeTag_Options_RecordDeathDate",
            tooltip = "IGUI_ToeTag_Options_RecordDeathDate_Tooltip",
            default = true,
        },
        recordSurvived = {
            name = "IGUI_ToeTag_Options_RecordSurvived",
            tooltip = "IGUI_ToeTag_Options_RecordSurvived_Tooltip",
            default = true,
        },
        recordFavWeapon = {
            name = "IGUI_ToeTag_Options_RecordFavWeapon",
            tooltip = "IGUI_ToeTag_Options_RecordFavWeapon_Tooltip",
            default = true,
        },
        recordKillCount = {
            name = "IGUI_ToeTag_Options_RecordKillCount",
            tooltip = "IGUI_ToeTag_Options_RecordKillCount_Tooltip",
            default = true,
        },
        recordInfected = {
            name = "IGUI_ToeTag_Options_RecordInfection",
            tooltip = "IGUI_ToeTag_Options_RecordInfection_Tooltip",
            default = true,
        },
        recordTraits = {
            name = "IGUI_ToeTag_Options_RecordTraits",
            tooltip = "IGUI_ToeTag_Options_RecordTraits_Tooltip",
            default = false,
        }
    },
    mod_id = "ToeTags",
    mod_shortname = getText("IGUI_ToeTag_Options_NameShort"),
    mod_fullname = getText("IGUI_ToeTag_Options_NameLong"),
};

-- If ModOptions is installed, LOAD USER'S SETTINGS
-- Otherwise if no ModOptions, use my defaults
if ModOptions and ModOptions.getInstance then
    ToeTagOptions = ModOptions:getInstance(ToeTagSettings);
else
    ToeTagOptions = {
        options = {
            advancedTitle = false,
            recordAccount = false,
            recordProfession = true,
            recordDeathDate = true,
            recordFavWeapon = true,
            recordKillCount = true,
            recordSurvived = true,
            recordInfected = true,
            recordTraits = false,
        }
    };
end
