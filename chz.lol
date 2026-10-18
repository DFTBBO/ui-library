--[[
    🎯 UNIVERSAL PRO SCRIPT v9.5 (完整功能 + v9.0 串行拾取 + 零延迟)
    - Silent Aim：完整功能
    - ESP：完整功能
    - 🍬 糖果：v9.0 的"一个一个捡"串行引擎 + 零延迟参数（固定最优值，无需调节）
      · 每轮只选最近的一个糖果触发
      · 触发后异步验证，糖果消失=服务器认可
      · 失败固定短冷却重试，最多 5 次
    - Bypass + Save 完整保留
]]

--// ==================================================
--// 1. 全局配置
--// ==================================================
_G.SilentAim = false
_G.FOV = 150
_G.VisibleCheck = true
_G.TeamCheck = true
_G.TeamCheckForNPCs = false
_G.DeadCheck = true
_G.Prediction = 0.165
_G.AutoPrediction = true
_G.UpdateRate = 0.01
_G.TargetMode = "NPCs"
_G.AimPart = "Head"
_G.ShowTarget = true
_G.HitChance = 100
_G.BulletTP = false
_G.ShowTargetName = true
_G.ShowTargetType = true
_G.ShowTargetHP = true
_G.ShowTargetDistance = true
_G.ShowHitChance = true
_G.HighlightTarget = false
_G.HighlightNPCColor = Color3.fromRGB(255, 50, 50)
_G.HighlightPlayerColor = Color3.fromRGB(50, 150, 255)
_G.DebugNPCs = false
_G.AggressiveNPCDetection = false
_G.TargetPriority = "Crosshair"
_G.StickyAim = true
_G.FOVColor = Color3.fromRGB(0, 255, 0)
_G.FriendCheck = true
_G.AdonisBypass = true
_G.EnableDistanceLimit = true
_G.MaxAimDistance = 500
_G.Whitelist = {}
_G.Blacklist = {}
_G.NPCKeywordFilterEnabled = false
_G.NPCKeywordFilter = "dog"

local RESCAN_FRAMES = 3
local SLOW_VALIDATE_FRAMES = 5
local TI_FREQ = 2
local HL_FREQ = 3

getgenv().ESP_Config = {
    Enabled = false, ShowPlayers = true, ShowNPCs = true, TeamCheck = true, DeadCheck = true,
    MaxDistance = 2500, NameTextSize = 16, DistanceTextSize = 14, InventoryTextSize = 13,
    HPBarWidth = 60, HPBarHeight = 6,
    ShowBox = true, ShowLine = true, ShowStick = true, ShowName = true, ShowDistance = true,
    ShowHPBar = true, ShowEquippedItem = true, ShowInventory = false, UseTeamColor = true,
    ShowBonbon = false, AutoFarmBonbon = false,
    -- 🍬 v9.0 串行 + 零延迟固定参数（无需调节）
    AutoFarmBonbonDelay = 0.02,      -- 主循环间隔
    TouchVerifyWait = 0.2,           -- 验证等待
    RetryCooldown = 0.12,            -- 单糖果重试冷却（不累积）
    FireTouchYield = 0.02,           -- firetouch 后 yield
    TouchPerCandyMaxAttempts = 5,    -- 最多尝试次数
    EnablePrompt = true, EnableClick = true, EnableRemote = true,
    EnemyColor = Color3.fromRGB(255, 80, 80), AllyColor = Color3.fromRGB(80, 255, 80),
    LineColor = Color3.fromRGB(255, 255, 0), StickColor = Color3.fromRGB(255, 255, 255)
}

--// ==================================================
--// 1.5 ANTI-KICK + ADONIS
--// ==================================================
local AntiKickEnabled = true
local antiKickLoaded = false
pcall(function()
    local s = game:HttpGet("https://rawscripts.net/raw/Universal-Script-Adonis-Bypass-45451")
    if s and #s > 0 then
        task.spawn(function()
            local f = loadstring(s)
            if f and pcall(f) then antiKickLoaded = true end
        end)
    end
end)
task.spawn(function()
    if not AntiKickEnabled then return end
    while AntiKickEnabled and task.wait(30) do
        pcall(function()
            local lp = game:GetService("Players").LocalPlayer
            if lp then pcall(function() lp.Kick = function() return nil end end) end
        end)
    end
end)

local function BypassAdonis()
    if not _G.AdonisBypass then return end
    local det = false
    for _, o in pairs(game:GetDescendants()) do
        if o.Name == "Adonis" or o.Name == "AntiCheat" then det = true; break end
    end
    if not det then
        for _, n in pairs({"Adonis_Remote","Adonis_AntiCheat","Adonis_Check","Adonis_Validate","Adonis_Log","Adonis_Event"}) do
            if ReplicatedStorage:FindFirstChild(n) then det = true; break end
        end
    end
    if det then
        pcall(function()
            local mt = getrawmetatable(game)
            local onc = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local m = getnamecallmethod()
                if m == "FireServer" or m == "InvokeServer" then
                    local sn = string.lower(tostring(self))
                    if string.find(sn, "adonis") or string.find(sn, "anticheat") then return nil end
                end
                return onc(self, ...)
            end)
            setreadonly(mt, true)
        end)
    end
end
task.spawn(function() task.wait(2); BypassAdonis() end)

--// ==================================================
--// 2. 服务与变量
--// ==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Circle = Drawing.new("Circle")
Circle.Color = _G.FOVColor; Circle.Thickness = 2; Circle.Visible = false
Circle.Radius = _G.FOV; Circle.Transparency = 0.7; Circle.Filled = false

local TargetInfo = Drawing.new("Text")
TargetInfo.Visible = false; TargetInfo.Color = Color3.fromRGB(255,255,255)
TargetInfo.Size = 18; TargetInfo.Font = 2; TargetInfo.Outline = true
TargetInfo.OutlineColor = Color3.fromRGB(0,0,0); TargetInfo.Text = ""

local TargetHighlight, HighlightConnection = nil, nil
local CurrentTarget, TargetPart, TargetInRange = nil, nil, false
local NPCCache, PlayerCache = {}, {}
local LastCacheUpdate = 0
local CacheUpdateInterval = 1.0
local oldNamecall, oldIndex = nil, nil
local ESP_Objects = {}
local _DiedConn = nil
local _currentIsPlayer = false

local _cachedViewport = Vector2.new(0, 0)
local _cachedCenter = Vector2.new(0, 0)
local _cachedCamPos = Vector3.new(0, 0, 0)
local _raycastParams = RaycastParams.new()
_raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
_raycastParams.IgnoreWater = true

local _frameCounter, _slowCheckCounter, _tiCounter, _hlCounter, _espCounter = 0, 0, 0, 0, 0
local _lastCircleColor = Color3.fromRGB(255, 50, 0)

local function RefreshFrameCache()
    local vp = Camera.ViewportSize
    if vp ~= _cachedViewport then
        _cachedViewport = vp
        _cachedCenter = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    end
    _cachedCamPos = Camera.CFrame.Position
end

--// ==================================================
--// 3. Silent Aim 核心（完整）
--// ==================================================
local function IsDead(c)
    if not c or not c.Parent then return true end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h or not h.Parent then return true end
    if h.Health <= 0 then return true end
    if h:GetState() == Enum.HumanoidStateType.Dead then return true end
    local be = c:FindFirstChild("BodyEffects")
    if be then
        local ko = be:FindFirstChild("K.O")
        if ko and ko.Value == true then return true end
    end
    return false
end

local function ComputePredictionTime(dist)
    local base = _G.Prediction
    if base <= 0 then return 0 end
    if not _G.AutoPrediction then return base end
    local factor = dist / 200
    if factor < 0.3 then factor = 0.3 elseif factor > 3 then factor = 3 end
    return base * factor
end

local function PredictPos(hrp, basePos, camPos)
    local v = hrp.Velocity
    local vmagSq = v.X * v.X + v.Y * v.Y + v.Z * v.Z
    if vmagSq < 1 then return basePos end
    local dx, dy, dz = basePos.X - camPos.X, basePos.Y - camPos.Y, basePos.Z - camPos.Z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
    local t = ComputePredictionTime(dist)
    if t <= 0 then return basePos end
    return Vector3.new(basePos.X + v.X * t, basePos.Y + v.Y * t, basePos.Z + v.Z * t)
end

local function IsFriend(p)
    if not p then return false end
    if not LocalPlayer or not LocalPlayer:IsA("Player") then return false end
    local ok, r = pcall(function() return LocalPlayer:IsFriendsWith(p.UserId) end)
    if ok and r then return true end
    local ok2, r2 = pcall(function() return LocalPlayer.FriendSystem:IsFriend(p) end)
    if ok2 and r2 then return true end
    return false
end

local function IsInList(list, p)
    if not p or not list then return false end
    local pn, pu = tostring(p.Name), tostring(p.UserId)
    for _, e in pairs(list) do
        local s = tostring(e)
        if s == pn or s == pu then return true end
    end
    return false
end
local function IsWhitelisted(p) return IsInList(_G.Whitelist, p) end
local function IsBlacklisted(p) return IsInList(_G.Blacklist, p) end

