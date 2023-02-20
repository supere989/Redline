-- Author      : Xandre-Whitemane
-- Create Date : 2/19/2023 10:06:05 PM

function UpdatePowerValues()
    -- Get the current player's class and spec
local class, _, spec = UnitClass("player")

    local baseAttackPower, posAttackPower, negAttackPower = UnitAttackPower("player")
    local totalAttackPower = baseAttackPower + posAttackPower - negAttackPower
    local baseSpellPower = GetSpellBonusDamage(2) or 0
    local posSpellPower = {}
    local posSpellHealing = GetSpellBonusHealing() or 0
    local negSpellPenetration = -GetSpellPenetration() or 0


    for i = 2, 7 do
        local bonusDamage = GetSpellBonusDamage(i)
        if bonusDamage then
            if bonusDamage > 0 then
                posSpellPower[i] = bonusDamage
            end
        end
    end

local spellPower, attackPower = 0, 0

local function getPaladinRetributionSpellPowerAndAttackPower()
    return (posSpellPower[2] or 0), totalAttackPower
end

local function getPaladinProtectionSpellPowerAndAttackPower()
    return (posSpellPower[2] or 0), totalAttackPower
end

local function getPaladinHolySpellPowerAndAttackPower()
    return (posSpellPower[2] or 0), 0
end

local function getMageFireSpellPowerAndAttackPower()
    return (posSpellPower[3] or 0), totalAttackPower
end

local function getMageFrostSpellPowerAndAttackPower()
    return (posSpellPower[5] or 0), totalAttackPower
end

local function getMageArcaneSpellPowerAndAttackPower()
    return (posSpellPower[2] or 0), totalAttackPower
end

-- Add functions for the other classes and specializations here

-- Then, you can create a function that selects the appropriate function based on the current class and specialization:
local function getSpellPowerAndAttackPower()
    if class == "PALADIN" and spec == 3 then
        return getPaladinRetributionSpellPowerAndAttackPower()
    elseif class == "PALADIN" and spec == 2 then
        return getPaladinProtectionSpellPowerAndAttackPower()
    elseif class == "PALADIN" and spec == 1 then
        return getPaladinHolySpellPowerAndAttackPower()
    elseif class == "MAGE" and spec == 3 then
        return getMageFireSpellPowerAndAttackPower()
    elseif class == "MAGE" and spec == 2 then
        return getMageFrostSpellPowerAndAttackPower()
    elseif class == "MAGE" and spec == 1 then
        return getMageArcaneSpellPowerAndAttackPower()
    -- Add cases for the other classes and specializations here
    else
        return 0, 0 -- Return default values if the class and specialization is not recognized
    end
end

local spellPower, attackPower = getSpellPowerAndAttackPower()

local spellPowerTable = {}
spellPowerTable[1] = "|cFF0099FFSpell Power:|r " .. spellPower
spellPowerTable[2] = "|cFFFF0000Attack Power:|r " .. attackPower
spellPowerTable[3] = "|cFFFFA500Penetration:|r " .. negSpellPenetration
spellPowerTable[4] = "|cFFFFD100Healing:|r " .. posSpellHealing
spellPowerTable[5] = "Agility: " .. (UnitStat("player", 2) or 0)
spellPowerTable[6] = "|cFFFFFFFFIntellect: " .. (UnitStat("player", 4) or 0)
spellPowerTable[7] = "|cFFFF0000Strength:|r " .. (UnitStat("player", 1) or 0)



    local totalSpellPower = baseSpellPower + (posSpellPower[2] or 0) + (posSpellPower[3] or 0) + (posSpellPower[5] or 0) + (posSpellPower[6] or 0) + (posSpellPower[7] or 0) + posSpellHealing + negSpellPenetration

    local attackPowerColor = "|cFFFF0000"
    local spellPowerColor = "|cFF0099FF"
    local healingPowerColor = "|cFF00FF00"
    local strenthPowerColor = "|cFFFF0000"

    if totalAttackPower > baseAttackPower then
        attackPowerColor = "|cFFFFFF00"
    end

    if totalSpellPower > baseSpellPower then
        spellPowerColor = "|cFF0099FF"
    end
    Frame1.attackPowerText:SetText("AttackPower: " .. attackPowerColor .. totalAttackPower .. "|r")
    Frame1.spellPowerText:SetText("|cFF0099FFSpellPower: " .. spellPowerColor .. baseSpellPower .. "|r")
    Frame1.healingPowerText:SetText("|cFF00FF00Healing: " .. healingPowerColor .. posSpellHealing .. "|r")
    Frame1.unitStatStrengthText:SetText(strenthPowerColor .. spellPowerTable[7])
    Frame1.unitStatIntellectText:SetText(spellPowerTable[6])
    Frame1.unitStatAgilityText:SetText(spellPowerTable[5])

