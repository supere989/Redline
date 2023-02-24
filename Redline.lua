-- Author      : Xandre-Whitemane
-- Create Date : 2/23/2023 03:06:05 PM
-- revision    : 1.2
local MIN_FRAME_SIZE = 150

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

local buffTable = {}

for i = 1, 40 do
	local buffName, _, _, _, _, _, _, _, _, _, buffSpellID = UnitBuff("player", i)
	if buffName then
		table.insert(buffTable, buffName)
	end
end

if playerClass == "Mage" or playerClass == "Warlock" or playerClass == "Priest" or playerClass == "Shaman" or playerClass == "Druid" then
  spellPower = GetSpellBonusDamage(7)
  if UnitBuff("player", "Arcane Intellect") or UnitBuff("player", "Dalaran Brilliance") or UnitBuff("player", "Fel Intelligence") then
    spellText:SetTextColor(0.5, 0, 0.5) -- Change color to purple
  else
    spellText:SetTextColor(0, 0, 1) -- Default color (blue)
  end
end



local spellPower, attackPower = getSpellPowerAndAttackPower()

local spellPowerTable = {}
spellPowerTable[1] = "|cFFA335EESpell Power:|r " .. spellPower
spellPowerTable[2] = "|cFFFF0000Attack Power:|r " .. attackPower
spellPowerTable[3] = "|cFFFFA500Penetration:|r " .. negSpellPenetration
spellPowerTable[4] = "|cFFFFD100Healing:|r " .. posSpellHealing
spellPowerTable[5] = "|cFFFF7F00Agility: " .. (UnitStat("player", 2) or 0)
spellPowerTable[6] = "|cFF0099FFIntellect: " .. (UnitStat("player", 4) or 0)
spellPowerTable[7] = "|cFFFF0000Strength:|r " .. (UnitStat("player", 1) or 0)



    local totalSpellPower = baseSpellPower + (posSpellPower[2] or 0) + (posSpellPower[3] or 0) + (posSpellPower[5] or 0) + (posSpellPower[6] or 0) + (posSpellPower[7] or 0) + posSpellHealing + negSpellPenetration

    local attackPowerColor = "|cFFFF0000"
    local spellPowerColor = "|cFFFFFFFF"
    local healingPowerColor = "|cFF00FF00"
    local strenthPowerColor = "|cFFFF0000"
	local intellectPowerColor = "|cFFFFFFFF"
	local buffedIntellectPowerColor = "|cFFA335EE"
	local intellectPowerColorChange = "|cFFFFFFFF"
--[[	
if UnitBuff("player", "Fel Intelligence") then
  -- Buff is active, modify text color or other properties
  intellectPowerColorChange = buffedIntellectPowerColor
  
else
  -- Buff is not active, set default text color or other properties
  intellectPowerColorChange = intellectPowerColor
end
--]]

    if totalAttackPower > baseAttackPower then
        attackPowerColor = "|cFFFF0000"
    end

    if totalSpellPower > baseSpellPower then
        spellPowerColor = "|cFFA335EE"
    end

	
	
	
    Redline.attackPowerText:SetText("AttackPower: " .. totalAttackPower .. "|r")
    Redline.spellPowerText:SetText("|cFFA335EESpellPower: " .. spellPowerColor .. baseSpellPower .. "|r")
    Redline.healingPowerText:SetText("|cFF00FF00Healing: " .. healingPowerColor .. posSpellHealing .. "|r")
    Redline.unitStatStrengthText:SetText(strenthPowerColor .. spellPowerTable[7])
    Redline.unitStatIntellectText:SetText(intellectPowerColorChange .. spellPowerTable[6])
    Redline.unitStatAgilityText:SetText(spellPowerTable[5])

end



function Redline_Onload()
    -- set the initial font size
    local font = "Fonts\\FRIZQT__.TTF"
    local fontSize = 0.025 * Redline:GetHeight() -- set font size to 10% of the frame Height
    if fontSize < 5 then
	    fontSize = 5
    end
    -- Get the current player's class and spec then output to Console
	local class, _, spec = UnitClass("player")
    local _, _, classId = UnitClass("player")
    local level = UnitLevel("player")
    print("Class: " .. class)
    print("Spec: " .. spec)
    print("ClassID= " .. classId)
    print("Level= " .. level)
    
    -- Store the Font size in a variable
    Redline.fontSize = fontSize

    -- Define the slash command variations
    SLASH_RedLine1 = "/RedLine"
    SLASH_RedLine2 = "/redline"
    SLASH_RedLine3 = "/redLine"
    SLASH_RedLine4 = "/rln"

    local function SlashCommandHandler(arg)
        if arg == "melee" then
            ToggleDisplay(true)
        elseif arg == "spell" then
            ToggleDisplay(false)
        elseif arg == "reset" then
            Redline:ClearAllPoints()
            Redline:SetPoint("CENTER")
            Redline:SetSize(200, 200)
            print(fontSize)
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

    
    
    local userResized = false