local function MatchesNPCKeyword(m)
    if not _G.NPCKeywordFilterEnabled then return true end
    local f = _G.NPCKeywordFilter
    if not f or f == "" then return true end
    if not m then return false end
    local names = {tostring(m.Name)}
    local h = m:FindFirstChildOfClass("Humanoid")
    if h then
        table.insert(names, tostring(h.Name))
        if h.DisplayName and h.DisplayName ~= "" then table.insert(names, tostring(h.DisplayName)) end
    end
    for _, c in ipairs(m:GetChildren()) do if c.Name then table.insert(names, tostring(c.Name)) end end
    local combined = string.lower(table.concat(names, "|"))
    for kw in string.gmatch(f, "[^,]+") do
        kw = kw:gsub("^%s+", ""):gsub("%s+$", "")
        if kw ~= "" and string.find(combined, string.lower(kw), 1, true) then return true end
    end
    return false
end

local function IsPlayer(c)
    if not c or not c:IsA("Model") then return false end
    if c == LocalPlayer.Character then return true end
    return Players:GetPlayerFromCharacter(c) ~= nil
end

local function IsNPC(c)
    if not c or not c:IsA("Model") then return false end
    if IsPlayer(c) then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return false end
    local root = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
    return root ~= nil
end

local function IsEnemyPlayer(p)
    if not p then return false end
    if IsWhitelisted(p) then return false end
    if IsBlacklisted(p) then return true end
    if not _G.TeamCheck then return true end
    if not LocalPlayer.Team or not p.Team then return true end
    if _G.FriendCheck and IsFriend(p) then return false end
    return LocalPlayer.Team ~= p.Team
end

local function IsEnemyNPC(m)
    if not _G.TeamCheckForNPCs then return true end
    local tv = m:FindFirstChild("Team")
    if tv and tv:IsA("StringValue") then
        local lt = LocalPlayer.Team and LocalPlayer.Team.Name or ""
        if tv.Value and lt and tv.Value ~= lt then return true end
    end
    local ie = m:FindFirstChild("IsEnemy")
    if ie and ie:IsA("BoolValue") and ie.Value == true then return true end
    return true
end

local function GetTargetPart(c)
    if _G.AimPart == "Head" then return c:FindFirstChild("Head")
    elseif _G.AimPart == "Torso" then
        return c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") or c:FindFirstChild("HumanoidRootPart")
    elseif _G.AimPart == "Random" then
        for _, p in pairs({c:FindFirstChild("Head"), c:FindFirstChild("UpperTorso"), c:FindFirstChild("Torso"), c:FindFirstChild("HumanoidRootPart")}) do
            if p then return p end
        end
    elseif _G.AimPart == "Both" then
        local h = c:FindFirstChild("Head")
        local t = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") or c:FindFirstChild("HumanoidRootPart")
        if h and t then return tick() % 1 > 0.5 and h or t elseif h then return h elseif t then return t end
    end
    return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")
end

local function UpdateCaches()
    local t = tick()
    if t - LastCacheUpdate < CacheUpdateInterval then return end
    LastCacheUpdate = t
    local tnpc, tplr = {}, {}

    local function scanModel(o)
        if not o:IsA("Model") or o == LocalPlayer.Character then return end
        if tnpc[o] or tplr[o] then return end
        local hrp = o:FindFirstChild("HumanoidRootPart") or o:FindFirstChild("Torso") or o:FindFirstChild("UpperTorso")
        if not hrp then return end
        local h = o:FindFirstChildOfClass("Humanoid")
        if not h then return end
        if _G.DeadCheck and IsDead(o) then return end
        if IsPlayer(o) then
            local plr = Players:GetPlayerFromCharacter(o)
            if not IsWhitelisted(plr) then
                tplr[o] = {Model = o, HRP = hrp, Humanoid = h, Player = plr, IsNPC = false}
            end
        elseif IsNPC(o) then
            tnpc[o] = {Model = o, HRP = hrp, Humanoid = h, IsNPC = true}
        end
    end

    for _, o in pairs(workspace:GetChildren()) do
        if o:IsA("Model") then scanModel(o)
        elseif o:IsA("Folder") then
            for _, c in pairs(o:GetChildren()) do
                if c:IsA("Model") then scanModel(c)
                elseif c:IsA("Folder") then
                    local n = c.Name:lower()
                    if n:find("npc") or n:find("enemy") or n:find("mob") or n:find("bot") or n:find("monster") or n:find("character") or n:find("target") or n:find("zombie") or n:find("dummy") or n:find("hostile") then
                        for _, g in pairs(c:GetChildren()) do scanModel(g) end
                    end
                end
            end
        end
    end
    if _G.AggressiveNPCDetection then
        for _, o in pairs(workspace:GetDescendants()) do
            if o:IsA("Model") and not tnpc[o] and not tplr[o] then scanModel(o) end
        end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and not tplr[plr.Character] then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local h = char:FindFirstChildOfClass("Humanoid")
            if hrp and h and not (_G.DeadCheck and IsDead(char)) and not IsWhitelisted(plr) then
                tplr[char] = {Model = char, HRP = hrp, Humanoid = h, Player = plr, IsNPC = false}
            end
        end
    end
    NPCCache = tnpc
    PlayerCache = tplr
end

local function QuickValidate()
    if not CurrentTarget or not TargetPart then return false end
    if not CurrentTarget.Parent or not TargetPart.Parent then return false end
    local h = CurrentTarget:FindFirstChildOfClass("Humanoid")
    if not h then return false end
    if _G.DeadCheck then
        if h.Health <= 0 or h:GetState() == Enum.HumanoidStateType.Dead then return false end
        local be = CurrentTarget:FindFirstChild("BodyEffects")
        if be then
            local ko = be:FindFirstChild("K.O")
            if ko and ko.Value == true then return false end
        end
    end
    local hrp = CurrentTarget:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local pos = PredictPos(hrp, TargetPart.Position, _cachedCamPos)
    local sp, on = Camera:WorldToViewportPoint(pos)
    if not on then return false end
    local dx, dy = sp.X - _cachedCenter.X, sp.Y - _cachedCenter.Y
    if dx * dx + dy * dy > _G.FOV * _G.FOV then return false end
    if _G.EnableDistanceLimit and LocalPlayer.Character then
        local lr = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if lr then
            local lrp = lr.Position
            local dx2, dy2, dz2 = pos.X - lrp.X, pos.Y - lrp.Y, pos.Z - lrp.Z
            if dx2 * dx2 + dy2 * dy2 + dz2 * dz2 > _G.MaxAimDistance * _G.MaxAimDistance then return false end
        end
    end
    return true
end

local function SlowValidate()
    if not QuickValidate() then return false end
    if _G.VisibleCheck then
        local tp = Players:GetPlayerFromCharacter(CurrentTarget)
        local isBL = tp and IsBlacklisted(tp) or false
        if not isBL then
            local hrp = CurrentTarget:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end
            local pos = PredictPos(hrp, TargetPart.Position, _cachedCamPos)
            _raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
            local dir = pos - _cachedCamPos
            local ray = workspace:Raycast(_cachedCamPos, dir.Unit * dir.Magnitude, _raycastParams)
            if ray and not ray.Instance:IsDescendantOf(CurrentTarget) then return false end
        end
    end
    return true
end

