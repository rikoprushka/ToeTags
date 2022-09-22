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

-- Create the ToeTag in the Dead Player's Inventory
local function CreateToeTagOnDeadPlayer(player)
    -- Only do this for players, and only the player is that playing (mp)
    if not instanceof(player, "IsoPlayer") or not player:isLocalPlayer() then return; end;

    -- Gather some information about our dead player
    local gameTime = getGameTime();
    local infectedText = nil;
    if player:getBodyDamage():getInfectionLevel() > 0 then 
        infectedText = "IGUI_ToeTag_Infected";
    else
        infectedText = "IGUI_ToeTag_NotInfected";
    end

    -- Populate the item Name
    local itemName = "IGUI_ToeTag_ItemName";
    if getActivatedMods():contains("ToeTagsSorted") then
        itemName = "IGUI_ToeTag_ItemNameSorted";
    end
    itemName = getText(itemName, 
                       player:getFullName(),
                       string.format("%08.2f", player:getHoursSurvived())
               );
    
    -- Request the human-readable title for the profession through Profession Factory
    -- If you don't use Profession factory, you get the StringID of the profession (e.g.: fisherman)
    -- which then can be loaded through the Profession Factory to get the proper translated profession (e.g.: Pescador [Spanish])
    -- In the event of an unknown or incorrect ID, just use the "Unknown" translation
    local profession = ProfessionFactory.getProfession(player:getDescriptor():getProfession());
    if profession then 
        profession = profession:getName();
    else
        profession = getText("UI_FriendState_Unknown");
    end

    -- Prepare the Toe Tag Details
    local details = getText("IGUI_PlayerStats_Username") .. " " .. player:getUsername() .. "\n" .. 
                    getText("IGUI_PlayerStats_Profession") .. " " .. profession .. "\n" ..
                    getText("IGUI_ToeTag_Died", gameTime:getCalender():getTime()) .. "\n" .. 
                    "\n" .. 
                    getText("IGUI_char_Favourite_Weapon") .. ": " .. GetDeadPlayerFavoriteWeapon(player) .. "\n" .. 
                    getText("IGUI_char_Survived_For") .. ": " .. player:getTimeSurvived() .. "\n" ..
                    getText("IGUI_char_Zombies_Killed") .. ": " .. player:getZombieKills() .. "\n" .. 
                    "\n" ..
                    getText(infectedText)
                ;

    -- Add Toe Tag to the player inventory and write the data
    local item = player:getInventory():AddItem("Base.ToeTag");
    item:setName(itemName)
    item:addPage(1, details)

    -- Lock the page with a non-existant account so that you can not edit the data
    -- nor use it as a blank piece of paper. Toe tags are technically just paper notes
    item:setLockedBy("GrimReaper#" .. getGametimeTimestamp());
end
Events.OnCharacterDeath.Add(CreateToeTagOnDeadPlayer)

-- -------------------------------------------------- --
-- -- DEBUG ----------------------------------------- --
-- -------------------------------------------------- --
-- Events.OnWeaponSwing.Add(CreateToeTagOnDeadPlayer)
-- -------------------------------------------------- --
