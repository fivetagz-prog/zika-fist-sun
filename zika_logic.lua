-- zika_logic.lua
-- Extracted pure-logic helpers from zika-ghost.lua for unit-testing.
-- Each function mirrors the logic used in the main Roblox script but
-- operates on plain Lua tables so it can be tested without the engine.

local ZikaLogic = {}

--- Returns normalised RGB values (0..1 each) for a health-bar colour.
--- @param pct number  health fraction in [0, 1]
--- @return table {R, G, B} with values in [0, 1]
function ZikaLogic.healthColor(pct)
    if pct > 0.6 then
        return { R = 75 / 255, G = 215 / 255, B = 75 / 255 }
    elseif pct > 0.3 then
        return { R = 225 / 255, G = 185 / 255, B = 40 / 255 }
    else
        return { R = 225 / 255, G = 50 / 255, B = 50 / 255 }
    end
end

--- Decides whether *player* qualifies as an anomaly opponent.
--- @param player  table  { Team = { Name = string } | nil }
--- @param localPlayer table  reference identity for "self" check
--- @return boolean
function ZikaLogic.isAnomalyPlayer(player, localPlayer)
    return player ~= localPlayer
        and player.Team ~= nil
        and player.Team.Name == "Anomalies"
end

--- Calculates integer stud distance between two characters.
--- Each character is a table with an optional HumanoidRootPart holding
--- a Position = {X, Y, Z}.
--- @param myChar    table|nil
--- @param theirChar table|nil
--- @return number
function ZikaLogic.getStuds(myChar, theirChar)
    if not myChar then return 0 end
    local myRoot = myChar.HumanoidRootPart
    local theirRoot = theirChar and theirChar.HumanoidRootPart
    if not myRoot or not theirRoot then return 0 end
    local dx = myRoot.Position.X - theirRoot.Position.X
    local dy = myRoot.Position.Y - theirRoot.Position.Y
    local dz = myRoot.Position.Z - theirRoot.Position.Z
    return math.floor(math.sqrt(dx * dx + dy * dy + dz * dz))
end

--- Computes clamped health fraction.
--- @param health    number
--- @param maxHealth number
--- @return number  value in [0, 1]
function ZikaLogic.healthPct(health, maxHealth)
    if maxHealth <= 0 then return 0 end
    return math.max(0, math.min(health / maxHealth, 1))
end

--- Formats the HP label shown on the ESP billboard.
--- @param health    number
--- @param maxHealth number
--- @return string
function ZikaLogic.formatHP(health, maxHealth)
    return "HP: " .. math.floor(health) .. " / " .. math.floor(maxHealth)
end

--- Formats the studs label shown on the ESP billboard.
--- @param playerName string
--- @param studs      number
--- @return string
function ZikaLogic.formatStudsLabel(playerName, studs)
    return playerName .. " | Studs: " .. studs
end

--- Returns the Position of a named part inside a character table.
--- @param character table|nil  e.g. { Head = {Position = …}, Torso = … }
--- @param partName  string
--- @return table|nil  {X, Y, Z} or nil
function ZikaLogic.getAimPartPosition(character, partName)
    if not character then return nil end
    local part = character[partName]
    if not part then return nil end
    return part.Position
end

--- Decides the aimbot camera behaviour.
--- @return string  "lock", "lerp", or "none"
function ZikaLogic.aimMode(aimbotEnabled, aimlockEnabled, selectedTarget)
    if not (aimbotEnabled or aimlockEnabled) then return "none" end
    if not selectedTarget then return "none" end
    if aimlockEnabled then return "lock" end
    return "lerp"
end

--- Computes the animated gradient rotation used by the header.
--- @param gradientOffset number  current animation offset
--- @param dt              number  delta-time since last frame
--- @return number newOffset, number rotation
function ZikaLogic.headerGradientRotation(gradientOffset, dt)
    local newOffset = (gradientOffset + dt * 0.28) % 1
    local t = math.abs(math.sin(newOffset * math.pi))
    return newOffset, 90 + t * 22
end

return ZikaLogic