local function GetTarget()
    if not LocalPlayer.Character then TargetInRange = false; TargetPart = nil; return nil end
    if CurrentTarget and TargetPart then
        if QuickValidate() then
            TargetInRange = true
            _slowCheckCounter = _slowCheckCounter + 1
            if _slowCheckCounter >= SLOW_VALIDATE_FRAMES then
                _slowCheckCounter = 0
                if not SlowValidate() then
                    NPCCache[CurrentTarget] = nil
                    PlayerCache[CurrentTarget] = nil
                    CurrentTarget = nil
                    TargetPart = nil
                end
            end
            if CurrentTarget then
                _frameCounter = _frameCounter + 1
                if _frameCounter < RESCAN_FRAMES then return CurrentTarget end
                _frameCounter = 0
            end
        else
            CurrentTarget = nil
            TargetPart = nil
        end
    end

    local lChar = LocalPlayer.Character
    local lRoot = lChar:FindFirstChild("HumanoidRootPart")
    if not lRoot then TargetInRange = false; TargetPart = nil; return nil end
    local lRootPos = lRoot.Position
    local camPos = _cachedCamPos
    local sc = _cachedCenter
    local fovSq = _G.FOV * _G.FOV
    local maxDistSq = _G.MaxAimDistance * _G.MaxAimDistance
    local useDist = _G.EnableDistanceLimit
    local useVis = _G.VisibleCheck
    local blActive = #_G.Blacklist > 0

    local b1Sq, b1M, b1P, b1IsP, b1IsBL = math.huge, nil, nil, false, false
    local b2Sq, b2M, b2P, b2IsP, b2IsBL = math.huge, nil, nil, false, false
    local b3Sq, b3M, b3P, b3IsP, b3IsBL = math.huge, nil, nil, false, false

    local function consider(sq, m, p, isP, isBL)
        if sq < b1Sq then
            b3Sq, b3M, b3P, b3IsP, b3IsBL = b2Sq, b2M, b2P, b2IsP, b2IsBL
            b2Sq, b2M, b2P, b2IsP, b2IsBL = b1Sq, b1M, b1P, b1IsP, b1IsBL
            b1Sq, b1M, b1P, b1IsP, b1IsBL = sq, m, p, isP, isBL
        elseif sq < b2Sq then
            b3Sq, b3M, b3P, b3IsP, b3IsBL = b2Sq, b2M, b2P, b2IsP, b2IsBL
            b2Sq, b2M, b2P, b2IsP, b2IsBL = sq, m, p, isP, isBL
        elseif sq < b3Sq then
            b3Sq, b3M, b3P, b3IsP, b3IsBL = sq, m, p, isP, isBL
        end
    end

    if not blActive and (_G.TargetMode == "NPCs" or _G.TargetMode == "Both") then
        for _, d in pairs(NPCCache) do
            local hrp = d.HRP
            if hrp.Parent and d.Model.Parent then
                local part = GetTargetPart(d.Model) or hrp
                if part.Parent then
                    local pos = PredictPos(hrp, part.Position, camPos)
                    local sp, on = Camera:WorldToViewportPoint(pos)
                    if on then
                        local dx, dy = sp.X - sc.X, sp.Y - sc.Y
                        local dfcSq = dx * dx + dy * dy
                        if dfcSq < fovSq and dfcSq < b3Sq then
                            local skip = false
                            if useDist then
                                local hp = hrp.Position
                                local dxw, dyw, dzw = hp.X - lRootPos.X, hp.Y - lRootPos.Y, hp.Z - lRootPos.Z
                                if dxw * dxw + dyw * dyw + dzw * dzw > maxDistSq then skip = true end
                            end
                            if not skip and IsEnemyNPC(d.Model) and MatchesNPCKeyword(d.Model) then
                                consider(dfcSq, d.Model, part, false, false)
                            end
                        end
                    end
                end
            end
        end
    end

    if blActive or _G.TargetMode == "Players" or _G.TargetMode == "Both" then
        for _, d in pairs(PlayerCache) do
            local hrp = d.HRP
            if hrp.Parent and d.Model.Parent then
                local isBL = false
                local skip = false
                if blActive then
                    if not IsBlacklisted(d.Player) then skip = true else isBL = true end
                else
                    if not IsEnemyPlayer(d.Player) then skip = true end
                end
                if not skip then
                    local part = GetTargetPart(d.Model) or hrp
                    if part.Parent then
                        local pos = PredictPos(hrp, part.Position, camPos)
                        local sp, on = Camera:WorldToViewportPoint(pos)
                        if on then
                            local dx, dy = sp.X - sc.X, sp.Y - sc.Y
                            local dfcSq = dx * dx + dy * dy
                            if dfcSq < fovSq and dfcSq < b3Sq then
                                local skip2 = false
                                if useDist and not isBL then
                                    local hp = hrp.Position
                                    local dxw, dyw, dzw = hp.X - lRootPos.X, hp.Y - lRootPos.Y, hp.Z - lRootPos.Z
                                    if dxw * dxw + dyw * dyw + dzw * dzw > maxDistSq then skip2 = true end
                                end
                                if not skip2 then consider(dfcSq, d.Model, part, true, isBL) end
                            end
                        end
                    end
                end
            end
        end
    end

    TargetInRange = b1M ~= nil

    local function tryOne(m, p, isP, isBL)
        if not m or not p or not p.Parent then return nil end
        if useVis and not isBL then
            local hrp = m:FindFirstChild("HumanoidRootPart")
            if not hrp then return nil end
            local pos = PredictPos(hrp, p.Position, camPos)
            _raycastParams.FilterDescendantsInstances = {lChar, Camera}
            local dir = pos - camPos
            local dist = dir.Magnitude
            if dist > 0.01 then
                local ray = workspace:Raycast(camPos, dir.Unit * dist, _raycastParams)
                if ray and not ray.Instance:IsDescendantOf(m) then return nil end
            end
        end
        return m, p, isP
    end

    local best, bestPart, bestIsP = tryOne(b1M, b1P, b1IsP, b1IsBL)
    if not best then best, bestPart, bestIsP = tryOne(b2M, b2P, b2IsP, b2IsBL) end
    if not best then best, bestPart, bestIsP = tryOne(b3M, b3P, b3IsP, b3IsBL) end

    if best then
        TargetPart = bestPart
        _currentIsPlayer = bestIsP
        if best ~= CurrentTarget then
            if _DiedConn then _DiedConn:Disconnect(); _DiedConn = nil end
            local h = best:FindFirstChildOfClass("Humanoid")
            if h then
                local bModel = best
                _DiedConn = h.Died:Connect(function()
                    if CurrentTarget == bModel then
                        NPCCache[bModel] = nil
                        PlayerCache[bModel] = nil
                        CurrentTarget = nil
                        TargetPart = nil
                    end
                end)
            end
        end
        return best
    end

    TargetPart = nil
    _currentIsPlayer = false
    return nil
end

local function ShouldHit()
    if _G.HitChance >= 100 then return true end
    if _G.HitChance <= 0 then return false end
    return math.random(1, 100) <= _G.HitChance
end

