--[[
    🎯 UNIVERSAL PRO SCRIPT v5.8 (v5.7 + 修复选中目标崩溃)
    Fix: TargetPart/CurrentTarget 销毁后访问 .Position 崩溃
    其他一切保持 v5.7 原样
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
_G.TargetPriority = "Distance"
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

getgenv().ESP_Config = {
    Enabled = false,
    ShowPlayers = true,
    ShowNPCs = true,
    TeamCheck = true,
    DeadCheck = true,
    MaxDistance = 2500,
    NameTextSize = 16,
    DistanceTextSize = 14,
    InventoryTextSize = 13,
    HPBarWidth = 60,
    HPBarHeight = 6,
    ShowBox = true,
    ShowLine = true,
    ShowStick = true,
    ShowName = true,
    ShowDistance = true,
    ShowHPBar = true,
    ShowEquippedItem = true,
    ShowInventory = false,
    UseTeamColor = true,
    EnemyColor = Color3.fromRGB(255, 80, 80),
    AllyColor  = Color3.fromRGB(80, 255, 80),
    LineColor  = Color3.fromRGB(255, 255, 0),
    StickColor = Color3.fromRGB(255, 255, 255)
}

--// ==================================================
--// 1.5 ANTI-KICK
--// ==================================================
local AntiKickEnabled = true
local antiKickLoaded = false
pcall(function()
    local s = game:HttpGet("https://rawscripts.net/raw/Universal-Script-Adonis-Bypass-45451")
    if s and #s > 0 then
        task.spawn(function()
            local f = loadstring(s)
            if f then
                local ok = pcall(f)
                if ok then antiKickLoaded = true end
            end
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

--// ==================================================
--// 1.6 ADONIS BYPASS
--// ==================================================
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
        print("[Universal Pro] Adonis Anti-Cheat detectado! Aplicando bypass...")
        for _, n in pairs({"Adonis_Remote","Adonis_AntiCheat","Adonis_Check","Adonis_Validate","Adonis_Log","Adonis_Event"}) do
            local r = ReplicatedStorage:FindFirstChild(n)
            if r and r:IsA("RemoteEvent") then r.OnServerEvent:Connect(function() return end) end
        end
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
        task.spawn(function()
            while task.wait(0.5) do
                pcall(function()
                    if getgenv and getgenv().Adonis then getgenv().Adonis.Detected = false end
                    local ls = game:GetService("LogService")
                    for _, log in pairs(ls:GetLogHistory()) do
                        if string.find(log.message, "Universal Pro") or string.find(log.message, "Silent Aim") then log.message = "" end
                    end
                end)
            end
        end)
        print("[Universal Pro] ✅ Bypass do Adonis aplicado!")
    end
end
task.spawn(function() task.wait(2); BypassAdonis() end)

--// ==================================================
--// 2. SERVIÇOS E VARIÁVEIS
--// ==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Circle = Drawing.new("Circle")
Circle.Color = _G.FOVColor
Circle.Thickness = 2
Circle.Visible = false
Circle.Radius = _G.FOV
Circle.Transparency = 0.7
Circle.Filled = false

local TargetInfo = Drawing.new("Text")
TargetInfo.Visible = false
TargetInfo.Color = Color3.fromRGB(255, 255, 255)
TargetInfo.Size = 18
TargetInfo.Font = 2
TargetInfo.Outline = true
TargetInfo.OutlineColor = Color3.fromRGB(0, 0, 0)
TargetInfo.Text = ""

local TargetHighlight, HighlightConnection = nil, nil
local CurrentTarget, TargetPart, TargetInRange = nil, nil, false
local NPCCache, PlayerCache = {}, {}
local LastCacheUpdate = 0
local CacheUpdateInterval = 2
local oldNamecall, oldIndex = nil, nil
local ESP_Objects = {}
local _InAimHook = false

--// ==================================================
--// 3. FUNÇÕES DO SILENT AIM
--// ==================================================
local function IsDead(c)
    if not c then return true end
    if not c.Parent then return true end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return true end
    if not h.Parent then return true end
    if h.Health <= 0 then return true end
    if h:GetState() == Enum.HumanoidStateType.Dead then return true end
    local be = c:FindFirstChild("BodyEffects")
    if be and be:FindFirstChild("K.O") and be["K.O"].Value == true then return true end
    local ko = c:FindFirstChild("K.O") or c:FindFirstChild("KO")
    if ko and (ko:IsA("BoolValue") or ko:IsA("IntValue")) and (ko.Value == true or ko.Value > 0) then return true end
    return false
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
    for _, c in ipairs(m:GetChildren()) do
        if c.Name then table.insert(names, tostring(c.Name)) end
    end
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
    local root = c:FindFirstChild("HumanoidRootPart")
        or c:FindFirstChild("Torso")
        or c:FindFirstChild("UpperTorso")
    if not root then return false end
    return true
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
    local all, seen = {}, {}
    local counter = 0
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("Model") and o ~= LocalPlayer.Character and not seen[o] then
            seen[o] = true
            table.insert(all, o)
        end
        counter = counter + 1
        if counter % 500 == 0 then task.wait() end
    end
    local pc = 0
    for _, m in pairs(all) do
        pc = pc + 1
        if pc % 200 == 0 then task.wait() end
        local hrp = m:FindFirstChild("HumanoidRootPart")
            or m:FindFirstChild("Torso")
            or m:FindFirstChild("UpperTorso")
        local h = m:FindFirstChildOfClass("Humanoid")
        if hrp and h and not (_G.DeadCheck and IsDead(m)) then
            if IsPlayer(m) then
                local plr = Players:GetPlayerFromCharacter(m)
                if not IsWhitelisted(plr) then
                    tplr[m] = {Model = m, HRP = hrp, Humanoid = h, Player = plr, IsNPC = false}
                end
            elseif IsNPC(m) then
                tnpc[m] = {Model = m, HRP = hrp, Humanoid = h, IsNPC = true}
            end
        end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
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

local function ValidateCurrentTarget()
    if not CurrentTarget or not TargetPart then return false end
    if not CurrentTarget.Parent then return false end
    if not TargetPart.Parent then return false end
    local h = CurrentTarget:FindFirstChildOfClass("Humanoid")
    local hrp = CurrentTarget:FindFirstChild("HumanoidRootPart")
        or CurrentTarget:FindFirstChild("Torso")
        or CurrentTarget:FindFirstChild("UpperTorso")
    if not h or not hrp then return false end
    if _G.DeadCheck and IsDead(CurrentTarget) then
        NPCCache[CurrentTarget] = nil
        PlayerCache[CurrentTarget] = nil
        return false
    end
    local blActive = #_G.Blacklist > 0
    local tp = Players:GetPlayerFromCharacter(CurrentTarget)
    local isBL = tp and IsBlacklisted(tp) or false
    if blActive and not isBL then return false end
    if tp == nil and not isBL and not MatchesNPCKeyword(CurrentTarget) then return false end
    if not isBL and _G.EnableDistanceLimit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if (TargetPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > _G.MaxAimDistance then return false end
    end
    local sc = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local sp, on = Camera:WorldToViewportPoint(TargetPart.Position)
    if not on then return false end
    if (Vector2.new(sp.X, sp.Y) - sc).Magnitude > _G.FOV then return false end
    if _G.VisibleCheck and not isBL then
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
        rp.FilterType = Enum.RaycastFilterType.Blacklist
        rp.IgnoreWater = true
        local orig = Camera.CFrame.Position
        local dir = TargetPart.Position - orig
        local ray = workspace:Raycast(orig, dir.Unit * dir.Magnitude, rp)
        if ray and not ray.Instance:IsDescendantOf(CurrentTarget) then return false end
    end
    return true
end

local function GetTarget()
    if not LocalPlayer.Character then TargetInRange = false; TargetPart = nil; return nil end
    if not _InAimHook then
        UpdateCaches()
    end
    if _G.StickyAim and CurrentTarget then
        if ValidateCurrentTarget() then TargetInRange = true; return CurrentTarget
        else CurrentTarget = nil; TargetPart = nil end
    end
    local best = math.huge
    local bPart, bModel = nil, nil
    local sc = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local lChar = LocalPlayer.Character
    local lRoot = lChar:FindFirstChild("HumanoidRootPart")
    TargetInRange = false; TargetPart = nil
    if not lRoot then return nil end
    local blActive = #_G.Blacklist > 0
    local deadList = {}
    local function PT(data, isPlayer)
        local hrp = data.HRP
        local h = data.Humanoid
        if not (hrp and h) then return end
        -- ✅ 修复：HRP 被销毁时安全跳过，避免 .Position 崩溃
        if not hrp.Parent then
            table.insert(deadList, data.Model)
            return
        end
        if not data.Model.Parent then
            table.insert(deadList, data.Model)
            return
        end
        if _G.DeadCheck and IsDead(data.Model) then
            table.insert(deadList, data.Model)
            return
        end
        local isBL = false
        if isPlayer then
            if IsWhitelisted(data.Player) then return end
            if blActive then
                if not IsBlacklisted(data.Player) then return end
                isBL = true
            else
                if not IsEnemyPlayer(data.Player) then return end
            end
        else
            if blActive then return end
            if not IsEnemyNPC(data.Model) then return end
            if not MatchesNPCKeyword(data.Model) then return end
        end
        if _G.EnableDistanceLimit and not isBL then
            if (hrp.Position - lRoot.Position).Magnitude > _G.MaxAimDistance then return end
        end
        local part = GetTargetPart(data.Model) or hrp
        if not part.Parent then
            table.insert(deadList, data.Model)
            return
        end
        local pos = part.Position
        if hrp.Velocity.Magnitude > 1 and _G.Prediction > 0 then pos = pos + hrp.Velocity * _G.Prediction end
        local sp, on = Camera:WorldToViewportPoint(pos)
        if not on then return end
        local dfc = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
        if dfc > _G.FOV then return end
        local vis = true
        if _G.VisibleCheck and not isBL then
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {lChar, Camera}
            rp.FilterType = Enum.RaycastFilterType.Blacklist
            rp.IgnoreWater = true
            local orig = Camera.CFrame.Position
            local dir = pos - orig
            local ray = workspace:Raycast(orig, dir.Unit * dir.Magnitude, rp)
            if ray and not ray.Instance:IsDescendantOf(data.Model) then vis = false end
        end
        TargetInRange = true
        if not (vis or not _G.VisibleCheck or isBL) then return end
        local score
        if isBL then score = dfc - 1000000
        elseif not isPlayer then score = dfc
        elseif _G.TargetPriority == "Crosshair" then score = dfc
        elseif _G.TargetPriority == "Distance" then score = (pos - lRoot.Position).Magnitude
        elseif _G.TargetPriority == "LowestHP" then score = h.Health
        else score = dfc end
        if score < best then best = score; bPart = part; bModel = data.Model end
    end
    if not blActive and (_G.TargetMode == "NPCs" or _G.TargetMode == "Both") then
        for _, d in pairs(NPCCache) do PT(d, false) end
    end
    if blActive or _G.TargetMode == "Players" or _G.TargetMode == "Both" then
        for _, d in pairs(PlayerCache) do PT(d, true) end
    end
    for _, m in ipairs(deadList) do
        NPCCache[m] = nil
        PlayerCache[m] = nil
    end
    TargetPart = bPart
    return bModel
end

local function ShouldHit()
    if _G.HitChance >= 100 then return true end
    if _G.HitChance <= 0 then return false end
    return math.random(1, 100) <= _G.HitChance
end

local function CalcChance()
    if not CurrentTarget or not TargetPart then return 0 end
    if not TargetPart.Parent then return 0 end
    local b = _G.HitChance
    local df, ff = 1.0, 1.0
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
    h.Name = "SilentAimHighlight"
    h.Adornee = t
    h.FillColor = Color3.fromRGB(255, 50, 50)
    h.FillTransparency = 0.7
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.OutlineTransparency = 0
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
    -- ✅ 修复：加上 .Parent 检查，避免已销毁的目标访问
    if CurrentTarget and CurrentTarget.Parent and TargetPart and TargetPart.Parent then
        if not TargetHighlight or TargetHighlight.Adornee ~= CurrentTarget then TargetHighlight = CreateHighlight(CurrentTarget) end
        if TargetHighlight then
            local isP = false
            for _, d in pairs(PlayerCache) do
                if d.Model == CurrentTarget then isP = true; break end
            end
            TargetHighlight.FillColor = isP and _G.HighlightPlayerColor or _G.HighlightNPCColor
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
    CurrentTarget = nil; TargetPart = nil; TargetInRange = false; NPCCache = {}; PlayerCache = {}
end

local function UpdateTargetInfo()
    if not _G.ShowTarget or not TargetInfo or not _G.SilentAim then
        TargetInfo.Visible = false; TargetInfo.Text = ""; return
    end
    -- ✅ 修复：加上 .Parent 检查，避免已销毁的目标访问 .Position
    if CurrentTarget and CurrentTarget.Parent and TargetPart and TargetPart.Parent then
        local sp, on = Camera:WorldToViewportPoint(TargetPart.Position)
        if on then
            TargetInfo.Visible = true
            TargetInfo.Position = Vector2.new(sp.X, sp.Y + 20)
            local lines = {}
            if _G.ShowTargetName then
                local nm, ty = CurrentTarget.Name, "NPC"
                for _, d in pairs(PlayerCache) do
                    if d.Model == CurrentTarget then ty = "Player"; nm = d.Player.Name; break end
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
--// 4. ESP
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
    local r = model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Torso")
        or model:FindFirstChild("UpperTorso")
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
        local isP = (getPlrFromChar(model) ~= nil)
        if isP then
            local plr = getPlrFromChar(model)
            if plr and IsWhitelisted(plr) then setVis(p, false); continue end
        end
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
                p.Line.To = rp
                p.Line.Color = ESP_Config.LineColor
                p.Line.Visible = true
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
--// 5. HOOKS
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
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if _InAimHook then
            return oldNamecall(self, ...)
        end

        if _G.SilentAim and CurrentTarget and _G.DeadCheck then
            _InAimHook = true
            local isDeadNow = false
            pcall(function() isDeadNow = IsDead(CurrentTarget) end)
            if isDeadNow then
                NPCCache[CurrentTarget] = nil
                PlayerCache[CurrentTarget] = nil
                CurrentTarget = nil
                TargetPart = nil
                pcall(function() CurrentTarget = GetTarget() end)
            end
            _InAimHook = false
        end

        -- ✅ 修复：加上 .Parent 检查，避免已销毁的目标访问 .Position 崩溃
        if not _G.SilentAim or not TargetPart or not CurrentTarget
           or not TargetPart.Parent or not CurrentTarget.Parent then
            return oldNamecall(self, ...)
        end
        local method = getnamecallmethod()
        local args = {...}

        if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
            local sn = self.Name:lower()
            if string.find(sn, "fire") or string.find(sn, "hit") or string.find(sn, "attack")
               or string.find(sn, "damage") or string.find(sn, "shoot") or string.find(sn, "swing") then
                if not ShouldHit() then return oldNamecall(self, ...) end

                local newArgs = {}
                local modified = false
                local firstVec = nil
                local firstVecIndex = nil

                for i, a in pairs(args) do
                    if typeof(a) == "Vector3" then
                        firstVecIndex = i
                        firstVec = a
                        break
                    end
                end

                local newOrigin = nil
                if firstVec then
                    if _G.BulletTP then
                        newOrigin = applyBulletTeleport(firstVec, TargetPart)
                    else
                        newOrigin = TargetPart.Position
                    end
                end

                for i, a in pairs(args) do
                    if typeof(a) == "Vector3" then
                        if i == firstVecIndex then
                            newArgs[i] = newOrigin
                            modified = true
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
                        if _G.BulletTP then
                            nOrig = applyBulletTeleport(a.Origin, TargetPart)
                        else
                            nOrig = a.Origin
                        end
                        newArgs[i] = Ray.new(nOrig, (TargetPart.Position - nOrig).Unit * 1000)
                        modified = true
                    else
                        newArgs[i] = a
                    end
                end
                if modified then return oldNamecall(self, unpack(newArgs)) end
            end
        end

        if method == "Raycast" and self == workspace then
            local orig = args[1]
            local dir = args[2]
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
end

if not oldIndex then
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        return oldIndex(self, key)
    end)
end

task.spawn(function()
    while true do
        task.wait(_G.UpdateRate)
        if _G.SilentAim then
            pcall(function() CurrentTarget = GetTarget() end)
        else
            CurrentTarget = nil; TargetInRange = false; TargetPart = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    -- ✅ 修复：整个视觉更新用 pcall 包裹，任何异常都不会崩溃游戏
    pcall(function()
        Circle.Visible = _G.SilentAim
        if _G.SilentAim then
            local sc = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            Circle.Position = sc
            Circle.Radius = _G.FOV
            Circle.Color = _G.FOVColor
            if CurrentTarget and CurrentTarget.Parent then
                local isP = false
                for _, d in pairs(PlayerCache) do
                    if d.Model == CurrentTarget then isP = true; break end
                end
                if isP then Circle.Color = Color3.fromRGB(0, 150, 255) else Circle.Color = Color3.fromRGB(0, 255, 0) end
            else
                if TargetInRange then Circle.Color = Color3.fromRGB(255, 255, 0) else Circle.Color = Color3.fromRGB(255, 50, 0) end
            end
        else
            Circle.Visible = false
        end
        UpdateTargetInfo()
        UpdateHighlight()
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
RunService.RenderStepped:Connect(updateESP)
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then CleanupUIOnly() end
end)

--// ==================================================
--// 6. UI
--// ==================================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = '🎯 Universal Pro v5.8 (v5.7 + 修复选中崩溃)',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Aim = Window:AddTab('Silent Aim'),
    ESP = Window:AddTab('ESP Pro'),
    Bypass = Window:AddTab('Bypass & Extra'),
    Save = Window:AddTab('SAVE 📁')
}

local AimMainBox = Tabs.Aim:AddLeftGroupbox('Controle Principal')
AimMainBox:AddToggle('ToggleSilentAim', { Text = 'Ativar Silent Aim', Default = false, Callback = function(Value)
    _G.SilentAim = Value
    if Value then
        LastCacheUpdate = 0; UpdateCaches()
        Library:Notify('🎯 SILENT AIM ATIVADO', 1.5)
    else
        if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight = nil end
        Library:Notify('🎯 SILENT AIM DESATIVADO', 1.5)
    end
end})
AimMainBox:AddSlider('FOVSlider', { Text = 'FOV', Default = 150, Min = 50, Max = 300, Rounding = 0, Callback = function(Value) _G.FOV = Value; Circle.Radius = Value end })
AimMainBox:AddSlider('PredSlider', { Text = 'Predição', Default = 0.165, Min = 0, Max = 0.5, Rounding = 3, Callback = function(Value) _G.Prediction = Value end })
AimMainBox:AddSlider('ChanceSlider', { Text = 'Hit Chance', Default = 100, Min = 0, Max = 100, Rounding = 0, Callback = function(Value) _G.HitChance = Value end })
AimMainBox:AddSlider('UpdateSlider', { Text = 'Taxa de Atualização', Default = 0.01, Min = 0, Max = 0.5, Rounding = 2, Callback = function(Value) _G.UpdateRate = Value end })

local AimLogicBox = Tabs.Aim:AddLeftGroupbox('Lógica de Alvo')
AimLogicBox:AddDropdown('PriorityDrop', { Values = {'Crosshair', 'Distance', 'LowestHP'}, Default = 2, Multi = false, Text = 'Modo de Prioridade (玩家)', Callback = function(Value) _G.TargetPriority = Value; CurrentTarget = nil end })
AimLogicBox:AddToggle('StickyAim', { Text = 'Sticky Aim (Travar Alvo)', Default = true, Callback = function(Value) _G.StickyAim = Value end })
AimLogicBox:AddDropdown('TargetDrop', { Values = {'NPCs', 'Players', 'Both'}, Default = 1, Multi = false, Text = 'Modo de Alvo', Callback = function(Value) _G.TargetMode = Value end })
AimLogicBox:AddDropdown('PartDrop', { Values = {'Head', 'Torso', 'Both', 'Random'}, Default = 1, Multi = false, Text = 'Parte do Corpo', Callback = function(Value) _G.AimPart = Value end })
AimLogicBox:AddToggle('WallCheck', { Text = 'Wall Check (Visibilidade)', Default = true, Callback = function(Value) _G.VisibleCheck = Value end })
AimLogicBox:AddToggle('DeadCheckAim', { Text = 'Dead Body Check (Ignorar Mortos)', Default = true, Tooltip = 'Não mira em jogadores/NPCs mortos', Callback = function(Value) _G.DeadCheck = Value end })

local AimDistanceBox = Tabs.Aim:AddLeftGroupbox('Limite de Distância')
AimDistanceBox:AddToggle('EnableDistanceLimit', { Text = 'Ativar Limite de Distância', Default = true, Tooltip = 'Impede o Silent Aim de mirar em alvos muito distantes', Callback = function(Value) _G.EnableDistanceLimit = Value end })
AimDistanceBox:AddSlider('MaxAimDistance', { Text = 'Distância Máxima (studs)', Default = 500, Min = 50, Max = 2000, Rounding = 0, Tooltip = 'Alvos além desta distância serão ignorados', Callback = function(Value) _G.MaxAimDistance = Value end })
AimDistanceBox:AddLabel('📌 Recomendado: 300-800 studs para evitar detecção')

local AimFriendBox = Tabs.Aim:AddLeftGroupbox('Proteção de Amigos')
AimFriendBox:AddToggle('FriendCheckToggle', { Text = 'Ignorar Amigos (Friend Check)', Default = true, Tooltip = 'Não mira em jogadores que estão na sua lista de amigos do Roblox', Callback = function(Value) _G.FriendCheck = Value end })

local AimNPCBox = Tabs.Aim:AddLeftGroupbox('Configurações de NPC')
AimNPCBox:AddToggle('EnableNPCKeywordFilter', {
    Text = '🔛 启用 NPC 关键字过滤',
    Default = false,
    Tooltip = '关闭时: 所有 NPC 都可瞄 / 开启时: 只瞄名字含关键字的 NPC',
    Callback = function(Value)
        _G.NPCKeywordFilterEnabled = Value
        LastCacheUpdate = 0
        if Value then
            Library:Notify('🔛 NPC 关键字过滤已启用 (只瞄含关键字的 NPC)', 2)
        else
            Library:Notify('🔛 NPC 关键字过滤已关闭 (所有 NPC 都可瞄)', 2)
        end
    end
})
local NPCKeywordInput = AimNPCBox:AddInput('NPCKeywordInput', {
    Default = 'dog',
    Text = 'NPC 名称关键字 (启用过滤后生效)',
    Placeholder = '例如 dog  或  dog,cat,enemy',
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        _G.NPCKeywordFilter = tostring(Value or "")
        LastCacheUpdate = 0
    end
})
AimNPCBox:AddButton('🗑️ 清除关键字', function()
    _G.NPCKeywordFilter = ""
    pcall(function() NPCKeywordInput:SetValue("") end)
    LastCacheUpdate = 0
    Library:Notify('🗑️ 已清除关键字', 2)
end)
AimNPCBox:AddButton('🔄 重置为 dog', function()
    _G.NPCKeywordFilter = "dog"
    pcall(function() NPCKeywordInput:SetValue("dog") end)
    LastCacheUpdate = 0
    Library:Notify('🔄 已重置为 "dog"', 2)
end)
AimNPCBox:AddLabel('📌 默认关闭 → 所有 NPC 都可瞄')
AimNPCBox:AddLabel('📌 开启后只瞄名字含关键字的 NPC')
AimNPCBox:AddLabel('📌 支持逗号分隔: dog,cat,enemy')
AimNPCBox:AddLabel('📌 只影响 NPC, 不影响玩家')

AimNPCBox:AddToggle('AgressiveNPC', { Text = 'Modo NPC Agressivo (Otimizado)', Default = false, Callback = function(Value)
    _G.AggressiveNPCDetection = Value; LastCacheUpdate = 0; UpdateCaches()
    if Value then Library:Notify('⚠️ MODO AGRESSIVO ATIVADO', 2) end
end})
AimNPCBox:AddToggle('DebugNPCs', { Text = 'Debug NPCs', Default = false, Callback = function(Value) _G.DebugNPCs = Value end })
AimNPCBox:AddInput('CacheInterval', { Default = '2', Numeric = true, Finished = true, Text = 'Intervalo Cache (s)', Callback = function(Value) local num = tonumber(Value); if num and num > 0 then CacheUpdateInterval = num end end })
AimNPCBox:AddButton('Forçar Atualização de Cache', function() LastCacheUpdate = 0; UpdateCaches(); Library:Notify('Cache Atualizado!', 1) end)

local AimListBox = Tabs.Aim:AddRightGroupbox('Listas de Jogadores')
local function GetServerPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then table.insert(names, plr.Name) end
    end
    table.sort(names)
    return names
end
local function ParseDropdownValue(Value)
    local out = {}
    if type(Value) ~= "table" then return out end
    for k, v in pairs(Value) do
        if type(k) == "string" and v == true then table.insert(out, k)
        elseif type(k) == "number" and type(v) == "string" then table.insert(out, v)
        elseif type(k) == "string" and type(v) == "string" then table.insert(out, v) end
    end
    return out
end
local WhiteListDropdown = AimListBox:AddDropdown('WL_Dropdown', {
    Values = GetServerPlayerNames(), Default = {}, Multi = true,
    Text = '⚪ 白名单 (勾选 = 完全忽略)',
    Callback = function(Value) _G.Whitelist = ParseDropdownValue(Value) end
})
local BlackListDropdown = AimListBox:AddDropdown('BL_Dropdown', {
    Values = GetServerPlayerNames(), Default = {}, Multi = true,
    Text = '⚫ 黑名单 (勾选 = 只针对这些人)',
    Callback = function(Value) _G.Blacklist = ParseDropdownValue(Value) end
})
AimListBox:AddButton('🗑️ 取消所有白名单', function()
    _G.Whitelist = {}
    pcall(function() WhiteListDropdown:SetValues(GetServerPlayerNames()) end)
    Library:Notify('🗑️ 白名单已全部取消', 2)
end)
AimListBox:AddButton('🗑️ 取消所有黑名单', function()
    _G.Blacklist = {}
    pcall(function() BlackListDropdown:SetValues(GetServerPlayerNames()) end)
    Library:Notify('🗑️ 黑名单已全部取消', 2)
end)
AimListBox:AddButton('🗑️ 取消全部 (白+黑)', function()
    _G.Whitelist = {}
    _G.Blacklist = {}
    pcall(function() WhiteListDropdown:SetValues(GetServerPlayerNames()) end)
    pcall(function() BlackListDropdown:SetValues(GetServerPlayerNames()) end)
    Library:Notify('🗑️ 白名单和黑名单已全部取消', 2)
end)
AimListBox:AddButton('🔄 手动刷新玩家列表', function()
    local names = GetServerPlayerNames()
    pcall(function() WhiteListDropdown:SetValues(names) end)
    pcall(function() BlackListDropdown:SetValues(names) end)
    Library:Notify('🔄 玩家列表已刷新 (' .. #names .. ' 名玩家)', 2)
end)
AimListBox:AddLabel('📌 白名单: 完全忽略 (Silent Aim + ESP)')
AimListBox:AddLabel('📌 黑名单: 只针对这些人，取最靠近 FOV 准心的')

task.spawn(function()
    task.wait(1)
    local lastKey = ""
    while task.wait(2) do
        local names = GetServerPlayerNames()
        local key = table.concat(names, "|")
        if key ~= lastKey then
            lastKey = key
            local validNames = {}
            for _, n in ipairs(names) do validNames[n] = true end

            local wlChanged = false
            local newWL = {}
            for _, n in ipairs(_G.Whitelist) do
                if validNames[tostring(n)] then table.insert(newWL, n) else wlChanged = true end
            end
            if wlChanged then _G.Whitelist = newWL end

            local blChanged = false
            local newBL = {}
            for _, n in ipairs(_G.Blacklist) do
                if validNames[tostring(n)] then table.insert(newBL, n) else blChanged = true end
            end
            if blChanged then _G.Blacklist = newBL end

            if #_G.Whitelist == 0 then
                pcall(function() WhiteListDropdown:SetValues(names) end)
            end
            if #_G.Blacklist == 0 then
                pcall(function() BlackListDropdown:SetValues(names) end)
            end
        end
    end
end)

local AimBulletTPBox = Tabs.Aim:AddRightGroupbox('Bullet Teleport')
AimBulletTPBox:AddToggle('ToggleBulletTP', { Text = 'Ativar Bullet Teleport', Default = false, Tooltip = 'Teleporta a origem do tiro para perto do alvo.', Callback = function(Value)
    _G.BulletTP = Value
    if Value then Library:Notify('🔫 BULLET TP ATIVADO', 2) else Library:Notify('🔫 BULLET TP DESATIVADO', 2) end
end})
AimBulletTPBox:AddLabel('📌 Ignora obstáculos entre você e o alvo.')

local AimInfoBox = Tabs.Aim:AddRightGroupbox('Visuais e Informações')
AimInfoBox:AddLabel('Cor do Círculo FOV'):AddColorPicker('FOVColor', { Default = Color3.fromRGB(0, 255, 0), Title = 'Cor FOV', Callback = function(Value) _G.FOVColor = Value; Circle.Color = Value end })
AimInfoBox:AddToggle('HighlightTgt', { Text = 'Highlight no Alvo', Default = false, Callback = function(Value) _G.HighlightTarget = Value end })
AimInfoBox:AddLabel('Cor Highlight NPC'):AddColorPicker('HNPCColor', { Default = Color3.fromRGB(255, 50, 50), Title = 'Highlight NPC', Callback = function(Value) _G.HighlightNPCColor = Value; UpdateHighlight() end })
AimInfoBox:AddLabel('Cor Highlight Player'):AddColorPicker('HPlrColor', { Default = Color3.fromRGB(50, 150, 255), Title = 'Highlight Player', Callback = function(Value) _G.HighlightPlayerColor = Value; UpdateHighlight() end })
AimInfoBox:AddToggle('ShowTargetInfo', { Text = 'Mostrar Info do Alvo', Default = true, Callback = function(Value) _G.ShowTarget = Value end })
AimInfoBox:AddToggle('InfoName', { Text = 'Mostrar Nome/Tipo', Default = true, Callback = function(Value) _G.ShowTargetName = Value; UpdateTargetInfo() end })
AimInfoBox:AddToggle('InfoHP', { Text = 'Mostrar HP', Default = true, Callback = function(Value) _G.ShowTargetHP = Value; UpdateTargetInfo() end })
AimInfoBox:AddToggle('InfoDist', { Text = 'Mostrar Distância', Default = true, Callback = function(Value) _G.ShowTargetDistance = Value; UpdateTargetInfo() end })
AimInfoBox:AddToggle('InfoChance', { Text = 'Mostrar Chance', Default = true, Callback = function(Value) _G.ShowHitChance = Value; UpdateTargetInfo() end })
AimInfoBox:AddButton('Limpar UI de Mira', function() CleanupUIOnly() end)

local AimTeamBox = Tabs.Aim:AddRightGroupbox('Time')
AimTeamBox:AddToggle('TeamCheckPlr', { Text = 'Team Check (Players)', Default = true, Callback = function(Value) _G.TeamCheck = Value end })
AimTeamBox:AddToggle('TeamCheckNPC', { Text = 'Team Check (NPCs)', Default = false, Callback = function(Value) _G.TeamCheckForNPCs = Value end })

local ESPMainBox = Tabs.ESP:AddLeftGroupbox('Controle Principal')
ESPMainBox:AddToggle('ToggleESP', { Text = 'Ativar ESP', Default = false, Callback = function(Value) ESP_Config.Enabled = Value end })
ESPMainBox:AddToggle('ESPPlayers', { Text = 'Mostrar Players', Default = true, Callback = function(Value) ESP_Config.ShowPlayers = Value end })
ESPMainBox:AddToggle('ESPNPCs', { Text = 'Mostrar NPCs', Default = true, Callback = function(Value) ESP_Config.ShowNPCs = Value end })
ESPMainBox:AddToggle('ESPTeamCheck', { Text = 'Team Check', Default = true, Callback = function(Value) ESP_Config.TeamCheck = Value end })
ESPMainBox:AddToggle('ESPTeamColor', { Text = 'Usar Cor do Time', Default = true, Callback = function(Value) ESP_Config.UseTeamColor = Value end })
ESPMainBox:AddToggle('ESPDeadCheck', { Text = 'Ocultar Corpos Mortos (Dead Check)', Default = true, Callback = function(Value) ESP_Config.DeadCheck = Value end })

local ESPElemsBox = Tabs.ESP:AddLeftGroupbox('Elementos Visuais')
ESPElemsBox:AddToggle('EBox', { Text = 'Mostrar Box', Default = true, Callback = function(Value) ESP_Config.ShowBox = Value end })
ESPElemsBox:AddToggle('ELine', { Text = 'Mostrar Linha', Default = true, Callback = function(Value) ESP_Config.ShowLine = Value end })
ESPElemsBox:AddToggle('EStick', { Text = 'Mostrar Stick', Default = true, Callback = function(Value) ESP_Config.ShowStick = Value end })
ESPElemsBox:AddToggle('EName', { Text = 'Mostrar Nome', Default = true, Callback = function(Value) ESP_Config.ShowName = Value end })
ESPElemsBox:AddToggle('EDist', { Text = 'Mostrar Distância', Default = true, Callback = function(Value) ESP_Config.ShowDistance = Value end })
ESPElemsBox:AddToggle('EHP', { Text = 'Mostrar HP Bar', Default = true, Callback = function(Value) ESP_Config.ShowHPBar = Value end })
ESPElemsBox:AddToggle('EEquip', { Text = 'Mostrar Item Equipado', Default = true, Callback = function(Value) ESP_Config.ShowEquippedItem = Value end })
ESPElemsBox:AddToggle('EInv', { Text = 'Mostrar Inventário Completo', Default = false, Callback = function(Value) ESP_Config.ShowInventory = Value end })

local ESPSizesBox = Tabs.ESP:AddRightGroupbox('Tamanhos e Distância')
ESPSizesBox:AddSlider('ESPMaxDist', { Text = 'Distância Máxima', Default = 2500, Min = 500, Max = 5000, Rounding = 0, Compact = false, Callback = function(Value) ESP_Config.MaxDistance = Value end })
ESPSizesBox:AddSlider('ESPNameS', { Text = 'Tamanho do Nome', Default = 16, Min = 8, Max = 30, Rounding = 0, Compact = true, Callback = function(Value) ESP_Config.NameTextSize = Value end })
ESPSizesBox:AddSlider('ESPDistS', { Text = 'Tamanho da Distância', Default = 14, Min = 8, Max = 30, Rounding = 0, Compact = true, Callback = function(Value) ESP_Config.DistanceTextSize = Value end })
ESPSizesBox:AddSlider('ESPInvS', { Text = 'Tamanho do Inventário', Default = 13, Min = 8, Max = 30, Rounding = 0, Compact = true, Callback = function(Value) ESP_Config.InventoryTextSize = Value end })

local ESPColorsBox = Tabs.ESP:AddRightGroupbox('Cores do ESP')
ESPColorsBox:AddLabel('Cor do Inimigo'):AddColorPicker('CEnemy', { Default = Color3.fromRGB(255, 80, 80), Title = 'Inimigo', Callback = function(Value) ESP_Config.EnemyColor = Value end })
ESPColorsBox:AddLabel('Cor do Aliado'):AddColorPicker('CAlly', { Default = Color3.fromRGB(80, 255, 80), Title = 'Aliado', Callback = function(Value) ESP_Config.AllyColor = Value end })
ESPColorsBox:AddLabel('Cor da Linha'):AddColorPicker('CLine', { Default = Color3.fromRGB(255, 255, 0), Title = 'Linha', Callback = function(Value) ESP_Config.LineColor = Value end })
ESPColorsBox:AddLabel('Cor do Stick'):AddColorPicker('CStick', { Default = Color3.fromRGB(255, 255, 255), Title = 'Stick', Callback = function(Value) ESP_Config.StickColor = Value end })

local BypassBox = Tabs.Bypass:AddLeftGroupbox('Bypass Anti-Cheat')
BypassBox:AddToggle('AdonisBypassToggle', { Text = 'Bypass Adonis Anti-Cheat', Default = true, Tooltip = 'Tenta bypassar o sistema Anti-Cheat do Adonis', Callback = function(Value)
    _G.AdonisBypass = Value
    if Value then Library:Notify('🛡️ Bypass Adonis ATIVADO', 2) else Library:Notify('🛡️ Bypass Adonis DESATIVADO', 2) end
end})
BypassBox:AddLabel('⚠️ Funciona com a maioria dos servidores que usam Adonis')
BypassBox:AddLabel('📌 Use com moderação para evitar banimentos')

local ExtraBox = Tabs.Bypass:AddLeftGroupbox('Extras')
ExtraBox:AddButton('🔄 Forçar Reaplicação do Bypass', function()
    task.spawn(function()
        BypassAdonis()
        Library:Notify('🔄 Bypass reaplicado!', 2)
    end)
end)
ExtraBox:AddLabel('🛡️ Anti-Kick Ativo: ' .. tostring(AntiKickEnabled))
if antiKickLoaded then
    ExtraBox:AddLabel('✅ Anti-Kick Otimizado carregado!')
else
    ExtraBox:AddLabel('⚠️ Usando Anti-Kick Fallback')
end

local SaveTab = Tabs.Save
Library:SetWatermark('Universal Pro v5.8')
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('UniversalPro')
SaveManager:SetFolder('UniversalPro/pro')
SaveManager:BuildConfigSection(SaveTab)
ThemeManager:BuildThemeManager(SaveTab)

SaveTab:AddLabel('📁 Gerenciamento de Configurações')
SaveTab:AddButton('💾 Salvar Configurações', function() SaveManager:Save(); Library:Notify('✅ Configurações salvas!', 2) end)
SaveTab:AddButton('📂 Carregar Configurações', function() SaveManager:Load(); Library:Notify('✅ Configurações carregadas!', 2) end)
SaveTab:AddButton('🔄 Resetar Configurações', function() SaveManager:Reset(); Library:Notify('🔄 Configurações resetadas!', 2) end)
SaveTab:AddLabel('')
SaveTab:AddLabel('🎨 Temas')
SaveTab:AddButton('🔄 Recarregar Temas', function() ThemeManager:Load(); Library:Notify('🎨 Temas recarregados!', 2) end)

Library:Notify('✅ UNIVERSAL PRO v5.8 CARREGADO! (v5.7 + 修复选中崩溃)', 5)
print("[Universal Pro] v5.8 carregado (修复选中崩溃)")