Redline:SetScript("OnSizeChanged", function(self, width, height)
    if not userResized then
        -- Set minimum and maximum dimensions for the frame
        local minWidth, minHeight = 150, 150
        local maxWidth, maxHeight = UIParent:GetWidth() - 500, UIParent:GetHeight() - 500

        -- Clamp the frame dimensions to the allowed range
        self:SetWidth(math.max(minWidth, math.min(maxWidth, width)))
        self:SetHeight(math.max(minHeight, math.min(maxHeight, height)))

        -- Set the dimensions to 150x150 if either the width or height is less than 150
        if self:GetWidth() < 150 or self:GetHeight() < 150 then
            self:SetSize(150, 150)
        end
    end
    userResized = false
end)

-- Make the frame draggable
        Redline:SetMovable(true)
        Redline:EnableMouse(true)
        Redline:RegisterForDrag("LeftButton")
        Redline:SetScript("OnDragStart", Redline.StartMoving)
        Redline:SetScript("OnDragStop", Redline.StopMovingOrSizing)


   
-- Binds the Text Strings to the Frame window and adjusts the spacing to compensate for icon size during the dragging function
    local function UpdatePowerTextAnchors()
        local font, fontSize, fontFlags = Redline.attackPowerText:GetFont()
        local spacing = fontSize / 2 -- adjust the spacing between the text elements based on the font size

        Redline.attackPowerText:SetPoint("TOPLEFT", Redline, "TOPLEFT", 10, -10)
        Redline.spellPowerText:SetPoint("TOPLEFT", Redline.attackPowerText, "BOTTOMLEFT", 0, -spacing)
        Redline.healingPowerText:SetPoint("TOPLEFT", Redline.spellPowerText, "BOTTOMLEFT", 0, -spacing)
        Redline.unitStatStrengthText:SetPoint("TOPLEFT", Redline.healingPowerText, "BOTTOMLEFT", 0, -spacing)
        Redline.unitStatIntellectText:SetPoint("TOPLEFT", Redline.unitStatStrengthText, "BOTTOMLEFT", 0, -spacing)
        Redline.unitStatAgilityText:SetPoint("TOPLEFT", Redline.unitStatIntellectText, "BOTTOMLEFT", 0, -spacing)
--        Redline.weaponDamageText:SetPoint("TOPLEFT", Redline.unitStatAgilityText, "BOTTOMLEFT", 0, -spacing)
    end
 -- Create the font string objects for displaying power values
    Redline:SetScript("OnSizeChanged", function(self)
       	local size = math.max(self:GetWidth(), self:GetHeight()) -- use the larger of the two dimensions
        local fontSize = math.floor(size / 11) -- adjust this divisor to change the font scaling
        local font = "Fonts\\FRIZQT__.TTF" -- replace with your desired font file
        
                Redline.attackPowerText:SetFont(font, fontSize, "OUTLINE")
                Redline.spellPowerText:SetFont(font, fontSize, "OUTLINE")
                Redline.healingPowerText:SetFont(font, fontSize, "OUTLINE")
                Redline.unitStatStrengthText:SetFont(font, fontSize, "OUTLINE")
                Redline.unitStatIntellectText:SetFont(font, fontSize, "OUTLINE")
                Redline.unitStatAgilityText:SetFont(font, fontSize, "OUTLINE")
--                Redline.weaponDamageText:SetFont(font, fontSize, "OUTLINE")
        UpdatePowerTextAnchors()
	end)

    
	
	Redline.attackPowerText = Redline:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Redline.attackPowerText:SetPoint("TOPLEFT", Redline, "TOPLEFT", 15, -15)
--    Redline.attackPowerText:SetFont(font, fontSize, "OUTLINE")

    Redline.spellPowerText = Redline:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Redline.spellPowerText:SetPoint("TOPLEFT", Redline, "TOPLEFT", 15, -30)
--    Redline.spellPowerText:SetFont(font, fontSize, "OUTLINE")

    Redline.healingPowerText = Redline:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Redline.healingPowerText:SetPoint("TOPLEFT", Redline, "TOPLEFT", 15, -45)
--    Redline.healingPowerText:SetFont(font, fontSize, "OUTLINE")

    Redline.unitStatStrengthText = Redline:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Redline.unitStatStrengthText:SetPoint("TOPLEFT", Redline, "TOPLEFT", 15, -60)
--    Redline.unitStatStrengthText:SetFont(font, fontSize, "OUTLINE")

	Redline.unitStatIntellectText = Redline:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Redline.unitStatIntellectText:SetPoint("TOPLEFT", Redline, "TOPLEFT", 15, -75)
--    Redline.unitStatIntellectText:SetFont(font, fontSize, "OUTLINE")

	Redline.unitStatAgilityText = Redline:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    Redline.unitStatAgilityText:SetPoint("TOPLEFT", Redline, "TOPLEFT", 15, -90)
--    Redline.unitStatAgilityText:SetFont(font, fontSize, "OUTLINE")

 --   Redline.weaponDamageText = Redline:CreateFontString(nil, "ARTWORK", "GameFontNormal")
--    Redline.weaponDamageText:SetPoint("TOPLEFT", Redline, "TOPLEFT", 15, -105)
    

	-- Register for events and update the power values
    Redline:RegisterEvent("UNIT_STATS")
    Redline:RegisterEvent("UNIT_ATTACK_POWER")
    Redline:RegisterEvent("UNIT_SPELL_HASTE")
    Redline:RegisterEvent("PLAYER_DAMAGE_DONE_MODS")
    Redline:SetScript("OnEvent", UpdatePowerValues)
    UpdatePowerValues()
end