local function CalcChance()
    if not CurrentTarget or not TargetPart then return 0 end
    if not TargetPart.Parent then return 0 end
    local b, df, ff = _G.HitChance, 1.0, 1.0
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local d = (TargetPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if d < 50 then df = 1.1 elseif d > 200 then df = 0.8 end
    end
    if _G.FOV < 100 then ff = 1.15 elseif _G.FOV > 250 then ff = 0.9 end
    return math.floor(math.clamp(b * df * ff + math.random(-5, 5), 1, 100))
end

local function CreateHighlight(t)
    if not t or not t:IsA("Model") then return nil end
    if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight = nil end
    if HighlightConnection then HighlightConnection:Disconnect(); HighlightConnection = nil end
    local h = Instance.new("Highlight")
    h.Name = "SilentAimHighlight"; h.Adornee = t
    h.FillColor = Color3.fromRGB(255, 50, 50); h.FillTransparency = 0.7
    h.OutlineColor = Color3.fromRGB(255, 255, 255); h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = game:GetService("CoreGui")
    HighlightConnection = t.Destroying:Connect(function()
        if h then h:Destroy(); TargetHighlight = nil end
    end)
    return h
end

local function UpdateHighlight()
    if not _G.HighlightTarget then
        if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight = nil end
        if HighlightConnection then HighlightConnection:Disconnect(); HighlightConnection = nil end
        return
    end
    if CurrentTarget and CurrentTarget.Parent and TargetPart and TargetPart.Parent then
        if not TargetHighlight or TargetHighlight.Adornee ~= CurrentTarget then TargetHighlight = CreateHighlight(CurrentTarget) end
        if TargetHighlight then
            TargetHighlight.FillColor = _currentIsPlayer and _G.HighlightPlayerColor or _G.HighlightNPCColor
            if _G.HitChance >= 80 then
                local pulse = math.sin(tick() * 3) * 0.2 + 0.8
                TargetHighlight.FillTransparency = 0.7 + (0.2 * (1 - pulse))
            else
                TargetHighlight.FillTransparency = 0.7
            end
        end
    else
        if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight = nil end
        if HighlightConnection then HighlightConnection:Disconnect(); HighlightConnection = nil end
    end
end

local function CleanupUIOnly()
    if Circle then Circle.Visible = false end
    if TargetInfo then TargetInfo.Visible = false; TargetInfo.Text = "" end
    if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight = nil end
    if HighlightConnection then HighlightConnection:Disconnect(); HighlightConnection = nil end
    if _DiedConn then _DiedConn:Disconnect(); _DiedConn = nil end
    CurrentTarget = nil; TargetPart = nil; TargetInRange = false; NPCCache = {}; PlayerCache = {}
end

local function UpdateTargetInfo()
    if not _G.ShowTarget or not TargetInfo or not _G.SilentAim then
        TargetInfo.Visible = false; TargetInfo.Text = ""; return
    end
    if CurrentTarget and CurrentTarget.Parent and TargetPart and TargetPart.Parent then
        local sp, on = Camera:WorldToViewportPoint(TargetPart.Position)
        if on then
            TargetInfo.Visible = true
            TargetInfo.Position = Vector2.new(sp.X, sp.Y + 20)
            local lines = {}
            if _G.ShowTargetName then
                local nm, ty = CurrentTarget.Name, "NPC"
                if _currentIsPlayer then
                    local plr = Players:GetPlayerFromCharacter(CurrentTarget)
                    if plr then ty = "Player"; nm = plr.Name end
                end
                table.insert(lines, _G.ShowTargetType and string.format("[%s] %s", ty, nm) or nm)
            end
            if _G.ShowTargetHP then
                local h = CurrentTarget:FindFirstChildOfClass("Humanoid")
                if h then table.insert(lines, string.format("HP: %.0f/%.0f", h.Health, h.MaxHealth)) end
            end
            if _G.ShowTargetDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(lines, string.format("Dist: %.1f studs", (TargetPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude))
            end
            if _G.ShowHitChance and _G.HitChance > 0 then
                table.insert(lines, string.format("Chance: %d%%", CalcChance()))
            end
            TargetInfo.Text = #lines > 0 and table.concat(lines, "\n") or "Alvo travado"
        else
            TargetInfo.Visible = false; TargetInfo.Text = ""
        end
    else
        TargetInfo.Visible = false; TargetInfo.Text = ""
    end
end

--// ==================================================
--// 4. ESP（完整）
--// ==================================================
local function newDrawing(t)
    local o = Drawing.new(t); o.Visible = false; o.ZIndex = 2; return o
end
local function setVis(parts, v)
    for _, o in pairs(parts) do if o.Visible ~= v then o.Visible = v end end
end
local function getHum(model)
    if not model or not model:IsA("Model") then return nil, nil end
    local h = model:FindFirstChildOfClass("Humanoid")
    if not h then return nil, nil end
    local r = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
    if not r then return nil, nil end
    return h, r
end
local function getPlrFromChar(m) return Players:GetPlayerFromCharacter(m) end
local function getTool(m)
    for _, v in ipairs(m:GetChildren()) do
        if v:IsA("Tool") or v:IsA("Accessory") then return v.Name end
    end
    return nil
end
local function getInv(m)
    local items = {}
    local plr = getPlrFromChar(m)
    for _, v in ipairs(m:GetChildren()) do
        if v:IsA("Tool") then table.insert(items, v.Name .. " (Eq)") end
    end
    if plr and plr:FindFirstChild("Backpack") then
        for _, v in ipairs(plr.Backpack:GetChildren()) do
            if v:IsA("Tool") then table.insert(items, v.Name) end
        end
    end
    return #items > 0 and table.concat(items, "\n") or nil
end
local function getTC(m)
    local p = getPlrFromChar(m)
    if p and p.Team then return p.TeamColor and p.TeamColor.Color or p.Team.Color end
    return nil
end
local function isAlly(m)
    local p = getPlrFromChar(m)
    if p and LocalPlayer then
        if LocalPlayer.Team and p.Team and LocalPlayer.Team == p.Team then return true end
        if LocalPlayer.TeamColor and p.TeamColor and LocalPlayer.TeamColor == p.TeamColor then return true end
    end
    local tv = m:FindFirstChild("Team") or m:FindFirstChild("TeamColor")
    if tv and LocalPlayer.Team and tostring(tv.Value) == tostring(LocalPlayer.Team.Name) then return true end
    return false
end
local function createESP(model)
    if ESP_Objects[model] then return end
    local p = {}
    p.Box = newDrawing("Square"); p.Box.Thickness = 1; p.Box.Filled = false
    p.Line = newDrawing("Line"); p.Line.Thickness = 1
    p.Stick = newDrawing("Line"); p.Stick.Thickness = 1
    p.NameText = newDrawing("Text"); p.NameText.Center = true; p.NameText.Outline = true; p.NameText.Font = 2
    p.DistanceText = newDrawing("Text"); p.DistanceText.Center = true; p.DistanceText.Outline = true; p.DistanceText.Font = 2
    p.HPBarBack = newDrawing("Square"); p.HPBarBack.Filled = true; p.HPBarBack.Color = Color3.fromRGB(0, 0, 0)
    p.HPBar = newDrawing("Square"); p.HPBar.Filled = true
    p.HPText = newDrawing("Text"); p.HPText.Center = true; p.HPText.Outline = true; p.HPText.Font = 2; p.HPText.Size = 13
    p.ItemText = newDrawing("Text"); p.ItemText.Center = true; p.ItemText.Outline = true; p.ItemText.Font = 2; p.ItemText.Size = 13
    p.InventoryText = newDrawing("Text"); p.InventoryText.Center = true; p.InventoryText.Outline = true; p.InventoryText.Font = 2; p.InventoryText.Size = ESP_Config.InventoryTextSize
    ESP_Objects[model] = p
    model.AncestryChanged:Connect(function(_, parent)
        if not parent and ESP_Objects[model] then
            for _, o in pairs(ESP_Objects[model]) do if o and o.Remove then o:Remove() end end
            ESP_Objects[model] = nil
        end
    end)
end
local function w2v(pos)
    local v, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), on, v.Z
end
local function updateESP()
    if not ESP_Config.Enabled then
        for _, p in pairs(ESP_Objects) do setVis(p, false) end
        return
    end
    local cpos = Camera.CFrame.Position
    for model, p in pairs(ESP_Objects) do
        local h, root = getHum(model)
        if not h or not root then setVis(p, false); continue end
        if not root.Parent then setVis(p, false); continue end
        if ESP_Config.DeadCheck and IsDead(model) then setVis(p, false); continue end
        local plr = getPlrFromChar(model)
        local isP = (plr ~= nil)
        if isP and plr and IsWhitelisted(plr) then setVis(p, false); continue end
        if isP and not ESP_Config.ShowPlayers then setVis(p, false); continue end
        if (not isP) and not ESP_Config.ShowNPCs then setVis(p, false); continue end
        local d = (root.Position - cpos).Magnitude
        if d > ESP_Config.MaxDistance then setVis(p, false); continue end
        local ally = isAlly(model)
        if ESP_Config.TeamCheck and ally then setVis(p, false); continue end
        local rp, on, depth = w2v(root.Position)
        if on and depth > 0 then
            local color = ESP_Config.EnemyColor
            if ally then color = ESP_Config.AllyColor
            elseif ESP_Config.UseTeamColor then
                local tc = getTC(model); if tc then color = tc end
            end
            local size = model:GetExtentsSize()
            if ESP_Config.ShowBox then
                local tv, on1 = w2v(root.Position + Vector3.new(0, size.Y / 2, 0))
                local bv, on2 = w2v(root.Position - Vector3.new(0, size.Y / 2, 0))
                if on1 and on2 then
                    local hh = math.abs(tv.Y - bv.Y)
                    local ww = hh / 2
                    p.Box.Size = Vector2.new(ww, hh)
                    p.Box.Position = Vector2.new(rp.X - ww / 2, tv.Y)
                    p.Box.Color = color
                    p.Box.Visible = true
                else p.Box.Visible = false end
            else p.Box.Visible = false end
            if ESP_Config.ShowLine then
                p.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                p.Line.To = rp; p.Line.Color = ESP_Config.LineColor; p.Line.Visible = true
            else p.Line.Visible = false end
            if ESP_Config.ShowStick then
                local hd = model:FindFirstChild("Head") or root
                local hv, ho = w2v(hd.Position)
                local fv, fo = w2v(root.Position - Vector3.new(0, size.Y / 2, 0))
                if ho and fo then
                    p.Stick.From = hv; p.Stick.To = fv
                    p.Stick.Color = ESP_Config.StickColor; p.Stick.Visible = true
                else p.Stick.Visible = false end
            else p.Stick.Visible = false end
            if ESP_Config.ShowName then
                p.NameText.Position = rp - Vector2.new(0, 30)
                p.NameText.Size = ESP_Config.NameTextSize
                p.NameText.Color = color
                p.NameText.Text = model.Name
                p.NameText.Visible = true
            else p.NameText.Visible = false end
            if ESP_Config.ShowDistance then
                p.DistanceText.Position = rp - Vector2.new(0, 15)
                p.DistanceText.Size = ESP_Config.DistanceTextSize
                p.DistanceText.Color = Color3.fromRGB(255, 255, 255)
                p.DistanceText.Text = string.format("[%.0f m]", d)
                p.DistanceText.Visible = true
            else p.DistanceText.Visible = false end
            local byF = rp.Y + 25
            local bhF = ESP_Config.HPBarHeight
            if ESP_Config.ShowHPBar then
                local hp = math.clamp(h.Health / h.MaxHealth, 0, 1)
                local bw, bh = ESP_Config.HPBarWidth, ESP_Config.HPBarHeight
                local bx, by = rp.X - bw / 2, rp.Y + 25
                byF = by
                p.HPBarBack.Size = Vector2.new(bw, bh)
                p.HPBarBack.Position = Vector2.new(bx, by); p.HPBarBack.Visible = true
                p.HPBar.Size = Vector2.new(bw * hp, bh)
                p.HPBar.Position = Vector2.new(bx, by)
                p.HPBar.Color = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
                p.HPBar.Visible = true
                p.HPText.Position = Vector2.new(rp.X, by + bh + 8)
                p.HPText.Color = Color3.fromRGB(255, 255, 255)
                p.HPText.Text = string.format("%.0f / %.0f", h.Health, h.MaxHealth)
                p.HPText.Visible = true
            else
                p.HPBarBack.Visible = false; p.HPBar.Visible = false; p.HPText.Visible = false
            end
            if ESP_Config.ShowEquippedItem then
                local it = getTool(model)
                if it then
                    p.ItemText.Position = rp - Vector2.new(0, 45)
                    p.ItemText.Color = Color3.fromRGB(120, 255, 120)
                    p.ItemText.Text = "[" .. it .. "]"
                    p.ItemText.Visible = true
                else p.ItemText.Visible = false end
            else p.ItemText.Visible = false end
            if ESP_Config.ShowInventory then
                local inv = getInv(model)
                if inv then
                    p.InventoryText.Position = Vector2.new(rp.X, byF + bhF + 25)
                    p.InventoryText.Size = ESP_Config.InventoryTextSize
                    p.InventoryText.Color = Color3.fromRGB(200, 200, 255)
                    p.InventoryText.Text = inv
                    p.InventoryText.Visible = true
                else p.InventoryText.Visible = false end
            else p.InventoryText.Visible = false end
        else
            setVis(p, false)
        end
    end
end
local function scanWorkspace()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local h, r = getHum(plr.Character)
            if h and r then createESP(plr.Character) end
        end
    end
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Model") then
            local h, r = getHum(o)
            if h and r then
                local owner = getPlrFromChar(o)
                if not owner then createESP(o) end
            end
        end
    end
end

--// ==================================================
--// 5. 🍬 BONBON（v9.0 串行 + 零延迟 · 一个一个捡）
--// ==================================================
local function isBonbonName(name)
    if not name then return false end
    return string.find(string.lower(tostring(name)), "bonbon", 1, true) ~= nil
end

local function getBonbonPosition(obj)
    if not obj or not obj.Parent then return nil end
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        local ok, cf = pcall(function() return obj:GetBoundingBox() end)
        if ok and cf then return cf.Position end
        local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
        if pp then return pp.Position end
    end
    return nil
end

local function getBonbonParts(obj)
    local parts = {}
    if obj:IsA("BasePart") then table.insert(parts, obj)
    elseif obj:IsA("Model") then
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
    end
    return parts
end

-- 5.2 Bonbon ESP
local BonbonDrawings = {}
local function createBonbonDrawing(obj)
    if BonbonDrawings[obj] then return BonbonDrawings[obj] end
    local d = { Box = Drawing.new("Square"), Name = Drawing.new("Text"), Dist = Drawing.new("Text") }
    d.Box.Thickness = 1; d.Box.Filled = false; d.Box.Visible = false; d.Box.Color = Color3.fromRGB(255, 165, 0)
    d.Name.Center = true; d.Name.Outline = true; d.Name.Font = 2; d.Name.Size = 14
    d.Name.Color = Color3.fromRGB(255, 165, 0); d.Name.Visible = false
    d.Dist.Center = true; d.Dist.Outline = true; d.Dist.Font = 2; d.Dist.Size = 12
    d.Dist.Color = Color3.fromRGB(255, 255, 255); d.Dist.Visible = false
    BonbonDrawings[obj] = d
    return d
end
local function destroyBonbonDrawing(d)
    if d.Box then d.Box:Remove() end
    if d.Name then d.Name:Remove() end
    if d.Dist then d.Dist:Remove() end
end
local function scanBonbonObjects()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and isBonbonName(obj.Name) then
            createBonbonDrawing(obj)
        end
    end
end
local function renderBonbonESP()
    if not ESP_Config.ShowBonbon then
        for _, d in pairs(BonbonDrawings) do
            d.Box.Visible = false; d.Name.Visible = false; d.Dist.Visible = false
        end
        return
    end
    local camPos = Camera.CFrame.Position
    for obj, d in pairs(BonbonDrawings) do
        if not obj.Parent then
            destroyBonbonDrawing(d); BonbonDrawings[obj] = nil
        else
            local pos = getBonbonPosition(obj)
            if pos then
                local dist = (pos - camPos).Magnitude
                local sp, on = Camera:WorldToViewportPoint(pos)
                if on and dist <= ESP_Config.MaxDistance then
                    local s = Vector2.new(sp.X, sp.Y)
                    d.Box.Size = Vector2.new(20, 20); d.Box.Position = s - Vector2.new(10, 10); d.Box.Visible = true
                    d.Name.Position = s - Vector2.new(0, 20); d.Name.Text = obj.Name; d.Name.Visible = true
                    d.Dist.Position = s + Vector2.new(0, 14); d.Dist.Text = string.format("[%.0f]", dist); d.Dist.Visible = true
                else
                    d.Box.Visible = false; d.Name.Visible = false; d.Dist.Visible = false
                end
            end
        end
    end
end

-- 5.3 快速 firetouchinterest（固定 0.02s yield）
local function fireTouchFast(myPart, targetPart)
    if not myPart or not targetPart or not myPart.Parent or not targetPart.Parent then
        return false
    end
    local origCanTouch = targetPart.CanTouch
    if not origCanTouch then
        pcall(function() targetPart.CanTouch = true end)
    end
    local ok = pcall(firetouchinterest, myPart, targetPart, 0)
    task.wait(ESP_Config.FireTouchYield)
    task.spawn(function()
        pcall(firetouchinterest, myPart, targetPart, 1)
        if not origCanTouch then
            pcall(function() targetPart.CanTouch = origCanTouch end)
        end
    end)
    return ok
end

-- 核心 3 部件 × 糖果全部 Part
local function tryTouchFast(candyObj)
    if type(firetouchinterest) ~= "function" then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local upper = char:FindFirstChild("UpperTorso")
    local head = char:FindFirstChild("Head")
    local myParts = {}
    if hrp then table.insert(myParts, hrp) end
    if upper then table.insert(myParts, upper) end
    if head then table.insert(myParts, head) end
    if #myParts == 0 then return false end

    local candyParts = getBonbonParts(candyObj)
    if #candyParts == 0 then return false end

    local success = false
    for _, candyPart in ipairs(candyParts) do
        if not candyPart.Parent then break end
        for _, myPart in ipairs(myParts) do
            if not myPart.Parent then break end
            if fireTouchFast(myPart, candyPart) then
                success = true
                break
            end
        end
        if success then break end
    end
    return success
end

-- 兜底
local function tryProximityPrompt(obj)
    if type(fireproximityprompt) ~= "function" then return false end
    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not prompt then return false end
    return pcall(fireproximityprompt, prompt)
end
local function tryClickDetector(obj)
    if type(fireclickdetector) ~= "function" then return false end
    local cd = obj:FindFirstChildWhichIsA("ClickDetector", true)
    if not cd then return false end
    return pcall(fireclickdetector, cd, 999999)
end
local function tryRemote(obj)
    local pos = getBonbonPosition(obj)
    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
            local ln = string.lower(d.Name)
            if ln:find("pick") or ln:find("collect") or ln:find("bonbon") or ln:find("candy") then
                local ok
                if d:IsA("RemoteEvent") then
                    ok = pcall(function() d:FireServer(pos, obj) end)
                else
                    ok = pcall(function() d:InvokeServer(pos, obj) end)
                end
                if ok then return true end
            end
        end
    end
    return false
end

-- ============================================
-- 5.4 v9.0 串行拾取引擎（一个一个捡 + 零延迟 + 异步验证）
-- ============================================
local _AutoFarmRunning = false
local _BonbonStats = { success = 0, fail = 0, total = 0 }
_G._BonbonStats = _BonbonStats

local function startAutoFarm()
    if _AutoFarmRunning then return end
    _AutoFarmRunning = true

    task.spawn(function()
        local attemptCount = {}
        local lastAttempt = {}
        local pendingVerify = {}

        while ESP_Config.AutoFarmBonbon do
            local now = tick()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local refPos = hrp and hrp.Position or Camera.CFrame.Position

            -- 1) 实时扫描
            local live = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("Model")) and isBonbonName(obj.Name) then
                    local pos = getBonbonPosition(obj)
                    if pos then
                        live[obj] = { pos = pos, dist = (pos - refPos).Magnitude }
                    end
                end
            end

            -- 2) 验证 pending（异步不阻塞）
            for obj, info in pairs(pendingVerify) do
                if now - info.time > ESP_Config.TouchVerifyWait then
                    if not live[obj] then
                        _BonbonStats.success = _BonbonStats.success + 1
                        attemptCount[obj] = nil
                        lastAttempt[obj] = nil
                    else
                        _BonbonStats.fail = _BonbonStats.fail + 1
                    end
                    pendingVerify[obj] = nil
                end
            end

            -- 3) 清理已消失
            for obj in pairs(attemptCount) do
                if not live[obj] then attemptCount[obj] = nil; lastAttempt[obj] = nil end
            end

            -- 4) 选最近的一个（未在验证中、次数 < 上限、冷却已过）
            local best, bestDist = nil, math.huge
            for obj, info in pairs(live) do
                if not pendingVerify[obj] then
                    local tries = attemptCount[obj] or 0
                    if tries < ESP_Config.TouchPerCandyMaxAttempts then
                        local lastT = lastAttempt[obj] or 0
                        if now - lastT >= ESP_Config.RetryCooldown and info.dist < bestDist then
                            bestDist = info.dist
                            best = obj
                        end
                    end
                end
            end

            -- 5) 只触发这一个（一个一个捡）
            if best then
                attemptCount[best] = (attemptCount[best] or 0) + 1
                lastAttempt[best] = now
                pendingVerify[best] = { time = now, obj = best }
                _BonbonStats.total = _BonbonStats.total + 1

                -- 核心：firetouchinterest
                local touched = false
                pcall(function() touched = tryTouchFast(best) end)

                -- 兜底
                if not touched then
                    if ESP_Config.EnablePrompt then pcall(tryProximityPrompt, best) end
                    if ESP_Config.EnableClick then pcall(tryClickDetector, best) end
                    if ESP_Config.EnableRemote then pcall(tryRemote, best) end
                end
            end

            task.wait(ESP_Config.AutoFarmBonbonDelay)
        end
        _AutoFarmRunning = false
    end)