end



function Frame1_Onload()
    local font = "Fonts\\FRIZQT__.TTF"
    local fontSize = 12
-- Get the current player's class and spec then output to Console
	local class, _, spec = UnitClass("player")
print("Class: " .. class)
print("Spec: " .. spec)

    -- Define the slash command variations
    SLASH_RedLine1 = "/RedLine"
    SLASH_RedLine2 = "/redline"
    SLASH_RedLine3 = "/redLine"
    SLASH_RedLine4 = "/rln"

local function SlashCommandHandler(arg)
    if arg == "attack" then
        ToggleDisplay(true)
    elseif arg == "spell" then
        ToggleDisplay(false)
    elseif arg == "reset" then
        Frame1:ClearAllPoints()
        Frame1:SetPoint("CENTER")
        Frame1:SetSize(130, 130)
        print("RedLine frame position has been reset.")
    else
        print("Usage: /Redline [attack|spell|reset]")
    end
end

    -- Register the slash commands
    SlashCmdList["RedLine"] = SlashCommandHandler
    SlashCmdList["redline"] = SlashCommandHandler
    SlashCmdList["redLine"] = SlashCommandHandler
    SlashCmdList["rln"] = SlashCommandHandler

    Frame1:SetScript("OnSizeChanged", function(self, width, height)
        -- Set minimum and maximum dimensions for the frame
        local minWidth, minHeight = 130, 40
        local maxWidth, maxHeight = UIParent:GetWidth() - 50, UIParent:GetHeight() - 50
        
        -- Clamp the frame dimensions to the allowed range
        self:SetWidth(math.max(minWidth, math.min(maxWidth, width)))
        self:SetHeight(math.max(minHeight, math.min(maxHeight, height)))
    end)
        -- Make the frame draggable
        Frame1:SetMovable(true)
        Frame1:EnableMouse(true)
        Frame1:RegisterForDrag("LeftButton")
        Frame1:SetScript("OnDragStart", Frame1.StartMoving)
        Frame1:SetScript("OnDragStop", Frame1.StopMovingOrSizing)


    -- Create the font string objects for displaying power values
    Frame1.attackPowerText = Frame1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Frame1.attackPowerText:SetPoint("TOPLEFT", Frame1, "TOPLEFT", 15, -15)

    Frame1.spellPowerText = Frame1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Frame1.spellPowerText:SetPoint("TOPLEFT", Frame1, "TOPLEFT", 15, -30)

    Frame1.healingPowerText = Frame1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Frame1.healingPowerText:SetPoint("TOPLEFT", Frame1, "TOPLEFT", 15, -45)

    Frame1.unitStatStrengthText = Frame1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Frame1.unitStatStrengthText:SetPoint("TOPLEFT", Frame1, "TOPLEFT", 15, -60)

	Frame1.unitStatIntellectText = Frame1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Frame1.unitStatIntellectText:SetPoint("TOPLEFT", Frame1, "TOPLEFT", 15, -75)

	Frame1.unitStatAgilityText = Frame1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Frame1.unitStatAgilityText:SetPoint("TOPLEFT", Frame1, "TOPLEFT", 15, -90)




	-- Register for events and update the power values
    Frame1:RegisterEvent("UNIT_STATS")
    Frame1:RegisterEvent("UNIT_ATTACK_POWER")
    Frame1:RegisterEvent("UNIT_SPELL_HASTE")
    Frame1:RegisterEvent("PLAYER_DAMAGE_DONE_MODS")
    Frame1:SetScript("OnEvent", UpdatePowerValues)
    UpdatePowerValues()
end
