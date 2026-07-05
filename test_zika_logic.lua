local lu = require("luaunit")
local ZikaLogic = require("zika_logic")

-- ============================================================
-- healthColor
-- ============================================================
TestHealthColor = {}

function TestHealthColor:test_high_health_returns_green()
    local c = ZikaLogic.healthColor(1.0)
    lu.assertAlmostEquals(c.R, 75 / 255, 1e-6)
    lu.assertAlmostEquals(c.G, 215 / 255, 1e-6)
    lu.assertAlmostEquals(c.B, 75 / 255, 1e-6)
end

function TestHealthColor:test_boundary_above_60_returns_green()
    local c = ZikaLogic.healthColor(0.61)
    lu.assertAlmostEquals(c.G, 215 / 255, 1e-6)
end

function TestHealthColor:test_exactly_60_returns_yellow()
    local c = ZikaLogic.healthColor(0.6)
    lu.assertAlmostEquals(c.R, 225 / 255, 1e-6)
    lu.assertAlmostEquals(c.G, 185 / 255, 1e-6)
    lu.assertAlmostEquals(c.B, 40 / 255, 1e-6)
end

function TestHealthColor:test_mid_health_returns_yellow()
    local c = ZikaLogic.healthColor(0.5)
    lu.assertAlmostEquals(c.G, 185 / 255, 1e-6)
end

function TestHealthColor:test_boundary_above_30_returns_yellow()
    local c = ZikaLogic.healthColor(0.31)
    lu.assertAlmostEquals(c.G, 185 / 255, 1e-6)
end

function TestHealthColor:test_exactly_30_returns_red()
    local c = ZikaLogic.healthColor(0.3)
    lu.assertAlmostEquals(c.R, 225 / 255, 1e-6)
    lu.assertAlmostEquals(c.G, 50 / 255, 1e-6)
    lu.assertAlmostEquals(c.B, 50 / 255, 1e-6)
end

function TestHealthColor:test_zero_health_returns_red()
    local c = ZikaLogic.healthColor(0)
    lu.assertAlmostEquals(c.R, 225 / 255, 1e-6)
end

function TestHealthColor:test_negative_health_returns_red()
    local c = ZikaLogic.healthColor(-0.5)
    lu.assertAlmostEquals(c.G, 50 / 255, 1e-6)
end

-- ============================================================
-- isAnomalyPlayer
-- ============================================================
TestIsAnomalyPlayer = {}

function TestIsAnomalyPlayer:test_anomaly_team_returns_true()
    local localP = { Team = { Name = "Survivors" } }
    local other  = { Team = { Name = "Anomalies" } }
    lu.assertTrue(ZikaLogic.isAnomalyPlayer(other, localP))
end

function TestIsAnomalyPlayer:test_same_player_returns_false()
    local p = { Team = { Name = "Anomalies" } }
    lu.assertFalse(ZikaLogic.isAnomalyPlayer(p, p))
end

function TestIsAnomalyPlayer:test_nil_team_returns_false()
    local localP = {}
    local other  = { Team = nil }
    lu.assertFalse(ZikaLogic.isAnomalyPlayer(other, localP))
end

function TestIsAnomalyPlayer:test_wrong_team_returns_false()
    local localP = {}
    local other  = { Team = { Name = "Survivors" } }
    lu.assertFalse(ZikaLogic.isAnomalyPlayer(other, localP))
end

function TestIsAnomalyPlayer:test_different_player_same_team_name()
    local localP = { Team = { Name = "Anomalies" } }
    local other  = { Team = { Name = "Anomalies" } }
    lu.assertTrue(ZikaLogic.isAnomalyPlayer(other, localP))
end

-- ============================================================
-- getStuds
-- ============================================================
TestGetStuds = {}

function TestGetStuds:test_same_position_returns_zero()
    local a = { HumanoidRootPart = { Position = { X = 0, Y = 0, Z = 0 } } }
    local b = { HumanoidRootPart = { Position = { X = 0, Y = 0, Z = 0 } } }
    lu.assertEquals(ZikaLogic.getStuds(a, b), 0)