end

-- 诊断
local function diagnoseBonbon(obj)
    print("========== Bonbon 诊断 ==========")
    print("Name:", obj.Name, "| Class:", obj.ClassName)
    print("Position:", tostring(getBonbonPosition(obj)))
    print("--- Parts ---")
    for _, part in ipairs(getBonbonParts(obj)) do
        print(string.format("  %s | Anchored=%s | CanTouch=%s | CanCollide=%s",
            part.Name, tostring(part.Anchored), tostring(part.CanTouch), tostring(part.CanCollide)))
        if type(getconnections) == "function" then
            local ok, conns = pcall(getconnections, part.Touched)
            if ok and conns then print("    Touched connections:", #conns) end
        end
    end
    print("--- Prompts ---")
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("ProximityPrompt") then print("  ProximityPrompt | HoldDuration=", d.HoldDuration)
        elseif d:IsA("ClickDetector") then print("  ClickDetector") end
    end
    print("=================================")
end

scanBonbonObjects()
workspace.DescendantAdded:Connect(function(obj)
    if (obj:IsA("BasePart") or obj:IsA("Model")) and isBonbonName(obj.Name) then
        task.wait(0.1)
        if obj.Parent then createBonbonDrawing(obj) end
    end
end)

--// ==================================================
--// 6. HOOKS（Silent Aim / BulletTP）
--// ==================================================
local function applyBulletTeleport(origin, targetPart)
    if not _G.BulletTP or not targetPart then return origin end
    if not targetPart.Parent then return origin end
    local tp = targetPart.Position
    local dir = tp - origin
    if dir.Magnitude < 0.05 then return tp end
    return tp - dir.Unit * 1.5
end

if not oldNamecall then
    pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if not _G.SilentAim or not TargetPart or not CurrentTarget
               or not TargetPart.Parent or not CurrentTarget.Parent then
                return oldNamecall(self, ...)
            end
            local method = getnamecallmethod()
            local args = {...}

            if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
                local sn = self.Name:lower()
                if string.find(sn, "fire") or string.find(sn, "hit") or string.find(sn, "attack")
                   or string.find(sn, "damage") or string.find(sn, "shoot") or string.find(sn, "swing")
                   or string.find(sn, "launch") or string.find(sn, "rocket") or string.find(sn, "grenade") or string.find(sn, "turret") then
                    if not ShouldHit() then return oldNamecall(self, ...) end

                    local newArgs = {}
                    local modified = false
                    local firstVec, firstVecIndex = nil, nil

                    for i, a in pairs(args) do
                        if typeof(a) == "Vector3" then firstVecIndex = i; firstVec = a; break end
                    end

                    local newOrigin = nil
                    if firstVec then
                        if _G.BulletTP then newOrigin = applyBulletTeleport(firstVec, TargetPart)
                        else newOrigin = TargetPart.Position end
                    end

                    for i, a in pairs(args) do
                        if typeof(a) == "Vector3" then
                            if i == firstVecIndex then
                                newArgs[i] = newOrigin; modified = true
                            else
                                local origLen = a.Magnitude
                                if origLen < 0.001 then origLen = 1 end
                                if newOrigin then
                                    newArgs[i] = (TargetPart.Position - newOrigin).Unit * origLen
                                else
                                    newArgs[i] = (TargetPart.Position - Camera.CFrame.Position).Unit * origLen
                                end
                                modified = true
                            end
                        elseif typeof(a) == "CFrame" then
                            if _G.BulletTP then
                                local base = a.Position
                                local nOrig = applyBulletTeleport(base, TargetPart)
                                newArgs[i] = CFrame.new(nOrig, TargetPart.Position)
                            else
                                newArgs[i] = CFrame.new(a.Position, TargetPart.Position)
                            end
                            modified = true
                        elseif typeof(a) == "Ray" then
                            local nOrig
                            if _G.BulletTP then nOrig = applyBulletTeleport(a.Origin, TargetPart)
                            else nOrig = a.Origin end
                            newArgs[i] = Ray.new(nOrig, (TargetPart.Position - nOrig).Unit * 1000)
                            modified = true
                        else newArgs[i] = a end
                    end
                    if modified then return oldNamecall(self, unpack(newArgs)) end
                end
            end

            if method == "Raycast" and self == workspace then
                local orig, dir = args[1], args[2]
                if typeof(orig) == "Vector3" and typeof(dir) == "Vector3" then
                    if not ShouldHit() then return oldNamecall(self, ...) end
                    local nOrig = _G.BulletTP and applyBulletTeleport(orig, TargetPart) or orig
                    local nDir = (TargetPart.Position - nOrig).Unit * dir.Magnitude
                    local newArgs = {nOrig, nDir}
                    for i = 3, #args do newArgs[i] = args[i] end
                    return oldNamecall(self, unpack(newArgs))
                end
            end

            return oldNamecall(self, ...)
        end)
    end)
