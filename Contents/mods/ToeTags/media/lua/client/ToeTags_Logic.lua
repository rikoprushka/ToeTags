require "ToeTags_ModOptions";

-- Imported/Modified from lua/client/XpSystem/ISUI/ISCharacterScreen.lua
-- embedding causes errors, easier to just C/P the one function we need
local function GetDeadPlayerFavoriteWeapon(player)
    local favoriteWeapon = nil;
    local swing = 0;
    for iPData,vPData in pairs(player:getModData()) do
		for index in string.gmatch(iPData, "^Fav:(.+)") do
			if vPData > swing then
				favoriteWeapon = index;
				swing = vPData;
			end
		end
	end
    if favoriteWeapon == nil then 
        return getText("UI_trait_Pacifist");
    else
        return favoriteWeapon;
    end
end

-- ---------------------------------------------------- --
-- -- CreateToeTagOnDeadPlayerWithOptions(player) ----- --
-- --   Populates a toe tag's data and title and places it in the player's
-- --   inventory when requested.  Fully translated through IG_UI_EN.txt
-- --   @params     required        IsoCharacter
-- --   @returns    nothing
-- ---------------------------------------------------- --
local function CreateToeTagOnPlayerWithOptions(player)
    -- Only do it if you're a player character AND the player at the keyboard, not others
    if not instanceof(player, "IsoPlayer") or not player:isLocalPlayer() then return; end;

    -- ---------------------------------------------------- --
    -- Variable Declarations ------------------------------ --
    -- ---------------------------------------------------- --
    local ToeTagTitle = "";             -- The Item Name
    local ToeTagNote = "";              -- The Details / Read list

    -- ---------------------------------------------------- --
    -- Populate the Toe Tag Name -------------------------- --
    -- ---------------------------------------------------- --
    if ToeTagOptions.options.advancedTitle then 
        ToeTagTitle = getText("IGUI_ToeTag_ItemNameSorted", player:getFullName(), string.format("%08.2f", player:getHoursSurvived()));
    else
        ToeTagTitle = getText("IGUI_ToeTag_ItemName", player:getFullName());
    end

    -- ---------------------------------------------------- --
    -- Populate the Toe Tag Details ----------------------- --
    -- ---------------------------------------------------- --
    -- Record Username?
    if ToeTagOptions.options.recordAccount then 
        ToeTagNote = ToeTagNote .. getText("IGUI_PlayerStats_Username") .. " " .. player:getUsername() .. "\n";
    end

    -- Record Profession?
    if ToeTagOptions.options.recordProfession then
        local profession = ProfessionFactory.getProfession(player:getDescriptor():getProfession());         
        if profession then 
            profession = profession:getName();
        else
            profession = getText("UI_FriendState_Unknown");
        end
        ToeTagNote = ToeTagNote ..  getText("IGUI_PlayerStats_Profession") .. " " .. profession .. "\n";
    end

    -- Record Death Date?
    if ToeTagOptions.options.recordDeathDate then
        ToeTagNote = ToeTagNote .. getText("IGUI_ToeTag_Died", getGameTime():getCalender():getTime()) .. "\n";
    end

    -- Record Survival Time?
    if ToeTagOptions.options.recordSurvived then
        ToeTagNote = ToeTagNote .. getText("IGUI_char_Survived_For") .. ": " .. player:getTimeSurvived() .. "\n";
    end

    -- Record Favorite Weapon?
    if ToeTagOptions.options.recordFavWeapon then
        ToeTagNote = ToeTagNote .. getText("IGUI_char_Favourite_Weapon") .. ": " .. GetDeadPlayerFavoriteWeapon(player) .. "\n";
    end

    -- Record Kill Count?
    if ToeTagOptions.options.recordKillCount then
        ToeTagNote = ToeTagNote .. getText("IGUI_char_Zombies_Killed") .. ": " .. player:getZombieKills() .. "\n";
    end
    
    -- Record Infected ?
    if ToeTagOptions.options.recordInfected then 
        if player:getBodyDamage():getInfectionLevel() > 0 then
            ToeTagNote = ToeTagNote .. getText("IGUI_ToeTag_Infected") .. "\n";
        else
            ToeTagNote = ToeTagNote .. getText("IGUI_ToeTag_NotInfected") .. "\n";
        end
    end

    -- ---------------------------------------------------- --
    -- If all options are disabled, just write "Deceased" - --
    -- ---------------------------------------------------- --
    if ToeTagNote == "" then ToeTagNote = getText("IGUI_health_Deceased"); end

    -- ---------------------------------------------------- --
    -- Add Toe Tag to the player inventory and write the data
    -- Lock the page with a non-existant account (can not edit)
    -- ---------------------------------------------------- --
    local item = player:getInventory():AddItem("Base.ToeTag");
    item:setName(ToeTagTitle)
    item:addPage(1, ToeTagNote)
    item:setLockedBy("GrimReaper#" .. getGametimeTimestamp());
end

-- ---------------------------------------------------- --
-- -- ON DEATH ADD TOE TAG ---------------------------- --
-- ---------------------------------------------------- --
Events.OnCharacterDeath.Add(CreateToeTagOnPlayerWithOptions)

-- ---------------------------------------------------- --
-- -- DEBUG ------------------------------------------- --
-- ---------------------------------------------------- --
-- Events.OnWeaponSwing.Add(CreateToeTagOnPlayerWithOptions)
-- ---------------------------------------------------- --