end

function TestGetStuds:test_simple_distance()
    local a = { HumanoidRootPart = { Position = { X = 0, Y = 0, Z = 0 } } }
    local b = { HumanoidRootPart = { Position = { X = 3, Y = 4, Z = 0 } } }
    lu.assertEquals(ZikaLogic.getStuds(a, b), 5)
end

function TestGetStuds:test_3d_distance()
    local a = { HumanoidRootPart = { Position = { X = 1, Y = 2, Z = 3 } } }
    local b = { HumanoidRootPart = { Position = { X = 4, Y = 6, Z = 3 } } }
    lu.assertEquals(ZikaLogic.getStuds(a, b), 5)
end

function TestGetStuds:test_floors_result()
    local a = { HumanoidRootPart = { Position = { X = 0, Y = 0, Z = 0 } } }
    local b = { HumanoidRootPart = { Position = { X = 1, Y = 1, Z = 0 } } }
    -- sqrt(2) ≈ 1.414, floor = 1
    lu.assertEquals(ZikaLogic.getStuds(a, b), 1)
end

function TestGetStuds:test_nil_myChar_returns_zero()
    local b = { HumanoidRootPart = { Position = { X = 5, Y = 0, Z = 0 } } }
    lu.assertEquals(ZikaLogic.getStuds(nil, b), 0)
end

function TestGetStuds:test_nil_theirChar_returns_zero()
    local a = { HumanoidRootPart = { Position = { X = 0, Y = 0, Z = 0 } } }
    lu.assertEquals(ZikaLogic.getStuds(a, nil), 0)
end

function TestGetStuds:test_missing_root_part_returns_zero()
    local a = { HumanoidRootPart = { Position = { X = 0, Y = 0, Z = 0 } } }
    local b = {}
    lu.assertEquals(ZikaLogic.getStuds(a, b), 0)
end

function TestGetStuds:test_large_distance()
    local a = { HumanoidRootPart = { Position = { X = 0, Y = 0, Z = 0 } } }
    local b = { HumanoidRootPart = { Position = { X = 300, Y = 400, Z = 0 } } }
    lu.assertEquals(ZikaLogic.getStuds(a, b), 500)
end

-- ============================================================
-- healthPct
-- ============================================================
TestHealthPct = {}

function TestHealthPct:test_full_health()
    lu.assertAlmostEquals(ZikaLogic.healthPct(100, 100), 1.0, 1e-9)
end

function TestHealthPct:test_half_health()
    lu.assertAlmostEquals(ZikaLogic.healthPct(50, 100), 0.5, 1e-9)
end

function TestHealthPct:test_zero_health()
    lu.assertAlmostEquals(ZikaLogic.healthPct(0, 100), 0.0, 1e-9)
end

function TestHealthPct:test_zero_max_health()
    lu.assertAlmostEquals(ZikaLogic.healthPct(50, 0), 0.0, 1e-9)
end

function TestHealthPct:test_negative_max_health()
    lu.assertAlmostEquals(ZikaLogic.healthPct(50, -10), 0.0, 1e-9)
end

function TestHealthPct:test_over_max_clamps_to_one()
    lu.assertAlmostEquals(ZikaLogic.healthPct(150, 100), 1.0, 1e-9)
end

function TestHealthPct:test_negative_health_clamps_to_zero()
    lu.assertAlmostEquals(ZikaLogic.healthPct(-20, 100), 0.0, 1e-9)
end

-- ============================================================
-- formatHP
-- ============================================================
TestFormatHP = {}

function TestFormatHP:test_basic_format()
    lu.assertEquals(ZikaLogic.formatHP(75, 100), "HP: 75 / 100")
end

function TestFormatHP:test_floors_values()
    lu.assertEquals(ZikaLogic.formatHP(75.9, 100.7), "HP: 75 / 100")
end

function TestFormatHP:test_zero_hp()
    lu.assertEquals(ZikaLogic.formatHP(0, 100), "HP: 0 / 100")