end

if not oldIndex then
    pcall(function()
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            return oldIndex(self, key)
        end)
    end)
end

task.spawn(function()
    task.wait(1)
    while true do
        pcall(function() UpdateCaches() end)
        task.wait(CacheUpdateInterval)
    end
end)

task.spawn(function()
    while true do
        task.wait(_G.UpdateRate)
        RefreshFrameCache()
        if _G.SilentAim then pcall(function() CurrentTarget = GetTarget() end)
        else CurrentTarget = nil; TargetInRange = false; TargetPart = nil end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.SilentAim and CurrentTarget and CurrentTarget.Parent then
        local h = CurrentTarget:FindFirstChildOfClass("Humanoid")
        if not h or h.Health <= 0 then
            NPCCache[CurrentTarget] = nil; PlayerCache[CurrentTarget] = nil
            CurrentTarget = nil; TargetPart = nil
        end
    end

    pcall(function()
        Circle.Visible = _G.SilentAim
        if _G.SilentAim then
            local targetColor
            if CurrentTarget and CurrentTarget.Parent then
                targetColor = _currentIsPlayer and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(0, 255, 0)
            elseif TargetInRange then targetColor = Color3.fromRGB(255, 255, 0)
            else targetColor = Color3.fromRGB(255, 50, 0) end
            if targetColor ~= _lastCircleColor then
                Circle.Color = targetColor; _lastCircleColor = targetColor
            end
            Circle.Position = _cachedCenter
            Circle.Radius = _G.FOV
        else Circle.Visible = false end

        _tiCounter = _tiCounter + 1
        if _tiCounter % TI_FREQ == 0 then UpdateTargetInfo() end
        _hlCounter = _hlCounter + 1
        if _hlCounter % HL_FREQ == 0 then UpdateHighlight() end
        _espCounter = _espCounter + 1
        if _espCounter % 2 == 0 then updateESP() end
        renderBonbonESP()
    end)
end)

scanWorkspace()

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        local h, r = getHum(char)
        if h and r then createESP(char) end
    end)
end)
for _, plr in pairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        local h, r = getHum(char)
        if h and r then createESP(char) end
    end)
end
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") then
        task.wait(0.2)
        local h, r = getHum(obj)
        if h and r then
            local owner = getPlrFromChar(obj)
            if not owner then createESP(obj) end
        end
    end
end)
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then CleanupUIOnly() end
end)

--// ==================================================
--// 7. UI（完整版）
--// ==================================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = 'Universal Pro v9.5',
    Center = true, AutoShow = true, TabPadding = 8, MenuFadeTime = 0.2
})

local Tabs = {
    Aim = Window:AddTab('Silent Aim'),
    ESP = Window:AddTab('ESP Pro'),
    Bypass = Window:AddTab('Bypass & Extra'),
    Save = Window:AddTab('SAVE 📁')
}

--// [ TAB 1: SILENT AIM ] //--
local AimMainBox = Tabs.Aim:AddLeftGroupbox('主控制')
AimMainBox:AddToggle('ToggleSilentAim', { Text = '启用 Silent Aim', Default = false, Callback = function(Value)
    _G.SilentAim = Value
    if Value then
        LastCacheUpdate = 0; pcall(function() UpdateCaches() end)
        Library:Notify('🎯 SILENT AIM 已启用', 1.5)
    else
        if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight = nil end
        if _DiedConn then _DiedConn:Disconnect(); _DiedConn = nil end
        Library:Notify('🎯 SILENT AIM 已关闭', 1.5)
    end
end})
AimMainBox:AddSlider('FOVSlider', { Text = 'FOV', Default = 150, Min = 50, Max = 300, Rounding = 0, Callback = function(Value) _G.FOV = Value; Circle.Radius = Value end })
AimMainBox:AddSlider('PredSlider', { Text = '预判（基础时间）', Default = 0.165, Min = 0, Max = 0.5, Rounding = 3, Callback = function(Value) _G.Prediction = Value end })
AimMainBox:AddSlider('ChanceSlider', { Text = '命中率', Default = 100, Min = 0, Max = 100, Rounding = 0, Callback = function(Value) _G.HitChance = Value end })
AimMainBox:AddSlider('UpdateSlider', { Text = '更新频率', Default = 0.01, Min = 0, Max = 0.5, Rounding = 2, Callback = function(Value) _G.UpdateRate = Value end })

local AimLogicBox = Tabs.Aim:AddLeftGroupbox('目标逻辑')
AimLogicBox:AddDropdown('PriorityDrop', { Values = {'Crosshair', 'Distance', 'LowestHP'}, Default = 1, Multi = false, Text = '优先级模式', Callback = function(Value) _G.TargetPriority = Value; CurrentTarget = nil end })
AimLogicBox:AddToggle('StickyAim', { Text = 'Sticky Aim（锁定目标）', Default = true, Callback = function(Value) _G.StickyAim = Value end })
AimLogicBox:AddToggle('AutoPrediction', { Text = '自动预判（按距离）', Default = true, Callback = function(Value) _G.AutoPrediction = Value end })
AimLogicBox:AddDropdown('TargetDrop', { Values = {'NPCs', 'Players', 'Both'}, Default = 1, Multi = false, Text = '目标模式', Callback = function(Value) _G.TargetMode = Value end })
AimLogicBox:AddDropdown('PartDrop', { Values = {'Head', 'Torso', 'Both', 'Random'}, Default = 1, Multi = false, Text = '瞄准部位', Callback = function(Value) _G.AimPart = Value end })
AimLogicBox:AddToggle('WallCheck', { Text = '墙体检测（可见性）', Default = true, Callback = function(Value) _G.VisibleCheck = Value end })
AimLogicBox:AddToggle('DeadCheckAim', { Text = '忽略尸体', Default = true, Callback = function(Value) _G.DeadCheck = Value end })

local AimDistanceBox = Tabs.Aim:AddLeftGroupbox('距离限制')
AimDistanceBox:AddToggle('EnableDistanceLimit', { Text = '启用距离限制', Default = true, Callback = function(Value) _G.EnableDistanceLimit = Value end })
AimDistanceBox:AddSlider('MaxAimDistance', { Text = '最大距离（studs）', Default = 500, Min = 50, Max = 2000, Rounding = 0, Callback = function(Value) _G.MaxAimDistance = Value end })

local AimFriendBox = Tabs.Aim:AddLeftGroupbox('好友保护')
AimFriendBox:AddToggle('FriendCheckToggle', { Text = '忽略好友', Default = true, Callback = function(Value) _G.FriendCheck = Value end })

local AimNPCBox = Tabs.Aim:AddLeftGroupbox('NPC 设置')
AimNPCBox:AddToggle('EnableNPCKeywordFilter', { Text = '🔛 启用 NPC 关键字过滤', Default = false, Callback = function(Value) _G.NPCKeywordFilterEnabled = Value; LastCacheUpdate = 0 end })
local NPCKeywordInput = AimNPCBox:AddInput('NPCKeywordInput', { Default = 'dog', Text = 'NPC 名称关键字', Placeholder = '例如 dog 或 dog,cat,enemy', Numeric = false, Finished = false, Callback = function(Value) _G.NPCKeywordFilter = tostring(Value or ""); LastCacheUpdate = 0 end })
AimNPCBox:AddButton('🗑️ 清除关键字', function()
    _G.NPCKeywordFilter = ""
    pcall(function() NPCKeywordInput:SetValue("") end)
    LastCacheUpdate = 0; Library:Notify('🗑️ 已清除', 2)
end)
AimNPCBox:AddButton('🔄 重置为 dog', function()
    _G.NPCKeywordFilter = "dog"
    pcall(function() NPCKeywordInput:SetValue("dog") end)
    LastCacheUpdate = 0; Library:Notify('🔄 已重置', 2)
end)
AimNPCBox:AddToggle('AgressiveNPC', { Text = '激进 NPC 模式', Default = false, Callback = function(Value) _G.AggressiveNPCDetection = Value; LastCacheUpdate = 0; pcall(function() UpdateCaches() end) end })
AimNPCBox:AddToggle('DebugNPCs', { Text = 'Debug NPCs', Default = false, Callback = function(Value) _G.DebugNPCs = Value end })
AimNPCBox:AddInput('CacheInterval', { Default = '1.0', Numeric = true, Finished = true, Text = '缓存间隔（秒）', Callback = function(Value) local num = tonumber(Value); if num and num > 0 then CacheUpdateInterval = num end end })
AimNPCBox:AddButton('强制刷新缓存', function() LastCacheUpdate = 0; pcall(function() UpdateCaches() end); Library:Notify('缓存已刷新！', 1) end)

local AimListBox = Tabs.Aim:AddRightGroupbox('玩家列表')
local function GetServerPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then table.insert(names, plr.Name) end
    end
    table.sort(names); return names
end
local function ParseMulti(Value)
    local out = {}
    if type(Value) ~= "table" then return out end
    for k, v in pairs(Value) do
        if v == true and type(k) == "string" then table.insert(out, k)
        elseif type(v) == "string" then table.insert(out, v) end
    end
    return out
end
local WhiteListDropdown = AimListBox:AddDropdown('WL_Dropdown', { Values = GetServerPlayerNames(), Default = {}, Multi = true, Text = '⚪ 白名单', Callback = function(Value) _G.Whitelist = ParseMulti(Value); task.spawn(function() updateESP() end) end })
local BlackListDropdown = AimListBox:AddDropdown('BL_Dropdown', { Values = GetServerPlayerNames(), Default = {}, Multi = true, Text = '⚫ 黑名单', Callback = function(Value) _G.Blacklist = ParseMulti(Value); CurrentTarget = nil end })
AimListBox:AddButton('🗑️ 清空白名单', function() _G.Whitelist = {}; pcall(function() WhiteListDropdown:SetValues(GetServerPlayerNames()) end) end)
AimListBox:AddButton('🗑️ 清空黑名单', function() _G.Blacklist = {}; pcall(function() BlackListDropdown:SetValues(GetServerPlayerNames()) end) end)
AimListBox:AddButton('🗑️ 清空全部', function() _G.Whitelist = {}; _G.Blacklist = {}; pcall(function() WhiteListDropdown:SetValues(GetServerPlayerNames()) end); pcall(function() BlackListDropdown:SetValues(GetServerPlayerNames()) end) end)
AimListBox:AddButton('🔄 刷新玩家列表', function() local n = GetServerPlayerNames(); pcall(function() WhiteListDropdown:SetValues(n) end); pcall(function() BlackListDropdown:SetValues(n) end) end)

task.spawn(function()
    task.wait(1)
    local lastKey = ""
    while task.wait(2) do
        local names = GetServerPlayerNames()
        local key = table.concat(names, "|")
        if key ~= lastKey then
            lastKey = key
            local valid = {}
            for _, n in ipairs(names) do valid[n] = true end
            local wlChanged, blChanged = false, false
            local newWL, newBL = {}, {}
            for _, n in ipairs(_G.Whitelist) do if valid[tostring(n)] then table.insert(newWL, n) else wlChanged = true end end
            for _, n in ipairs(_G.Blacklist) do if valid[tostring(n)] then table.insert(newBL, n) else blChanged = true end end
            if wlChanged then _G.Whitelist = newWL end
            if blChanged then _G.Blacklist = newBL end
            if #_G.Whitelist == 0 then pcall(function() WhiteListDropdown:SetValues(names) end) end
            if #_G.Blacklist == 0 then pcall(function() BlackListDropdown:SetValues(names) end) end
        end
    end
end)

local AimBulletTPBox = Tabs.Aim:AddRightGroupbox('Bullet Teleport')
AimBulletTPBox:AddToggle('ToggleBulletTP', { Text = '启用 Bullet Teleport', Default = false, Callback = function(Value) _G.BulletTP = Value end })

local AimInfoBox = Tabs.Aim:AddRightGroupbox('视觉效果')
AimInfoBox:AddLabel('FOV 颜色'):AddColorPicker('FOVColor', { Default = Color3.fromRGB(0, 255, 0), Title = 'FOV', Callback = function(Value) _G.FOVColor = Value; Circle.Color = Value end })
AimInfoBox:AddToggle('HighlightTgt', { Text = '目标高亮', Default = false, Callback = function(Value) _G.HighlightTarget = Value end })
AimInfoBox:AddLabel('NPC 高亮颜色'):AddColorPicker('HNPCColor', { Default = Color3.fromRGB(255, 50, 50), Title = 'NPC', Callback = function(Value) _G.HighlightNPCColor = Value; UpdateHighlight() end })
AimInfoBox:AddLabel('玩家高亮颜色'):AddColorPicker('HPlrColor', { Default = Color3.fromRGB(50, 150, 255), Title = 'Player', Callback = function(Value) _G.HighlightPlayerColor = Value; UpdateHighlight() end })
AimInfoBox:AddToggle('ShowTargetInfo', { Text = '显示目标信息', Default = true, Callback = function(Value) _G.ShowTarget = Value end })
AimInfoBox:AddToggle('InfoName', { Text = '名称/类型', Default = true, Callback = function(Value) _G.ShowTargetName = Value; UpdateTargetInfo() end })
AimInfoBox:AddToggle('InfoHP', { Text = 'HP', Default = true, Callback = function(Value) _G.ShowTargetHP = Value; UpdateTargetInfo() end })
AimInfoBox:AddToggle('InfoDist', { Text = '距离', Default = true, Callback = function(Value) _G.ShowTargetDistance = Value; UpdateTargetInfo() end })
AimInfoBox:AddToggle('InfoChance', { Text = '命中率', Default = true, Callback = function(Value) _G.ShowHitChance = Value; UpdateTargetInfo() end })
AimInfoBox:AddButton('清空 UI', function() CleanupUIOnly() end)