end

-- ============================================================
-- formatStudsLabel
-- ============================================================
TestFormatStudsLabel = {}

function TestFormatStudsLabel:test_basic_label()
    lu.assertEquals(ZikaLogic.formatStudsLabel("Bob", 42), "Bob | Studs: 42")
end

function TestFormatStudsLabel:test_zero_studs()
    lu.assertEquals(ZikaLogic.formatStudsLabel("Alice", 0), "Alice | Studs: 0")
end

-- ============================================================
-- getAimPartPosition
-- ============================================================
TestGetAimPartPosition = {}

function TestGetAimPartPosition:test_returns_head_position()
    local char = { Head = { Position = { X = 1, Y = 5, Z = 3 } } }
    local pos = ZikaLogic.getAimPartPosition(char, "Head")
    lu.assertEquals(pos.X, 1)
    lu.assertEquals(pos.Y, 5)
    lu.assertEquals(pos.Z, 3)
end

function TestGetAimPartPosition:test_returns_torso_position()
    local char = { Torso = { Position = { X = 2, Y = 3, Z = 4 } } }
    local pos = ZikaLogic.getAimPartPosition(char, "Torso")
    lu.assertEquals(pos.X, 2)
end

function TestGetAimPartPosition:test_nil_character_returns_nil()
    lu.assertNil(ZikaLogic.getAimPartPosition(nil, "Head"))
end

function TestGetAimPartPosition:test_missing_part_returns_nil()
    local char = { Torso = { Position = { X = 0, Y = 0, Z = 0 } } }
    lu.assertNil(ZikaLogic.getAimPartPosition(char, "Head"))
end

-- ============================================================
-- aimMode
-- ============================================================
TestAimMode = {}

function TestAimMode:test_both_disabled_returns_none()
    lu.assertEquals(ZikaLogic.aimMode(false, false, {}), "none")
end

function TestAimMode:test_aimbot_no_target_returns_none()
    lu.assertEquals(ZikaLogic.aimMode(true, false, nil), "none")
end

function TestAimMode:test_aimlock_no_target_returns_none()
    lu.assertEquals(ZikaLogic.aimMode(false, true, nil), "none")
end

function TestAimMode:test_aimbot_with_target_returns_lerp()
    lu.assertEquals(ZikaLogic.aimMode(true, false, {}), "lerp")
end

function TestAimMode:test_aimlock_with_target_returns_lock()
    lu.assertEquals(ZikaLogic.aimMode(false, true, {}), "lock")
end

function TestAimMode:test_both_enabled_prefers_lock()
    lu.assertEquals(ZikaLogic.aimMode(true, true, {}), "lock")
end

-- ============================================================
-- headerGradientRotation
-- ============================================================
TestHeaderGradientRotation = {}

function TestHeaderGradientRotation:test_zero_dt_returns_base_rotation()
    local newOff, rot = ZikaLogic.headerGradientRotation(0, 0)
    lu.assertAlmostEquals(newOff, 0, 1e-9)
    lu.assertAlmostEquals(rot, 90, 1e-6)
end

function TestHeaderGradientRotation:test_offset_increments()
    local newOff, _ = ZikaLogic.headerGradientRotation(0, 1)
    lu.assertAlmostEquals(newOff, 0.28, 1e-9)
end

function TestHeaderGradientRotation:test_offset_wraps_around()
    local newOff, _ = ZikaLogic.headerGradientRotation(0.9, 1)
    -- (0.9 + 0.28) % 1 = 0.18
    lu.assertAlmostEquals(newOff, 0.18, 1e-6)
end

function TestHeaderGradientRotation:test_rotation_range()
    for i = 0, 100 do
        local off = i / 100
        local _, rot = ZikaLogic.headerGradientRotation(off, 0.016)
        lu.assertTrue(rot >= 90, "rotation should be >= 90, got " .. rot)
        lu.assertTrue(rot <= 112, "rotation should be <= 112, got " .. rot)
    end
end

os.exit(lu.LuaUnit.run())