local AimTeamBox = Tabs.Aim:AddRightGroupbox('队伍')
AimTeamBox:AddToggle('TeamCheckPlr', { Text = '队伍检查（玩家）', Default = true, Callback = function(Value) _G.TeamCheck = Value end })
AimTeamBox:AddToggle('TeamCheckNPC', { Text = '队伍检查（NPC）', Default = false, Callback = function(Value) _G.TeamCheckForNPCs = Value end })

--// [ TAB 2: ESP + 零延迟糖果 ] //--
local ESPMainBox = Tabs.ESP:AddLeftGroupbox('ESP 主控制')
ESPMainBox:AddToggle('ToggleESP', { Text = '启用 ESP', Default = false, Callback = function(Value) ESP_Config.Enabled = Value end })
ESPMainBox:AddToggle('ESPPlayers', { Text = '显示玩家', Default = true, Callback = function(Value) ESP_Config.ShowPlayers = Value end })
ESPMainBox:AddToggle('ESPNPCs', { Text = '显示 NPC', Default = true, Callback = function(Value) ESP_Config.ShowNPCs = Value end })
ESPMainBox:AddToggle('ESPTeamCheck', { Text = '队伍检查', Default = true, Callback = function(Value) ESP_Config.TeamCheck = Value end })
ESPMainBox:AddToggle('ESPTeamColor', { Text = '使用队伍颜色', Default = true, Callback = function(Value) ESP_Config.UseTeamColor = Value end })
ESPMainBox:AddToggle('ESPDeadCheck', { Text = '隐藏尸体', Default = true, Callback = function(Value) ESP_Config.DeadCheck = Value end })
ESPMainBox:AddToggle('ESPShowBonbon', { Text = '🍬 显示 Bonbon 糖果', Default = false, Callback = function(Value) ESP_Config.ShowBonbon = Value end })

local ESPElemsBox = Tabs.ESP:AddLeftGroupbox('视觉元素')
ESPElemsBox:AddToggle('EBox', { Text = 'Box', Default = true, Callback = function(Value) ESP_Config.ShowBox = Value end })
ESPElemsBox:AddToggle('ELine', { Text = '连线', Default = true, Callback = function(Value) ESP_Config.ShowLine = Value end })
ESPElemsBox:AddToggle('EStick', { Text = 'Stick', Default = true, Callback = function(Value) ESP_Config.ShowStick = Value end })
ESPElemsBox:AddToggle('EName', { Text = '名称', Default = true, Callback = function(Value) ESP_Config.ShowName = Value end })
ESPElemsBox:AddToggle('EDist', { Text = '距离', Default = true, Callback = function(Value) ESP_Config.ShowDistance = Value end })
ESPElemsBox:AddToggle('EHP', { Text = 'HP 条', Default = true, Callback = function(Value) ESP_Config.ShowHPBar = Value end })
ESPElemsBox:AddToggle('EEquip', { Text = '装备物品', Default = true, Callback = function(Value) ESP_Config.ShowEquippedItem = Value end })
ESPElemsBox:AddToggle('EInv', { Text = '背包', Default = false, Callback = function(Value) ESP_Config.ShowInventory = Value end })

-- 🍬 糖果（只有开关 + 诊断，参数全固定）
local BonbonBox = Tabs.ESP:AddRightGroupbox('🍬 糖果拾取（⚡ 串行零延迟）')
BonbonBox:AddToggle('AutoFarmBonbon', {
    Text = '⚡ 自动拾取糖果（一个一个捡）',
    Default = false,
    Tooltip = '每次只选最近的一个糖果触发，触发后异步验证，失败固定短冷却重试，最多 5 次',
    Callback = function(Value)
        ESP_Config.AutoFarmBonbon = Value
        if Value then
            startAutoFarm()
            local n = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("Model")) and isBonbonName(obj.Name) then n = n + 1 end
            end
            Library:Notify(string.format('⚡ 串行拾取已启用（%d 个糖果，一个一个捡）', n), 3)
        else
            local s = _BonbonStats
            Library:Notify(string.format('🍬 已停止 | ✅%d / ❌%d', s.success, s.fail), 3)
        end
    end
})
BonbonBox:AddButton('🔍 诊断糖果', function()
    local count = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and isBonbonName(obj.Name) then
            diagnoseBonbon(obj); count = count + 1
            if count >= 3 then break end
        end
    end
    Library:Notify(count > 0 and ('✅ 输出 ' .. count .. ' 个糖果诊断') or '❌ 未找到糖果', 3)
end)
BonbonBox:AddButton('🧹 清理糖果 ESP', function()
    for obj, d in pairs(BonbonDrawings) do
        destroyBonbonDrawing(d)
        BonbonDrawings[obj] = nil
    end
    Library:Notify('🧹 已清理', 2)
end)
BonbonBox:AddLabel('💡 固定参数：串行触发 · 0.02s 轮询 · 0.12s 冷却 · 0.2s 验证')

local ESPSizesBox = Tabs.ESP:AddRightGroupbox('尺寸与距离')
ESPSizesBox:AddSlider('ESPMaxDist', { Text = '最大距离', Default = 2500, Min = 500, Max = 5000, Rounding = 0, Compact = false, Callback = function(Value) ESP_Config.MaxDistance = Value end })
ESPSizesBox:AddSlider('ESPNameS', { Text = '名称字号', Default = 16, Min = 8, Max = 30, Rounding = 0, Compact = true, Callback = function(Value) ESP_Config.NameTextSize = Value end })
ESPSizesBox:AddSlider('ESPDistS', { Text = '距离字号', Default = 14, Min = 8, Max = 30, Rounding = 0, Compact = true, Callback = function(Value) ESP_Config.DistanceTextSize = Value end })
ESPSizesBox:AddSlider('ESPInvS', { Text = '背包字号', Default = 13, Min = 8, Max = 30, Rounding = 0, Compact = true, Callback = function(Value) ESP_Config.InventoryTextSize = Value end })

local ESPColorsBox = Tabs.ESP:AddRightGroupbox('ESP 颜色')
ESPColorsBox:AddLabel('敌人'):AddColorPicker('CEnemy', { Default = Color3.fromRGB(255, 80, 80), Title = '敌人', Callback = function(Value) ESP_Config.EnemyColor = Value end })
ESPColorsBox:AddLabel('队友'):AddColorPicker('CAlly', { Default = Color3.fromRGB(80, 255, 80), Title = '队友', Callback = function(Value) ESP_Config.AllyColor = Value end })
ESPColorsBox:AddLabel('连线'):AddColorPicker('CLine', { Default = Color3.fromRGB(255, 255, 0), Title = '连线', Callback = function(Value) ESP_Config.LineColor = Value end })
ESPColorsBox:AddLabel('Stick'):AddColorPicker('CStick', { Default = Color3.fromRGB(255, 255, 255), Title = 'Stick', Callback = function(Value) ESP_Config.StickColor = Value end })

--// [ TAB 3: BYPASS & EXTRA ] //--
local BypassBox = Tabs.Bypass:AddLeftGroupbox('反作弊 Bypass')
BypassBox:AddToggle('AdonisBypassToggle', { Text = 'Bypass Adonis 反作弊', Default = true, Callback = function(Value) _G.AdonisBypass = Value end })
BypassBox:AddLabel('⚠️ 拦截客户端发往 Adonis Remote 的 FireServer')

local ExtraBox = Tabs.Bypass:AddLeftGroupbox('附加功能')
ExtraBox:AddButton('🔄 强制重新应用 Bypass', function()
    task.spawn(function() BypassAdonis(); Library:Notify('🔄 Bypass 已重新应用！', 2) end)
end)
ExtraBox:AddLabel('🛡️ Anti-Kick: ' .. tostring(AntiKickEnabled))
if antiKickLoaded then ExtraBox:AddLabel('✅ Anti-Kick 优化版已加载！')
else ExtraBox:AddLabel('⚠️ 使用 Anti-Kick 回退') end

--// [ TAB 4: SAVE ] //--
local SaveTab = Tabs.Save
Library:SetWatermark('Universal Pro v9.5')
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('UniversalPro')
SaveManager:SetFolder('UniversalPro/main')
SaveManager:BuildConfigSection(SaveTab)
ThemeManager:BuildThemeManager(SaveTab)

SaveTab:AddLabel('📁 配置管理')
SaveTab:AddButton('💾 保存配置', function() SaveManager:Save(); Library:Notify('✅ 已保存！', 2) end)
SaveTab:AddButton('📂 加载配置', function() SaveManager:Load(); Library:Notify('✅ 已加载！', 2) end)
SaveTab:AddButton('🔄 重置配置', function() SaveManager:Reset(); Library:Notify('🔄 已重置！', 2) end)
SaveTab:AddLabel('🎨 主题')
SaveTab:AddButton('🔄 重新加载主题', function() ThemeManager:Load(); Library:Notify('🎨 主题已重新加载！', 2) end)

Library:Notify('✅ UNIVERSAL PRO v9.5 已加载！', 5)
print("[Universal Pro] v9.5 - 完整功能 + v9.0 串行拾取 + 零延迟")
