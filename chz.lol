local g = getinfo or debug.getinfo
local d = false
local h = {}

local x, y

setthreadidentity(2)

for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a = rawget(v, "Detected")
        local b = rawget(v, "Kill")
    
        if typeof(a) == "function" and not x then
            x = a
            
            local o; o = hookfunction(x, function(c, f, n)
                if c ~= "_" then
                    if d then
                        warn(`Adonis AntiCheat flagged\nMethod: {c}\nInfo: {f}`)
                    end
                end
                
                return true
            end)

            table.insert(h, x)
        end

        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not y then
            y = b
            local o; o = hookfunction(y, function(f)
                if d then
                    warn(`Adonis AntiCheat tried to kill (fallback): {f}`)
                end
            end)

            table.insert(h, y)
        end
    end
end

local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local a, f = ...

    if x and a == x then
        if d then
            warn(`zins | adonis bypassed`)
        end

        return coroutine.yield(coroutine.running())
    end
    
    return o(...)
end))

setthreadidentity(7)

for _, v in ipairs(getgc(true)) do
    if typeof(v) == "table" then
        if rawget(v, "DTXC1") then
            hookfunction(v.DTXC1, function() return end)
        end
        
        if rawget(v, "CX1") then
            hookfunction(v.CX1, function() return end)
        end
    end
end

--[[
    Made by samet

    Assign different flags to each element to prevent from configs overriding eachother
    Example script is at the bottom

    Documentation:
    function Library:Window(Data: table
        Name/name: string,
        Size/size: UDim2
    )

    function Window:Page(Data: table
        Name/name: string,
        Columns/columns: number,
        SubTabs/subtabs: boolean
    )

    function Page:SubPage(Data: table
        Icon/icon: string,
        Columns/columns: number
    )

    function Page:Section(Data: table
        Name/name: string,
        Side/side: number,
    )

    function Page:MultiSection(Data: table
        Sections/sections: table,
        Side/side: number
    )

    function Page:ScrollableSection(Data: table
        Name/name: string,
        Side/side: number,
        Size/size: number
    )

    function Section:Divider()

    function Section:Label(Data: table
        Name/name: string,
        Alignment/alignment: string
    )

    function Section:Toggle(Data: table
        Name/name: string,
        Default/default: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Button(Data: table
        Name/name: string,
        Callback/callback: function
    )

    function Section:Slider(Data: table
        Name/name: string,
        Min/min: number,
        Max/max: number,
        Decimals/decimals: number,
        Default/default: number,
        Suffix/suffix: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Textbox(Data: table
        Name/name: string,
        Default/default: string,
        Placeholder/placeholder: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Dropdown(Data: table
        Name/name: string,
        Items/items: table,
        Default/default: string,
        Flag/flag: string,
        Multi/multi: boolean,
        Callback/callback: function
    )

    function Section:Listbox(Data: table
        Size/size: number,
        Items/items: table,
        Default/default: string,
        Multi/multi: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Label:Keybind(Data: table
        Name/name: string,
        Mode/mode: string,
        Default/default: EnumItem,
        Flag/flag: string,
        Callback/callback: function
    )

    function Label:Colorpicker(Data: table
        Name/name: string,
        Default/default: Color3,
        Alpha/alpha: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Toggle:Colorpicker(Data: table
        Name/name: string,
        Default/default: Color3,
        Alpha/alpha: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Toggle:Keybind(Data: table
        Name/name: string,
        Mode/mode: string,
        Default/default: EnumItem,
        Flag/flag: string,
        Callback/callback: function
    )

    function Sections:Textbox(Data: table
        Name/name: string,
        Default/default: string,
        Placeholder/placeholder: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Library:Watermark(Name: string)
    function Library:Notification(Text: string, Duration: number, Color: Color3, Icon: table)
    function Library:KeybindList()
]]

local LoadingTick = os.clock()

if getgenv().Library then 
    getgenv().Library:Unload()
end

local Library do
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDim2FromOffset = UDim2.fromOffset
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local InstanceNew = Instance.new

    local MathClamp = math.clamp
    local MathFloor = math.floor

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub

    local IsMobile = UserInputService.TouchEnabled or false

    Library = {
        Flags = { },
        
        Theme = {
            ["Background"] = FromHex("#14100f"),
            ["Inline"] = FromHex("#191614"),
            ["Page Background"] = FromHex("#28201e"),
            ["Border"] = FromHex("#120f0e"),
            ["Outline"] = FromHex("#211c1b"),
            ["Accent"] = FromHex("#ffb29d"),
            ["Element"] = FromHex("#242221"),
            ["Hovered Element"] = FromHex("#322f2f"),
            ["Text"] = FromHex("#979797"),
            ["Text Border"] = FromRGB(0, 0, 0)
        },

        MenuKeybind = Enum.KeyCode.Z, 

        Tween = {
            Time = 0.3,
            Style = Enum.EasingStyle.Exponential,
            Direction = Enum.EasingDirection.Out
        },

        Folders = {
            Directory = "scriptname",
            Configs = "scriptname/Configs",
            Assets = "scriptname/Assets"
        },

        Images = { -- you're welcome to reupload the images and replace it with your own links
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/hue.png?raw=true" },
            ["Scrollbar"] =  { "Scrollbar.png", "https://github.com/sametexe001/images/blob/main/scrollbar.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
            ["Resize"] = { "Resize.png", "https://github.com/sametexe001/images/blob/main/resize.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },
        Connections = { },
        Threads = { },
        ThemeMap = { },
        ThemeItems = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        Font = nil,
        KeyList = nil,

        CurrentColorpicker = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Files 
    for _, FileName in Library.Folders do
        if not isfolder(FileName) then
            makefolder(FileName)
        end
    end

    if not isfile(Library.Folders.Directory .. "/autoload.json") then
        writefile(Library.Folders.Directory .. "/autoload.json", "")
    end

    for _, ImageData in Library.Images do
        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        
        if not isfile(Library.Folders.Assets .. "/" .. ImageName) then
            writefile(Library.Folders.Assets .. "/" .. ImageName, game:HttpGet(ImageLink))
        end
    end

    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance

            if Visibility == true then 
                Item.Visible = true
            end

            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            if IsMobile then 
                if Event == "MouseButton1Down" or Event == "MouseButton1Click" then
                    Event = "TouchTap"
                elseif Event == "MouseButton2Down" or Event == "MouseButton2Click" then
                    Event = "TouchLongPress"
                end
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end
        
            local Gui = self.Instance
            local Dragging = false 
            local DragStart
            local StartPosition 
        
            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                local NewX = StartPosition.X.Offset + DragDelta.X
                local NewY = StartPosition.Y.Offset + DragDelta.Y

                local ScreenSize = Gui.Parent.AbsoluteSize
                local GuiSize = Gui.AbsoluteSize
        
                NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
                NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
        
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
            end
        
            local InputChanged
        
            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
        
                    if InputChanged then 
                        return
                    end
        
                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)
        
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)
        
            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local CurrentSide = nil

            local StartMouse = nil 
            local StartPosition = nil 
            local StartSize = nil
            
            local EdgeThickness = 2

            local MakeEdge = function(Name, Position, Size)
                local Button = Instances:Create("TextButton", {
                    Name = "\0",
                    Size = Size,
                    Position = Position,
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Gui,
                    ZIndex = 99999,
                })  Button:AddToTheme({BackgroundColor3 = "Accent"})

                return Button
            end

            local Edges = {
                {Button = MakeEdge(
                    "Left", 
                    UDim2New(0, 0, 0, 0), 
                    UDim2New(0, EdgeThickness, 1, 0)), 
                    Side = "L"
                },

                {Button = MakeEdge(
                    "Right", 
                    UDim2New(1, -EdgeThickness, 0, 0), 
                    UDim2New(0, EdgeThickness, 1, 0)), 
                    Side = "R"
                },

                {Button = MakeEdge(
                    "Top", UDim2New(0, 0, 0, 0), 
                    UDim2New(1, 0, 0, EdgeThickness)), 
                    Side = "T"
                },

                {Button = MakeEdge(
                    "Bottom", 
                    UDim2New(0, 0, 1, -EdgeThickness), 
                    UDim2New(1, 0, 0, EdgeThickness)), 
                    Side = "B"
                },
            }

            local BeginResizing = function(Side)
                Resizing = true 
                CurrentSide = Side 

                StartMouse = UserInputService:GetMouseLocation()

                -- store offsets, not absolute screen pos
                StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
                
                for Index, Value in Edges do 
                    Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
                end
            end

            local EndResizing = function()
                Resizing = false 
                CurrentSide = nil

                for Index, Value in Edges do 
                    Value.Button.Instance.BackgroundTransparency = 1
                end
            end

            for Index, Value in Edges do 
                Value.Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        BeginResizing(Value.Side)
                    end
                end)
            end

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        EndResizing()
                    end
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then 
                    return 
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y
            
                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y

                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end
            
                if w < Minimum.X then
                    if CurrentSide == "L" then
                        x = x - (Minimum.X - w)
                    end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then
                        y = y - (Minimum.Y - h)
                    end
                    h = Minimum.Y
                end
            
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
            end)
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("Windows-XP-Tahoma", 200, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/windows-xp-tahoma.ttf"
        })

        Library.Font = CustomFont:Get("Windows-XP-Tahoma")
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2New(0.5, 0),
        BackgroundTransparency = 1,
        Position = UDim2New(0.5, 0, 0, 0),
        Name = "\0",
        Size = UDim2New(0.34, 0, 1, -14),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    }) 
    
    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDimNew(0, 10)
    }) 

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.GetTransparencyPropertyFromItem = function(self, Item)
        if Item:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.FadeItem = function(self, Item, Property, Visibility, Speed)
        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)

        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            Library:Notification("Error caught in function, report this to the devs:\n"..Result, 5, FromRGB(255, 0, 0))
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("Connection_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("Flag Number %s %s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        if Success then 
            Library:Notification("Successfully loaded config", 5, Color3.fromRGB(0, 255, 0))
        end
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
            Library:Notification("Deleted config " .. Config .. ".json", 5, Color3.fromRGB(0, 255, 0))
        end
    end

    Library.SaveConfig = function(self, Config)
        if isfile(Library.Folders.Directory .. "/" .. Library.Folders.Configs .. "/" .. Config .. ".json") then
            writefile(Library.Folders.Directory .. "/" .. Library.Folders.Configs .. "/" .. Config .. ".json", Library:GetConfig())
            Library:Notification("Saved config " .. Config .. ".json", 5, Color3.fromRGB(0, 255, 0))
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Watermark = function(self, Name)
        local Watermark = { } 

        local Items = { } do 
            Items["Watermark"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Size = UDim2New(0, 0, 0, 20),
                Name = "\0",
                Position = UDim2New(0, 15, 0, 15),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["Watermark"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["Watermark"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Watermark"].Instance,
                PaddingTop = UDimNew(0, 2),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Watermark"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 1),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -2),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })             
        end

        function Watermark:SetVisibility(Bool)
            Items["Watermark"].Instance.Visible = Bool
        end
        
        return Watermark
    end

    Library.Notification = function(self, Text, Duration, Color, Icon)
        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = Library.NotifHolder.Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 22),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"}) 
            
            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                PaddingTop = UDimNew(0, 1),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Text,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 13, 0, 2),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 13, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = Color
            })  
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Notification"].Instance,
                ImageColor3 = FromRGB(255, 255, 255),
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Image = "rbxassetid://94324346713012",
                BackgroundTransparency = 1,
                Position = UDim2New(0, -2, 0, 3),
                Size = UDim2New(0, 13, 0, 13),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            if not Icon then 
                Items["Icon"]:Clean()
                Items["Title"].Instance.Position = UDim2New(0, 1, 0, 2)
            else
                Items["Icon"].Instance.Image = Icon[1]
                Items["Icon"].Instance.ImageColor3 = Icon[2] or FromRGB(255, 255, 255)
            end
        end

        Items["Notification"].Instance.BackgroundTransparency = 1
        Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)
        for Index, Value in Items["Notification"].Instance:GetDescendants() do
            if Value:IsA("UIStroke") then 
                Value.Transparency = 1
            elseif Value:IsA("TextLabel") then 
                Value.TextTransparency = 1
            elseif Value:IsA("ImageLabel") then 
                Value.ImageTransparency = 1
            elseif Value:IsA("Frame") then 
                Value.BackgroundTransparency = 1
            end
        end

        Library:Thread(function()
            Items["Notification"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 0, 0, 22)})
            
            task.wait(0.06)

            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("UIStroke") then
                    Tween:Create(Value, nil, {Transparency = 0}, true)
                elseif Value:IsA("TextLabel") then
                    Tween:Create(Value, nil, {TextTransparency = 0}, true)
                elseif Value:IsA("ImageLabel") then
                    Tween:Create(Value, nil, {ImageTransparency = 0}, true)
                elseif Value:IsA("Frame") then
                    Tween:Create(Value, nil, {BackgroundTransparency = 0}, true)
                end
            end

            task.delay(Duration + 0.1, function()
                for Index, Value in Items["Notification"].Instance:GetDescendants() do
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 1}, true)
                    elseif Value:IsA("TextLabel") then
                        Tween:Create(Value, nil, {TextTransparency = 1}, true)
                    elseif Value:IsA("ImageLabel") then
                        Tween:Create(Value, nil, {ImageTransparency = 1}, true)
                    elseif Value:IsA("Frame") then
                        Tween:Create(Value, nil, {BackgroundTransparency = 1}, true)
                    end
                end

                task.wait(0.06)

                Items["Notification"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})

                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

    Library.KeybindList = function(self)
        local KeybindList = { }
        self.KeyList = KeybindList

        local Items = { } do
            Items["KeybindList"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AnchorPoint = Vector2New(0, 0.5),
                Name = "\0",
                Position = UDim2New(0, 15, 0.5, 0),
                Size = UDim2New(0, 0, 0, 18),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["KeybindList"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["KeybindList"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["KeybindList"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -5),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["KeybindList"].Instance,
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["KeybindList"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Keybinds",
                Name = "\0",
                Size = UDim2New(0, 100, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 5, 0, 19),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
        end

        function KeybindList:Add(Mode, Name, Key)
            local NewKey = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "(" .. Mode .. ") " .. Name .. " - " .. Key,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  NewKey:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = NewKey.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        
            function NewKey:Set(Mode, Name, Key)
                NewKey.Instance.Text = "(" .. Mode .. ") " .. Name .. " - " .. Key
            end

            function NewKey:SetStatus(Status)
                if Status == "Active" then 
                    NewKey:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    NewKey:ChangeItemTheme({TextColor3 = "Accent"})
                else 
                    NewKey:Tween(nil, {TextColor3 = Library.Theme.Text})
                    NewKey:ChangeItemTheme({TextColor3 = "Text"})
                end
            end

            return NewKey
        end

        function KeybindList:SetVisibility(Bool)
            Items["KeybindList"].Instance.Visible = Bool
        end

        return KeybindList
    end

    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            HexValue = "",
            
            IsOpen = false,

            Color = FromRGB(0, 0, 0),

            Class = "Colorpicker"
        }

        Library.Flags[Data.Flag] = { }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 20, 0, 10),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 


            Colorpicker.CalculateCount = function(self, Index, YScale, YOffset)
                local MaxButtonsAdded = 5

                local Column = Index % MaxButtonsAdded
            
                local ButtonSize = Items["ColorpickerButton"].Instance.AbsoluteSize
                local Spacing = 4
            
                local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - 21
            
                Items["ColorpickerButton"].Instance.Position = UDim2New(1, -XPosition, YScale or 0.5, YOffset or 0)
            end

            Colorpicker:CalculateCount(Data.Count)
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["ColorpickerButton"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            })             

            Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                Parent = Library.Holder.Instance,
                AutoButtonColor = false,
                Text = "",
                Name = "\0",
                Position = UDim2New(0, Data.Parent.Instance.AbsolutePosition.X, 0, Data.Parent.Instance.AbsolutePosition.Y + 15),
                BorderColor3 = FromRGB(10, 10, 10),
                Visible = false,
                Size = UDim2New(0, 238, 0, 224),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})
            
            Items["ColorpickerWindow"]:MakeDraggable()
            Items["ColorpickerWindow"]:MakeResizeable(Vector2New(200, 180), Vector2New(9999, 9999))

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Data.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, -2, 0, -3),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Position = UDim2New(0, -6, 0, -6),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 12, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["ColorpickerWindow"].Instance,
                PaddingTop = UDimNew(0, 6),
                PaddingBottom = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6)
            }) 
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 15),
                Size = UDim2New(1, -26, 1, -40),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 
            
            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Value"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 2, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Hue"] = Instances:Create("ImageButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Image = Library:GetImage("Hue"),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 15),
                Size = UDim2New(0, 18, 1, -15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, -26, 0, 18),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Checkers"),
                TileSize = UDim2New(0, 6, 0, 6),
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            }) 
            
            Instances:Create("UIGradient", {
                Parent = Items["Alpha"].Instance,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(0, 0, 0))}
            }) 
            
            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
        end

        local SlidingPalette = false
        local SlidingHue = false
        local SlidingAlpha = false

        local Debounce = false

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Data.Parent.Instance.AbsolutePosition.X, 0, Data.Parent.Instance.AbsolutePosition.Y + 15)

                if Library.CurrentColorpicker then
                    Library.CurrentColorpicker:SetOpen(false)
                    Library.CurrentColorpicker = nil 
                end

                if not Library.CurrentColorpicker then 
                    Library.CurrentColorpicker = Colorpicker
                end
            else
                Library.CurrentColorpicker = nil
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if not StringFind(Value.ClassName, "UI") then 
                    Value.ZIndex = Bool and 10001 or 1
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Data.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Data.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = Bool
            end)
        end

        function Colorpicker:Get()
            return Colorpicker.Value
        end

        function Colorpicker:SetVisibility(Bool)
           Data.Parent.Instance.Visible = Bool 
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then 
                Color = FromRGB(Color[1], Color[2], Color[3])
                Alpha = Color[4]
            elseif type(Color) == "string" then 
                Color = FromHex(Color)
            end

            self.Hue, self.Saturation, self.Value = Color:ToHSV()
            self.Alpha = Alpha or 0

            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            local ColorPositionX = MathClamp(1 - self.Saturation, 0, 0.989)
            local ColorPositionY = MathClamp(1 - self.Value, 0, 0.989)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(ColorPositionX, 0, ColorPositionY, 0)})

            local HuePositionY = MathClamp(self.Hue, 0, 0.994)

            Items["HueDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})

            local AlphaPositionX = MathClamp(self.Alpha, 0, 0.994)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})

            self:Update()
        end

        function Colorpicker:Update(IsFromAlpha)
            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            Items["ColorpickerButton"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
            Items["Palette"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = FromHSV(self.Hue, 1, 1)})

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Color, self.Alpha)
            end
        end

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then 
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            self.Saturation = ValueX
            self.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.989)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.989)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            self:Update()            
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then 
                return
            end

            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            self.Hue = ValueY

            local PositionY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.994)

            Items["HueDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, PositionY, 0)})
            self:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then 
                return
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
            
            self.Alpha = ValueX

            local PositionX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.994)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PositionX, 0, 0, 0)})
            self:Update(true)
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        local PaletteChanged

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)

                if PaletteChanged then
                    return
                end

                PaletteChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false

                        PaletteChanged:Disconnect()
                        PaletteChanged = nil
                    end
                end) 
            end
        end)

        local HueChanged

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingHue = true
                Colorpicker:SlideHue(Input)

                if HueChanged then
                    return
                end

                HueChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false

                        HueChanged:Disconnect()
                        HueChanged = nil
                    end
                end)
            end
        end)

        local AlphaChanged

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingAlpha = true
                Colorpicker:SlideAlpha(Input)
                
                if AlphaChanged then
                    return
                end

                AlphaChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingAlpha = false

                        AlphaChanged:Disconnect()
                        AlphaChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end

                if SlidingAlpha then
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not Colorpicker.IsOpen  then
                    return
                end

                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return
                end

                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Data.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        return Colorpicker
    end

    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Key = nil,
            Value = "",
            Mode = "",

            Toggled = false,
            IsOpen = false,

            Picking = false,

            Class = "Keybind"
        }

        Library.Flags[Data.Flag] = { }

        local KeyListItem

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(27, 27, 32),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Size = UDim2New(0, 0, 1, 1),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["KeyButton"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})

            if Library.KeyList then 
                KeyListItem = Library.KeyList:Add(Keybind.Mode, Data.Name, Keybind.Value)
            end
            
            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(10, 10, 10)
            }):AddToTheme({Color = "Border"})
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["KeyButton"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "MB2",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                PaddingRight = UDimNew(0, 3),
                PaddingLeft = UDimNew(0, 3),
                PaddingBottom = UDimNew(0, 2)
            })             

            Items["Window"] = Instances:Create("Frame", {
                Parent = Data.Parent.Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 0, 1, 5),
                Size = UDim2New(0, 50, 0, 48),
                BorderSizePixel = 2,
                Visible = false,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Window"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Window"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 157, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Toggle"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Toggle"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Hold",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 15),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Hold"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Hold"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Always",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 30),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Always"]:AddToTheme({TextColor3 = "Text"})
             
            Instances:Create("UIStroke", {
                Parent = Items["Always"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        end

        local Modes = {
            ["Toggle"] = Items["Toggle"],
            ["Hold"] = Items["Hold"],
            ["Always"] = Items["Always"]
        }

        local Update = function()
            if KeyListItem then
                KeyListItem:Set(Keybind.Mode, Data.Name, Keybind.Value)
                KeyListItem:SetStatus(Keybind.Toggled and "Active" or "Inactive")
            end
        end

        function Keybind:Get()
           return Keybind.Toggled, Keybind.Key, Keybind.Mode 
        end

        function Keybind:SetVisibility(Bool)
            Data.Parent.Instance.Visible = Bool
        end

        local Debounce = false

        function Keybind:SetOpen(Bool)
            Keybind.IsOpen = Bool

            if Bool then 
                Debounce = true
                Items["Window"].Instance.Visible = true
                Items["Window"].Instance.ZIndex = 16
                Items["Window"]:Tween(nil, {BackgroundTransparency = 0})

                task.wait(0.1)

                for Index, Value in Items["Window"].Instance:GetDescendants() do 
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 0}, true)
                    elseif Value:IsA("TextButton") then
                        Tween:Create(Value, nil, {TextTransparency = 0}, true)
                        Value.ZIndex = 16
                    end
                end
            else 
                for Index, Value in Items["Window"].Instance:GetDescendants() do 
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 1}, true)
                    elseif Value:IsA("TextButton") then
                        Tween:Create(Value, nil, {TextTransparency = 1}, true)
                        Value.ZIndex = 1
                    end
                end

                task.wait(0.1)

                Items["Window"]:Tween(nil, {BackgroundTransparency = 1})
                Items["Window"].Instance.ZIndex = 1
                task.wait(0.1)
                Items["Window"].Instance.Visible = false
            end

            Debounce = false
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["Text"].Instance.Text = TextToDisplay
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
           elseif TableFind({"Toggle", "Hold", "Always"}, Key) then 
                Keybind.Mode = Key
                
                Keybind:SetMode(Key)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif type(Key) == "table" then 
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["Text"].Instance.Text = TextToDisplay

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                end
            end

            Keybind.Picking = false
            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Text"].Instance.Size = UDim2New(0, Items["Text"].Instance.TextBounds.X, 1, 1)
            Update()
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do 
                if Index == Mode then 
                    Value:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    Value:ChangeItemTheme({TextColor3 = "Accent"})
                else
                    Value:Tween(nil, {TextColor3 = Library.Theme.Text})
                    Value:ChangeItemTheme({TextColor3 = "Text"})
                end
            end

            if Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            else
                Keybind.Toggled = false
            end

            Library.Flags[Data.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then
                Keybind.Toggled = true
            end

            Library.Flags[Data.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            if Keybind.Picking then 
                return
            end

            Keybind.Picking = true

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})

            local InputBegan 
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then 
                    return 
                end

                if Library:IsMouseOverFrame(Items["Window"]) then
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                end
            end
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        if Data.Default then 
            Keybind:Set({
                Key = Data.Default,
                Mode = Data.Mode or "Toggle"
            })
        end

        Library.SetFlags[Data.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = {
            Name = Data.Name or Data.name or "Window",
            Size = Data.Size or Data.size or UDim2New(0, 500, 0, 600),

            FadeSpeed = Data.FadeSpeed or Data.fadespeed or 0.25,

            Pages = { },
            SubPages = { },
            Elements = { },

            IsOpen = true
        }

        local Items = { } do 
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                AnchorPoint = Vector2New(0, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = Window.Size,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            -- 居中 + 不超屏
do
    local V = Camera.ViewportSize
    local W = Window.Size.X.Offset
    local H = Window.Size.Y.Offset
    if W > V.X then W = V.X - 20 end
    if H > V.Y then H = V.Y - 40 end
    Items["MainFrame"].Instance.Size = UDim2FromOffset(W, H)
    Window.Size = UDim2FromOffset(W, H)
    Items["MainFrame"].Instance.Position = UDim2FromOffset(
        math.floor((V.X - W) / 2),
        math.floor((V.Y - H) / 2)
    )
end

            Items["MainFrame"]:MakeDraggable()
            do
    local V = Camera.ViewportSize
    Items["MainFrame"]:MakeResizeable(Vector2New(220, 220), Vector2New(V.X - 10, V.Y - 10))
end

            if IsMobile then
                Instances:Create("UIScale", {
                    Parent = Library.Holder.Instance,
                    Scale = 0.7
                })
            end
            
            Items["AccentBorder"] = Instances:Create("UIStroke", {
                Parent = Items["MainFrame"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(235, 157, 255)
            })  Items["AccentBorder"]:AddToTheme({Color = "Accent"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["MainFrame"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Window.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 6, 0, 1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 7, 0, 20),
                BorderColor3 = FromRGB(27, 27, 32),
                Size = UDim2New(1, -14, 1, -27),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Border,
                Name = "\0"
            }):AddToTheme({Color = "Border"})
            
            Items["Pages"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 7),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 0, 19),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Position = UDim2New(0, 7, 0, 26),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, -14, 1, -33),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Content"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
        
            Instances:Create("UIStroke", {
                Parent = Items["Content"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Outline,
                Name = "\0"
            }):AddToTheme({Color = "Outline"})

            if IsMobile then
                Items["FloatingButton"] = Instances:Create("TextButton", {
                    Parent = Library.Holder.Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Position = UDim2New(0.5, 0, 0, 20),
                    AnchorPoint = Vector2New(0.5, 0),
                    Visible = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 50, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 0,
                    ZIndex = 127,
                    BackgroundColor3 = Library.Theme.Background
                })  Items["FloatingButton"]:AddToTheme({BackgroundColor3 = "Background"})

                --
                local Gui = Items["FloatingButton"].Instance

                local Dragging = false 
                local DragStart
                local StartPosition 

                local Set = function(Input)
                    local DragDelta = Input.Position - DragStart
                    Items["FloatingButton"]:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
                end

                Items["FloatingButton"]:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true

                        DragStart = Input.Position
                        StartPosition = Gui.Position

                        Input.Changed:Connect(function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                Dragging = false
                            end
                        end)
                    end
                end)

                Library:Connect(UserInputService.InputChanged, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        if Dragging then
                            Set(Input)
                        end
                    end
                end)

                Instances:Create("TextLabel", {
                    Parent = Items["FloatingButton"].Instance,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Name = "\0",
                    TextSize = 12,
                    Text = "Close",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    ZIndex = 127,
                    Size = UDim2New(1, -25, 1, -25),
                    BorderSizePixel = 0,
                    TextColor3 = FromRGB(255, 255, 255),
                    FontFace = Library.Font,
                    TextTransparency = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }):AddToTheme({TextColor3 = "Text"})

                Instances:Create("UICorner", {
                    Parent = Items["FloatingButton"].Instance,
                    CornerRadius = UDimNew(1, 0)
                }) 
            end
        end

        local Debounce = false

        function Window:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Window.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["MainFrame"].Instance.Visible = true
            end

            local Descendants = Items["MainFrame"].Instance:GetDescendants()
            TableInsert(Descendants, Items["MainFrame"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["MainFrame"].Instance.Visible = Bool
            end)
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        if IsMobile then
            Items["FloatingButton"]:Connect("MouseButton1Down", function()
                Window:SetOpen(not Window.IsOpen)
            end)
        end

        Window.Elements = Items

        return setmetatable(Window, Library)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Name = Data.Name or Data.name or "Page",
            Columns = Data.Columns or Data.columns or 2,

            HasSubtabs = Data.Subtabs or Data.subtabs or false,

            Active = false,
            ColumnsData = { },
            Elements = { }
        }

        local Items = { } do 
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = Page.Window.Elements["Pages"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(30, 30, 35)
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Outline,
                Name = "\0"
            }):AddToTheme({Color = "Outline"})
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Inactive"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.47999998927116394,
                Text = Page.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 3),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})
            
            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["MiscPixel1"]:AddToTheme({BackgroundColor3 = "Outline"})
            
            Items["MiscPixel2"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 1, 0, 1),
                Size = UDim2New(0, 1, 0, 1),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["MiscPixel2"]:AddToTheme({BackgroundColor3 = "Outline"})
            
            Items["UIGradient"] = Instances:Create("UIGradient", {
                Parent = Items["Inactive"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(108, 108, 108))}
            })            

            Items["Page"] = Instances:Create("Frame", {
                Parent = Page.Window.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255),
                Visible = false
            })
            
            if not Page.HasSubtabs then 
                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })
                
                for Index = 1, Page.Columns do
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        ScrollBarImageColor3 = FromRGB(235, 157, 255),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 1,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 100, 0, 100),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        BottomImage = Library:GetImage("Scrollbar"),
                        MidImage = Library:GetImage("Scrollbar"),
                        TopImage = Library:GetImage("Scrollbar"),
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})
                    
                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        PaddingTop = UDimNew(0, 6),
                        PaddingBottom = UDimNew(0, 6),
                        PaddingRight = UDimNew(0, 6),
                        PaddingLeft = UDimNew(0, 6)
                    })
                    
                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Padding = UDimNew(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }) 

                    Page.ColumnsData[Index] = NewColumn
                end
            else
                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 7, 0, 45),
                    BorderColor3 = FromRGB(10, 10, 10),
                    Size = UDim2New(1, -14, 1, -52),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(15, 15, 20)
                })  Items["Columns"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["SubTabs"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 7, 0, 7),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -14, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = Items["SubTabs"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end
        end

        local Debounce = false

        function Page:Turn(Bool)
            if Debounce then 
                return 
            end

            Page.Active = Bool

            Debounce = true 

            if Bool then 
                Items["Page"].Instance.Visible = true

                Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                Items["Hide"].Instance.Visible = true

                Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
            else
                Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.5})
                Items["Hide"].Instance.Visible = false

                Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            end

            local Descendants = Items["Page"].Instance:GetDescendants()
            TableInsert(Descendants, Items["Page"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Page.Window.FadeSpeed or 0.5)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Page.Window.FadeSpeed or 0.5)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["Page"].Instance.Visible = Bool
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in Page.Window.Pages do
                Value:Turn(Value == Page)
            end
        end)

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        Page.Elements = Items

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

    Library.Pages.SubPage = function(self, Data)
        Data = Data or { }

        local SubPage = {
            Window = self.Window,
            Page = self,

            Icon = Data.Icon or Data.icon or "9080568477801",
            Columns = Data.Columns or Data.columns or 2,

            Active = false,
            ColumnsData = { },
            Elements = { }
        }

        local Items = { } do
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = SubPage.Page.Elements["SubTabs"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, -2),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(30, 30, 35)
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})

            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 2),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            }) 

            Items["MiscPixel2"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 1, 0, 1),
                Size = UDim2New(0, 1, 0, 1),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            }) 

            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Inactive"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                ImageTransparency = 0.35,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://"..SubPage.Icon,
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(0, 30, 0, 30),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})

            Instances:Create("UIGradient", {
                Parent = Items["Inactive"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(138, 138, 138))}
            }) 

            Items["Subtab"] = Instances:Create("Frame", {
                Parent = SubPage.Page.Elements["Columns"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["Subtab"].Instance,
                PaddingTop = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Subtab"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalFlex = Enum.UIFlexAlignment.Fill
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Subtab"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            for Index = 1, SubPage.Columns do
                local NewColumn = Instances:Create("ScrollingFrame", {
                    Parent = Items["Subtab"].Instance,
                    ScrollBarImageColor3 = FromRGB(235, 157, 255),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 1,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 100, 0, 100),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Instances:Create("UIPadding", {
                    Parent = NewColumn.Instance,
                    PaddingTop = UDimNew(0, 6),
                    PaddingBottom = UDimNew(0, 6),
                    PaddingRight = UDimNew(0, 6),
                    PaddingLeft = UDimNew(0, 6)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = NewColumn.Instance,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 

                SubPage.ColumnsData[Index] = NewColumn
            end
        end

        local Debounce = false

        function SubPage:Turn(Bool)
            if Debounce then 
                return 
            end

            SubPage.Active = Bool

            Debounce = true 

            if Bool then 
                Items["Subtab"].Instance.Visible = true

                Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})
                Items["Hide"].Instance.Visible = true

                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})

                Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, 1)
            else
                Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.35})
                Items["Hide"].Instance.Visible = false

                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})
                Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, -2)
            end

            local Descendants = Items["Subtab"].Instance:GetDescendants()
            TableInsert(Descendants, Items["Subtab"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, SubPage.Window.FadeSpeed or 0.5)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, SubPage.Window.FadeSpeed or 0.5)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["Subtab"].Instance.Visible = Bool
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in SubPage.Window.SubPages do
                Value:Turn(Value == SubPage)
            end
        end)

        if #SubPage.Window.SubPages == 0 then 
            SubPage:Turn(true)
        end

        SubPage.Elements = Items

        TableInsert(SubPage.Window.SubPages, SubPage)
        return setmetatable(SubPage, Library.Pages)
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,

            Elements = { }
        }

        local Items = { } do 
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6)
            })
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                Size = UDim2New(1, -12, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0, 2),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 1, -20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Pages.MultiSection = function(self, Data)
        local MultiSection = {
            Window = self.Window,
            Page = self,
            
            Sections = Data.Sections or Data.sections or { "Section 1", "Section 2", "Section 3" }, 
            Side = Data.Side or Data.side or 1,

            SectionContents = { },

            Elements = { }
        }

        local Items = { } do
            Items["MultiSection"] = Instances:Create("Frame", {
                Parent = MultiSection.Page.ColumnsData[MultiSection.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["MultiSection"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["MultiSection"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["MultiSection"].Instance,
                PaddingBottom = UDimNew(0, 6)
            }) 
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Items["Sections"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 9),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 0, 19),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["Sections"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDimNew(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 35),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, -14, 1, -33),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(15, 15, 20)
            }) 
        end

        for Index, Value in MultiSection.Sections do 
            local NewSection = {
                Window = MultiSection.Window,
                Page = MultiSection.Page,
                MultiSection = MultiSection,

                Name = Value,

                Elements = { },

                Active = false,
            }

            local SubItems = { } do 
                SubItems["Inactive"] = Instances:Create("TextButton", {
                    Parent = Items["Sections"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(10, 10, 10),
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 30, 35)
                })  SubItems["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

                SubItems["Text"] = Instances:Create("TextLabel", {
                    Parent = SubItems["Inactive"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(215, 215, 215),
                    TextTransparency = 0.48,
                    Text = NewSection.Name,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, -1),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  SubItems["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = SubItems["Text"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0"
                }):AddToTheme({Color = "Text Border"})

                SubItems["Hide"] = Instances:Create("Frame", {
                    Parent = SubItems["Inactive"].Instance,
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Name = "\0",
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 3),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(15, 15, 20)
                })  SubItems["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

                SubItems["MiscPixel1"] = Instances:Create("Frame", {
                    Parent = SubItems["Hide"].Instance,
                    Size = UDim2New(0, 1, 0, 1),
                    Name = "\0",
                    Position = UDim2New(0, -1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(27, 27, 32)
                })  SubItems["MiscPixel1"]:AddToTheme({BackgroundColor3 = "Outline"})

                SubItems["MiscPixel2"] = Instances:Create("Frame", {
                    Parent = SubItems["Hide"].Instance,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    Name = "\0",
                    Position = UDim2New(1, 1, 0, 1),
                    Size = UDim2New(0, 1, 0, 1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(27, 27, 32)
                })  SubItems["MiscPixel2"]:AddToTheme({BackgroundColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = SubItems["Inactive"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0",
                    Color = FromRGB(27, 27, 32)
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIGradient", {
                    Parent = SubItems["Inactive"].Instance,
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(108, 108, 108))}
                }) 

                SubItems["Content"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 
                
                Instances:Create("UIListLayout", {
                    Parent = SubItems["Content"].Instance,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end

            local Debounce = false

            function NewSection:Turn(Bool)
                if Debounce then 
                    return 
                end

                NewSection.Active = Bool

                Debounce = true 

                if Bool then 
                    SubItems["Content"].Instance.Visible = true

                    SubItems["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})

                    SubItems["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                else
                    SubItems["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.5})

                    SubItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                end

                local Descendants = SubItems["Content"].Instance:GetDescendants()
                TableInsert(Descendants, SubItems["Content"].Instance)

                local NewTween
                for Index, Value in Descendants do 
                    local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                    if not ValueIndex then 
                        continue
                    end

                    if type(ValueIndex) == "table" then
                        for _, Property in ValueIndex do 
                            NewTween = Library:FadeItem(Value, Property, Bool, MultiSection.Window.FadeSpeed or 0.5)
                        end
                    else
                        NewTween = Library:FadeItem(Value, ValueIndex, Bool, MultiSection.Window.FadeSpeed or 0.5)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    SubItems["Content"].Instance.Visible = Bool
                end)
            end

            SubItems["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in MultiSection.SectionContents do
                    Value:Turn(Value == NewSection)
                end
            end)

            if #MultiSection.SectionContents == 0 then 
                NewSection:Turn(true)
            end

            NewSection.Elements = SubItems

            MultiSection.SectionContents[#MultiSection.SectionContents+1] = setmetatable(NewSection, Library.Sections)
        end

        MultiSection.SectionContents[1]:Turn(true)
        MultiSection.Window.Sections[#MultiSection.Window.Sections+1] = MultiSection
        return TableUnpack(MultiSection.SectionContents)
    end

    Library.Pages.ScrollableSection = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,
            Size = Data.Size or Data.size or 175,

            Elements = { }
        }

        local Items = { } do 
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, Section.Size),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})

            Items["Fade"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 20),
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 2),
                BorderSizePixel = 0,
                ZIndex = 15,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["Fade"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIGradient", {
                Parent = Items["Fade"].Instance,
                Rotation = -90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.718, 0.768750011920929), NumSequenceKeypoint(1, 1)}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6)
            })
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                Size = UDim2New(1, -12, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0, 2),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                ScrollBarThickness = 3,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(235, 157, 255),
                MidImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BottomImage = Library:GetImage("Scrollbar"),
                Active = true,
                BackgroundTransparency = 1,
                ZIndex = 16,
                Position = UDim2New(0, 0, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, -20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Content"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIPadding", {
                Parent = Items["Content"].Instance,
                PaddingTop = UDimNew(0, 0),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 11),
                PaddingLeft = UDimNew(0, 8)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Sections.Divider = function(self)
        local Divider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
        }

        local Items = { } do
            Items["Divider"] = Instances:Create("Frame", {
                Parent = Divider.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["RealDivider"] = Instances:Create("Frame", {
                Parent = Items["Divider"].Instance,
                AnchorPoint = Vector2New(0, 0.5),
                Name = "\0",
                Position = UDim2New(0, 0, 0.5, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 3),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["RealDivider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["RealDivider"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})
        end
        
        function Divider:SetVisibility(Bool)
            Items["Divider"].Instance.Visible = Bool
        end

        return Divider
    end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end,

            Value = false,
            Class = "Toggle",

            Count = 0
        }

        local Items = { } do 
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Elements["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 11),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Toggle.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                Position = UDim2New(0, 18, 0, -1),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Toggle"]:OnHoverLeave(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end
        
        function Toggle:Get()
            return Toggle.Value
        end

        function Toggle:Set(Bool)
            Toggle.Value = Bool or not Toggle.Value

            Library.Flags[Toggle.Flag] = Toggle.Value

            if Toggle.Value then 
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
            else
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["Text"]:Tween(nil, {TextTransparency = 0.48})
            end

            if Toggle.Callback then 
                Library:SafeCall(Toggle.Callback, Toggle.Value)
            end
        end

        function Toggle:SetVisiblity(Bool)
            Items["Toggle"].Instance.Visible = Bool
        end

        function Toggle:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Toggle"],
                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or false,
                Count = Toggle.Count,

                FadeSpeed = self.Window.FadeSpeed
            }

            Toggle.Count += 1
            Colorpicker.Count = Toggle.Count

            local Extension = Library:CreateColorpicker(Colorpicker)
            Library.Flags[Colorpicker.Flag] = Extension

            return Colorpicker
        end

        function Toggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Toggle"],
                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "MB2",
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,
            }

            local Extension = Library:CreateKeybind(Keybind)
            Library.Flags[Keybind.Flag] = Extension

            return Keybind, Extension
        end

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Toggle:Set()
        end)

        if Toggle.Default then 
            Toggle:Set(Toggle.Default)
        end

        Library.SetFlags[Toggle.Flag] = function(Value)
            Toggle:Set(Value)
        end

        return Toggle
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name,
            Callback = Data.Callback or Data.callback or function() end,
        }

        local Items = { } do 
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Button.Section.Elements["Content"].Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 17),
                Selectable = false,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

            Instances:Create("UIGradient", {
                Parent = Items["Button"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Button"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"}) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Button"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["TextBorder"] = Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Button"]:OnHover(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Button"]:OnHoverLeave(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end

        function Button:Press()
            Library:SafeCall(Button.Callback)

            Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

            task.wait(0.1)

            Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end

        function Button:SetVisiblity(Bool)
            Items["Button"].Instance.Visible = Bool
        end

        Items["Button"]:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return Button
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }

        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Default = Data.Default or Data.default or 0,
            Max = Data.Max or Data.max or 100,
            Suffix = Data.Suffix or Data.suffix or "",
            Decimals = Data.Decimals or Data.decimals or 1,
            Callback = Data.Callback or Data.callback or function() end,
            Compact = Data.Compact or Data.compact or false,

            Value = 0,
            Sliding = false,
            Class = "Slider",
        }

        local Items = { } do 
            Items["Slider"] = Instances:Create("Frame", {
                Parent = Slider.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 27),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Slider.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["RealSlider"] = Instances:Create("TextButton", {
                Parent = Items["Slider"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealSlider"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["RealSlider"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["RealSlider"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0.5, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealSlider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "50/100s",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            if Slider.Compact then 
                Items["Value"]:Clean()
                Items["Value"] = nil

                Items["Slider"].Instance.Size = UDim2New(1,0,0,10)
                Items["Text"].Instance.Parent = Items["RealSlider"].Instance
                Items["Text"].Instance.Position = UDim2New(0,0,0,-2)
                Items["Text"].Instance.TextXAlignment = Enum.TextXAlignment.Center
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["RealSlider"]:OnHoverLeave(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Background"]})
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            end)
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)

            Library.Flags[Slider.Flag] = Slider.Value
            
            if Slider.Compact then
                Items["Text"].Instance.Text = `{Slider.Name}: {Slider.Value}{Slider.Suffix}`
            else
                Items["Value"].Instance.Text = `{Slider.Value}{Slider.Suffix}`
            end

            Items["Indicator"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})

            if Slider.Callback then 
                Library:SafeCall(Slider.Callback, Slider.Value)
            end
        end

        function Slider:Get()
            return Slider.Value
        end

        function Slider:SetVisibility(Bool)
            Items["Slider"].Instance.Visible = Bool
        end

        Items["RealSlider"]:Connect("MouseButton1Down", function()
            Slider.Sliding = true

            local MousePos = UserInputService:GetMouseLocation()

            local SizeX = (MousePos.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
            local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

            Slider:Set(Value)
        end)

        Items["RealSlider"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Slider.Sliding = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement and Slider.Sliding then
                local MousePos = UserInputService:GetMouseLocation()

                local SizeX = (MousePos.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(Value)
            end
        end)

        if Slider.Default then
            Slider:Set(Slider.Default)
        end

        Library.SetFlags[Slider.Flag] = function(Value)
            Slider:Set(Value)
        end

        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { "One", "Two", "Three" },
            Default = Data.Default or Data.default or nil,
            Callback = Data.Callback or Data.callback or function() end,
            Multi = Data.Multi or Data.multi or false,

            Value = { },
            IsOpen = false,
            Options = { },
            Class = "Dropdown",
        }

        local Items = { } do
            Items["Dropdown"] = Instances:Create("Frame", {
                Parent = Dropdown.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Dropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["RealDropdown"] = Instances:Create("Frame", {
                Parent = Items["Dropdown"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["RealDropdown"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["RealDropdown"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Open"] = Instances:Create("TextButton", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "+",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(0, -4, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Open"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Open"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"}) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "--",
                Name = "\0",
                Size = UDim2New(1, -25, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 5, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["OptionHolder"] = Instances:Create("Frame", {
                Parent = Items["Dropdown"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(10, 10, 10),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 5),
                Size = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})

            Instances:Create("UIListLayout", {
                Parent = Items["OptionHolder"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["OptionHolder"].Instance,
                PaddingBottom = UDimNew(0, 2)
            })

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["RealDropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Background"]})
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            end)
        end

        function Dropdown:Set(Option)
            if Dropdown.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Dropdown.Value = Option

                for Index, Value in Option do 
                    local OptionData = Dropdown.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end

                Library.Flags[Dropdown.Flag] = Dropdown.Value

                Items["Value"].Instance.Text = TableConcat(Option, ", ")
            else
                if not Dropdown.Options[Option] then 
                    return
                end

                local OptionData = Dropdown.Options[Option]

                Dropdown.Value = OptionData.Name

                OptionData.Selected = true
                OptionData:Toggle("Active")

                for Index, Value in Dropdown.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end

                Library.Flags[Dropdown.Flag] = Dropdown.Value

                Items["Value"].Instance.Text = Option
            end

            if Dropdown.Callback then 
                Library:SafeCall(Dropdown.Callback, Option)
            end
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        function Dropdown:SetVisibility(Bool)
            Items["Dropdown"].Instance.Visible = Bool
        end

        function Dropdown:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["OptionHolder"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            OptionText:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = OptionText.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local OptionData = {
                Selected = false,
                Name = Option,
                Text = OptionText,
                Button = OptionButton
            }

            function OptionData:Toggle(State)
                if State == "Active" then 
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                else
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.48})
                end
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Dropdown.Multi then
                    local Index = TableFind(Dropdown.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Dropdown.Value, Index)
                    else
                        TableInsert(Dropdown.Value, OptionData.Name)
                    end

                    Library.Flags[Dropdown.Flag] = Dropdown.Value

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                    Items["Value"].Instance.Text = TextFormat
                else
                    if OptionData.Selected then
                        Dropdown.Value = OptionData.Name

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        OptionData:Toggle("Active")
                        Items["Value"].Instance.Text = OptionData.Name

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Dropdown.Value = nil

                        OptionData:Toggle("Inactive")
                        Items["Value"].Instance.Text = "--"
                    end
                end

                if Dropdown.Callback then 
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            OptionButton:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Dropdown.Options[Option] = OptionData
            return OptionData
        end

        function Dropdown:Remove(Option)
            if Dropdown.Options[Option] then 
                Dropdown.Options[Option].Button:Clean()
            end
        end

        function Dropdown:Refresh(List)
            for Index, Value in Dropdown.Options do 
                Dropdown:Remove(Value.Name)
            end

            for Index, Value in List do 
                Dropdown:Add(Value)
            end
        end

        local Debounce = false

        function Dropdown:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Dropdown.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["OptionHolder"].Instance.Visible = true
                Items["OptionHolder"].Instance.ZIndex = 15
                Items["Open"].Instance.Text = "-"
                Items["Open"].Instance.Position = UDim2New(0, -5, 0, -1)
            else
                Items["Open"].Instance.Text = "+"
                Items["Open"].Instance.Position = UDim2New(0, -4, 0, -1)
            end

            local Descendants = Items["OptionHolder"].Instance:GetDescendants()
            TableInsert(Descendants, Items["OptionHolder"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if not StringFind(Value.ClassName, "UI") then 
                    Value.ZIndex = Bool and 15 or 1
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Dropdown.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Dropdown.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["OptionHolder"].Instance.Visible = Bool
                Items["OptionHolder"].Instance.ZIndex = Bool and 15 or 1
            end)
        end

        for Index, Value in Dropdown.Items do 
            Dropdown:Add(Value)
        end

        Items["Open"]:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not Dropdown.IsOpen then
                    return 
                end

                if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                    return
                end

                Dropdown:SetOpen(false)
            end
        end)

        if Dropdown.Default then 
            Dropdown:Set(Dropdown.Default)
        end

        Library.SetFlags[Dropdown.Flag] = function(Value)
            Dropdown:Set(Value)            
        end

        return Dropdown
    end

    Library.Sections.Label = function(self, Data)
        Data = Data or { }

        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name,
            Alignment = Data.Alignment or Data.alignment or "Left",

            Count = 0
        }

        local Items = { } do 
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
            }):AddToTheme({Color = "Text Border"})
        end

        function Label:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Label"],
                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or false,
                Count = Label.Count,
                FadeSpeed = self.Window.FadeSpeed
            }

            Label.Count += 1
            Colorpicker.Count = Label.Count

            local Extension = Library:CreateColorpicker(Colorpicker)
            
            return Colorpicker, Extension
        end

        function Label:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Label"],
                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "MB2",
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,
            }

            local Extension = Library:CreateKeybind(Keybind)

            return Keybind, Extension
        end

        return Label
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Tab = self.Tab,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Placeholder = Data.Placeholder or Data.placeholder or "...",
            Default = Data.Default or Data.default or "",
            Callback = Data.Callback or Data.callback or function() end,

            Value = "",
            Class = "Textbox"
        }

        local Items = { } do 
            Items["Textbox"] = Instances:Create("Frame", {
                Parent = Textbox.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Textbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Background"] = Instances:Create("Frame", {
                Parent = Items["Textbox"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Background"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Background"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Background"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Inline"] = Instances:Create("TextBox", {
                Parent = Items["Background"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                BackgroundTransparency = 1,
                PlaceholderColor3 = FromRGB(178, 178, 178),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Textbox.Placeholder,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Inline"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Inline"].Instance,
                PaddingBottom = UDimNew(0, 3),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Background"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Background"]:OnHoverLeave(function()
                Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Background"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        function Textbox:SetVisibility(Bool)
            Items["Textbox"].Instance.Visible = Bool
        end

        function Textbox:Set(Value)
            Textbox.Value = Value
            
            Items["Inline"].Instance.Text = Textbox.Value
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Text"})

            Library.Flags[Textbox.Flag] = Textbox.Value

            if Textbox.Callback then
                Library:SafeCall(Textbox.Callback, Textbox.Value)
            end
        end

        Items["Inline"]:Connect("Focused", function()
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
        end)

        Items["Inline"]:Connect("FocusLost", function()
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Text})

            Textbox:Set(Items["Inline"].Instance.Text)
        end)

        if Textbox.Default then
            Textbox:Set(Textbox.Default)
        end

        Library.SetFlags[Textbox.Flag] = function(Value)
            Textbox:Set(Value)
        end

        return Textbox
    end
    
    Library.Sections.Listbox = function(self, Data)
        Data = Data or {}

        local Listbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Items = Data.Items or Data.items or { },
            Multi = Data.Multi or Data.multi or false,
            Default = Data.Default or Data.default or 1,
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Callback = Data.Callback or Data.callback or function() end,
            Size = Data.Size or Data.size or 175,

            Value = { },
            Options = { },
            Class = "Listbox",
        }

        local Items = { } do 
            Items["Listbox"] = Instances:Create("Frame", {
                Parent = Listbox.Section.Elements["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, Listbox.Size),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["RealListbox"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Listbox"].Instance,
                ScrollBarImageColor3 = FromRGB(235, 157, 255),
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 1,
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(1, 0, 1, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = FromRGB(15, 15, 20),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                CanvasSize = UDim2New(0, 0, 0, 0)
            })  Items["RealListbox"]:AddToTheme({ScrollBarImageColor3 = "Accent", BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealListbox"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"}) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["RealListbox"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["RealListbox"].Instance,
                PaddingBottom = UDimNew(0, 5),
                PaddingTop = UDimNew(0, 2)
            }) 
        end

        function Listbox:Set(Option)
            if Listbox.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Listbox.Value = Option

                Library.Flags[Listbox.Flag] = Listbox.Value

                for Index, Value in Option do 
                    local OptionData = Listbox.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end
            else
                if not Listbox.Options[Option] then 
                    return
                end

                local OptionData = Listbox.Options[Option]

                Listbox.Value = OptionData.Name
                
                Library.Flags[Listbox.Flag] = Listbox.Value

                OptionData.Selected = true
                OptionData:Toggle("Active")

                for Index, Value in Listbox.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end
            end

            if Listbox.Callback then 
                Library:SafeCall(Listbox.Callback, Option)
            end
        end

        function Listbox:Get()
            return Listbox.Value
        end

        function Listbox:SetVisibility(Bool)
            Items["Listbox"].Instance.Visible = Bool
        end

        function Listbox:Remove(Option)
            if Listbox.Options[Option] then 
                Listbox.Options[Option].Button:Clean()
            end
        end

        function Listbox:Refresh(List)
            for Index, Value in Listbox.Options do 
                Listbox:Remove(Value.Name)
            end

            for Index, Value in List do 
                Listbox:Add(Value)
            end
        end

        function Listbox:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["RealListbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            OptionText:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = OptionText.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local OptionData = {
                Selected = false,
                Name = Option,
                Text = OptionText,
                Button = OptionButton
            }

            function OptionData:Toggle(State)
                if State == "Active" then 
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                else
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.48})
                end
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Listbox.Multi then
                    local Index = TableFind(Listbox.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Listbox.Value, Index)
                    else
                        TableInsert(Listbox.Value, OptionData.Name)
                    end

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Listbox.Value > 0 and TableConcat(Listbox.Value, ", ") or "--"
                else
                    if OptionData.Selected then
                        Listbox.Value = OptionData.Name

                        OptionData:Toggle("Active")

                        for Index, Value in Listbox.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Listbox.Value = nil

                        OptionData:Toggle("Inactive")
                    end
                end

                if Listbox.Callback then 
                    Library:SafeCall(Listbox.Callback, Listbox.Value)
                end
            end

            OptionButton:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Listbox.Options[Option] = OptionData
            return OptionData
        end

        for Index, Value in Listbox.Items do 
            Listbox:Add(Value)
        end

        if Listbox.Default then 
            Listbox:Set(Listbox.Default)
        end

        Library.SetFlags[Listbox.Flag] = function(Value)
            Listbox:Set(Value)
        end

        return Listbox
    end

    Library.CreateSettingsPage = function(self, Window, Watermark, KeybindList)
        local SettingsTab = Window:Page({Name = "Settings", Columns = 2, Subtabs = false})

        do -- Settings Tab
            local SettingsSection = SettingsTab:Section({Name = "Settings", Side = 2})
            local ConfigsSection = SettingsTab:Section({Name = "Profiles", Side = 1})
        
            for Index, Value in Library.Theme do 
                SettingsSection:Label({Name = Index, Alignment = "Left"}):Colorpicker({ Name = Index, Default = Value, Flag = "Theme"..Index, Callback = function(Color) 
                    Library.Theme[Index] = Color
                    Library:ChangeTheme(Index, Color)
                end})
            end
        
            SettingsSection:Label({Name = "Menu Keybind", Alignment = "Left"}):Keybind({Name = "Menu Keybind", Flag = "Menu Keybind", Default = Enum.KeyCode.RightControl, Mode = "Toggle", Callback = function(Value)
                Library.MenuKeybind = Library.Flags["Menu Keybind"].Key
            end})
        
            SettingsSection:Toggle({Name = "Watermark", Flag = "Watermark", Default = false, Callback = function(Value)
                Watermark:SetVisibility(Value)
            end})
        
            SettingsSection:Toggle({Name = "Keybind List", Flag = "Keybind List", Default = false, Callback = function(Value)
                KeybindList:SetVisibility(Value)
            end})
        
            SettingsSection:Dropdown({Name = "Tweening Style", Flag = "Tweening Style", Default = "Exponential", Items = {"Linear", "Sine", "Quad", "Cubic", "Quart", "Quint", "Exponential", "Circular", "Back", "Elastic", "Bounce"}, Callback = function(Value)
                Library.Tween.Style = Enum.EasingStyle[Value]
            end})
        
            SettingsSection:Dropdown({Name = "Tweening Direction", Flag = "Tweening Direction", Default = "Out", Items = {"In", "Out", "InOut"}, Callback = function(Value)
                Library.Tween.Direction = Enum.EasingDirection[Value]
            end})
        
            SettingsSection:Slider({Name = "Tweening Time", Min = 0, Max = 5, Default = 0.25, Decimals = 0.01, Flag = "Tweening Time", Callback = function(Value)
                Library.Tween.Time = Value
            end})
        
            SettingsSection:Button({Name = "Notification test", Callback = function()
                Library:Notification("This is a notification This is a notification This is a notification This is a notification", 5, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
            end})
        
            SettingsSection:Button({Name = "Unload library", Callback = function()
                Library:Unload()
            end})
        
            local ConfigName 
            local ConfigSelected
        
            local ConfigsListbox = ConfigsSection:Listbox({Items = { }, Name = "Configs", Flag = "Configs List", Callback = function(Value)
                ConfigSelected = Value
            end})
        
            ConfigsSection:Textbox({Name = "Config Name", Placeholder = ". .", Flag = "Config Name", Callback = function(Value)
                ConfigName = Value
            end})
        
            ConfigsSection:Button({Name = "Create Config", Callback = function()
                if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                    writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
        
                    Library:RefreshConfigsList(ConfigsListbox)
                else
                    Library:Notification("Config '" .. ConfigName .. ".json' already exists", 3, Color3.FromR(255, 0, 0))
                    return
                end
            end})
        
            ConfigsSection:Button({Name = "Load Config", Callback = function()
                if ConfigSelected then
                    Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
                end
        
                    task.wait(0.1)
        
                    for Index, Value in Library.Theme do 
                        Library.Theme[Index] = Library.Flags["Theme"..Index].Color
                        Library:ChangeTheme(Index, Library.Flags["Theme"..Index].Color)
                    end    
            end})
        
            ConfigsSection:Button({Name = "Delete Config", Callback = function()
                if ConfigSelected then
                    Library:DeleteConfig(ConfigSelected)
        
                    Library:RefreshConfigsList(ConfigsListbox)
                end
            end})
        
            ConfigsSection:Button({Name = "Save Config", Callback = function()
                if ConfigSelected then
                    Library:SaveConfig(ConfigSelected)
                end
            end})
        
            ConfigsSection:Button({Name = "Refresh Configs", Callback = function()
                Library:RefreshConfigsList(ConfigsListbox)
            end})

            ConfigsSection:Divider()

            ConfigsSection:Button({Name = "Set As Autoload", Callback = function()
                if ConfigSelected then 
                    writefile(Library.Folders.Directory .. "/autoload.json", readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
                end
            end})

            ConfigsSection:Button({Name = "Remove Autoload", Callback = function()
                writefile(Library.Folders.Directory .. "/autoload.json", "")
            end})
        
            Library:RefreshConfigsList(ConfigsListbox)
        end

        Library.Init = function(self)
            local IsAutoload = readfile(Library.Folders.Directory .. "/autoload.json")

            if IsAutoload ~= "" then
                Library:LoadConfig(IsAutoload)
            end
        end
    end
end

getgenv().Library = Library

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ===== UI =====
local MobileButtonGUI = LocalPlayer.PlayerGui:WaitForChild("MobileButtonGUI")
local TouchControlFrame = MobileButtonGUI:WaitForChild("TouchControlFrame")
local SprintButton = TouchControlFrame:WaitForChild("SprintButton")

local Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Notification")

local desyncGui = Instance.new("ScreenGui")
desyncGui.Name = "DesyncButtonGUI"
desyncGui.ResetOnSpawn = false
desyncGui.IgnoreGuiInset = true
desyncGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
desyncGui.Parent = LocalPlayer.PlayerGui

local newButton = SprintButton:Clone()
newButton.Name = "DesyncButton"
newButton.Parent = desyncGui

for _, d in ipairs(newButton:GetDescendants()) do
    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
        d.Text = "chz.lol"
    end
end
if newButton:IsA("TextButton") or newButton:IsA("TextLabel") then
    newButton.Text = "chz.lol"
end

newButton.AnchorPoint = Vector2.new(0, 0)
newButton.Position = UDim2.new(0, 60, 0, 80)
newButton.Active = true
newButton.Selectable = true
newButton.AutoButtonColor = true

-- ===== Desync 状态 =====
local isDesyncOn = false
local desyncRunning = false      -- 循环是否应继续
local desyncThread = nil         -- 当前线程
local desyncConn = nil           -- CharacterAdded 连接

-- 复原用的默认值（不同游戏可能不同，按需改）
local DEFAULT_SENDER_RATE = 60

local function resetPhysicsRep(hrp)
    if hrp and hrp.Parent then
        pcall(sethiddenproperty, hrp, "PhysicsRepRootPart", hrp)
    end
end

local function startDesync()
    if desyncRunning then return end
    desyncRunning = true

    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    pcall(setfflag, "S2PhysicsSenderRate", 1000)

    local dsfs = 0
    local issyncinrn = false

    desyncThread = task.spawn(function()
        while desyncRunning and LocalPlayer.Character == Character
              and HumanoidRootPart.Parent do

            if issyncinrn then task.wait() continue end

            if dsfs <= 0 then
                issyncinrn = true
                pcall(sethiddenproperty, HumanoidRootPart, "PhysicsRepRootPart", nil)
                task.wait(0.1)
                if not desyncRunning then
                    issyncinrn = false
                    break
                end
                pcall(sethiddenproperty, HumanoidRootPart, "PhysicsRepRootPart", HumanoidRootPart)
                issyncinrn = false
                dsfs = 20
            else
                dsfs = dsfs - 1
                pcall(sethiddenproperty, HumanoidRootPart, "PhysicsRepRootPart", HumanoidRootPart)
            end

            task.wait(1 / 100)
        end

        -- 循环退出后强制复原，保证“关闭即失效”
        resetPhysicsRep(HumanoidRootPart)
        desyncThread = nil
    end)
end

local function stopDesync()
    if not desyncRunning then return end
    desyncRunning = false

    local Character = LocalPlayer.Character
    if Character then
        resetPhysicsRep(Character:FindFirstChild("HumanoidRootPart"))
    end

    desyncThread = nil
    pcall(setfflag, "S2PhysicsSenderRate", DEFAULT_SENDER_RATE)
end

-- 角色重生时自动续接（开着才续）
desyncConn = LocalPlayer.CharacterAdded:Connect(function()
    if isDesyncOn then
        task.wait(0.5)
        -- 旧循环已因角色变化退出，重启一个
        desyncRunning = false
        task.wait()
        startDesync()
    end
end)

-- ===== 按钮 =====
newButton.Activated:Connect(function()
    isDesyncOn = not isDesyncOn

    if isDesyncOn then
        startDesync()
    else
        stopDesync()
    end

    local stateText = isDesyncOn and "on" or "off"
    local buttonText = isDesyncOn and "close" or "know"

    firesignal(Event.OnClientEvent, {
        Text = "chz.lol (" .. stateText .. ")",
        Duration = 60,
        Title = "chz.lol",
        Button1 = buttonText
    }, "BEEP")
end)

-- ============================================================
-- == Misc 功能
-- ============================================================
do
    local RepStorage  = game:GetService("ReplicatedStorage")
    local Workspace   = game:GetService("Workspace")
    local LocalPlayer = game:GetService("Players").LocalPlayer

    SC = SC or {AUS_Loop=nil, AUS_Enabled=false, APM_Loop=nil, APM_Enabled=false}
    MC = MC or {AutoBuyAmmo=false}

    function StartAutoUnlockSafe()
        if SC.AUS_Loop then return end
        SC.AUS_Loop = task.spawn(function()
            while SC.AUS_Enabled do
                local processed = false
                local char = LocalPlayer.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    local map        = Workspace:FindFirstChild("Map")
                    local bredMakurz = map and map:FindFirstChild("BredMakurz")
                    if bredMakurz then
                        local closestSafe, minDist = nil, 12
                        for _, obj in ipairs(bredMakurz:GetChildren()) do
                            if string.find(string.lower(obj.Name), "safe") then
                                local vals   = obj:FindFirstChild("Values")
                                local broken = vals and vals:FindFirstChild("Broken")
                                if broken and broken.Value == false then
                                    local part = obj:IsA("Model") and obj.PrimaryPart
                                              or obj:FindFirstChildWhichIsA("BasePart") or obj
                                    if part and part:IsA("BasePart") then
                                        local dist = (hrp.Position - part.Position).Magnitude
                                        if dist <= minDist then minDist = dist; closestSafe = obj end
                                    end
                                end
                            end
                        end
                        if closestSafe then
                            processed = true
                            local lockpick = char:FindFirstChild("Lockpick")
                            if not lockpick then
                                local bp = LocalPlayer.Backpack:FindFirstChild("Lockpick")
                                if bp then hum:EquipTool(bp); lockpick = bp; task.wait(0.25) end
                            end
                            if lockpick then
                                local remote = lockpick:FindFirstChild("Remote")
                                if remote then
                                    local token = nil
                                    for attempt = 1, 8 do
                                        pcall(function() token = remote:InvokeServer("S", closestSafe, "s") end)
                                        if token then break end
                                        task.wait(0.15)
                                    end
                                    if token then
                                        task.spawn(function() pcall(function() remote:InvokeServer("D", closestSafe, "s", token) end) end)
                                        task.spawn(function() pcall(function() remote:InvokeServer("C") end) end)
                                        task.wait(0.8)
                                        local vals2   = closestSafe:FindFirstChild("Values")
                                        local broken2 = vals2 and vals2:FindFirstChild("Broken")
                                        if broken2 and not broken2.Value then
                                            pcall(function() remote:InvokeServer("D", closestSafe, "s", token) end)
                                            task.wait(0.5)
                                        end
                                    end
                                end
                            end
                            task.wait(0.5)
                        end
                    end
                end
                if not processed then task.wait(0.1) end
            end
            SC.AUS_Loop = nil
        end)
    end

    SafeChamsEnabled = SafeChamsEnabled or false
    SafeChamsLoop    = SafeChamsLoop or nil
    function StartSafeChams()
        if SafeChamsLoop then return end
        SafeChamsLoop = task.spawn(function()
            while SafeChamsEnabled do
                local map = Workspace:FindFirstChild("Map")
                local bredMakurz = map and map:FindFirstChild("BredMakurz")
                if bredMakurz then
                    for _, obj in ipairs(bredMakurz:GetChildren()) do
                        if string.find(string.lower(obj.Name), "safe") then
                            local vals = obj:FindFirstChild("Values")
                            local broken = vals and vals:FindFirstChild("Broken")
                            if broken then
                                local hl = obj:FindFirstChild("SafeHighlight")
                                if broken.Value == false then
                                    if not hl then
                                        hl = Instance.new("Highlight")
                                        hl.Name = "SafeHighlight"
                                        hl.FillColor = Color3.fromRGB(0, 255, 0)
                                        hl.FillTransparency = 0.5
                                        hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                                        hl.Parent = obj
                                    end
                                else
                                    if hl then hl:Destroy() end
                                end
                            end
                        end
                    end
                end
                task.wait(1)
            end
            local map = Workspace:FindFirstChild("Map")
            local bredMakurz = map and map:FindFirstChild("BredMakurz")
            if bredMakurz then
                for _, obj in ipairs(bredMakurz:GetChildren()) do
                    local hl = obj:FindFirstChild("SafeHighlight")
                    if hl then hl:Destroy() end
                end
            end
            SafeChamsLoop = nil
        end)
    end

    function StartAutoPickUpMoney()
        if SC.APM_Loop then return end
        SC.APM_Loop = task.spawn(function()
            local event  = RepStorage:FindFirstChild("Events") and RepStorage.Events:FindFirstChild("CZDPZUS")
            local filter = Workspace:FindFirstChild("Filter")
            while SC.APM_Enabled do
                local didPickup = false
                if event and filter then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bread = filter:FindFirstChild("SpawnedBread")
                        if bread then
                            for _, item in ipairs(bread:GetChildren()) do
                                if (hrp.Position - item.Position).Magnitude < 5 then
                                    pcall(function() event:FireServer(item) end)
                                    task.wait(1.1)
                                    didPickup = true
                                    break
                                end
                            end
                        end
                    end
                end
                if not didPickup then task.wait(0.1) end
            end
            SC.APM_Loop = nil
        end)
    end

    local fastPickupEnabled = false
    function bypassProximityPrompts()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
        end
    end
    function enableBypass()
        fastPickupEnabled = true
        bypassProximityPrompts()
        game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(v)
            if fastPickupEnabled then v.HoldDuration = 0 end
        end)
    end
    function disableBypass() fastPickupEnabled = false end

    local shopFolder = workspace:WaitForChild("Map"):WaitForChild("Shopz")
    function findAndInvokeNearest()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if not tool then return end
        local toolName = tool.Name
        local nearestPart, minDistSq = nil, math.huge
        for _, shop in pairs(shopFolder:GetChildren()) do
            local part = shop:FindFirstChild("MainPart") or shop.PrimaryPart
            if part and part:IsA("BasePart") then
                local dSq = (hrp.Position - part.Position).Magnitude^2
                if dSq < minDistSq then minDistSq = dSq; nearestPart = part end
            end
        end
        if nearestPart then
            pcall(function()
                RepStorage.Events.SSHPRMTE1:InvokeServer(
                    "IllegalStore", "Guns", toolName, nearestPart,
                    "ResupplyAmmo", true, nil, nil, nil)
            end)
        end
    end

    task.spawn(function()
        if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
        while true do
            task.wait(1)
            if MC.AutoBuyAmmo then findAndInvokeNearest() end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
--  ESP + Chams + World Visual（含 Camera FOV）
--   ★ 无错误、无弹出报错
--   ★ ESP Box 世界 AABB 8 角投影 → 任意角度都贴合人物
--   ★ 字体 / 血量条随 box 高度动态缩放
--   ★ 血条保留原黑边样式
--   ★ WorldVisual 支持 Fog / Time / Light / Filter / FOV
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
--  World Visual + Camera FOV 功能
-- ═══════════════════════════════════════════════════════════
local WorldVisual = (function()
    local Lighting     = game:GetService("Lighting")
    local TweenService = game:GetService("TweenService")
    local RunService   = game:GetService("RunService")
    local Workspace    = game:GetService("Workspace")

    local TWEEN_TIME = 1.0

    local function tw(obj, props, dur)
        if not obj then return end
        pcall(function()
            local info = TweenInfo.new(
                dur or TWEEN_TIME,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            )
            TweenService:Create(obj, info, props):Play()
        end)
    end

    local Orig = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ExposureCompensation = Lighting.ExposureCompensation,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    }

    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    local atmoWasCreated = false
    if not atmo then
        pcall(function()
            atmo = Instance.new("Atmosphere")
            atmo.Name = "WV_Atmosphere"
            atmo.Parent = Lighting
            atmoWasCreated = true
        end)
    end
    if not atmo then atmo = Instance.new("Atmosphere") end

    local OrigAtmo = {
        Density = atmo.Density or 0,
        Offset = atmo.Offset or 0,
        Glare = atmo.Glare or 0,
        Haze = atmo.Haze or 0,
        Color = atmo.Color or Color3.new(1,1,1),
        Decay = atmo.Decay or Color3.new(1,1,1),
    }

    local function ensureEffect(name, className)
        local e = Lighting:FindFirstChild(name)
        if not e then
            pcall(function()
                e = Instance.new(className)
                e.Name = name
                e.Parent = Lighting
            end)
        end
        if not e then e = Instance.new(className) end
        e.Enabled = false
        return e
    end

    local cc      = ensureEffect("WV_ColorCorrection", "ColorCorrectionEffect")
    local bloom   = ensureEffect("WV_Bloom", "BloomEffect")
    local sunRays = ensureEffect("WV_SunRays", "SunRaysEffect")
    local dof     = ensureEffect("WV_DepthOfField", "DepthOfFieldEffect")

    local fogState = {
        on = false,
        density = 0.16, offset = 0.10, glare = 0.22, haze = 1.40,
        color = Color3.fromRGB(255, 224, 199),
        decay = Color3.fromRGB(158, 174, 214),
        fogStart = 60, fogEnd = 900,
    }

    local timeState = {
        on = false,
        target = 17.2,
        current = Lighting.ClockTime,
        speedMul = 3,
    }

    local lightState = {
        on = false,
        brightness = 2.4,
        ambient = Color3.fromRGB(96, 84, 96),
        outdoor = Color3.fromRGB(158, 140, 126),
        exposure = 0.15,
        diffuse = 0.6,
        specular = 0.6,
    }

    local filterState = {
        on = false,
        brightness = 0.05, contrast = 0.10, saturation = 0.20,
        tint = Color3.fromRGB(255, 240, 220),
        bloomIntensity = 0.45, bloomThreshold = 0.75, bloomSize = 22,
        sunIntensity = 0.08, sunSpread = 0.85,
        dofFar = 120, dofFocus = 55, dofNear = 12,
    }

    local fovState = {
        on = false,
        value = 70,
        orig = (Workspace.CurrentCamera and Workspace.CurrentCamera.FieldOfView) or 70,
    }

    local function applyFog(speed)
        if not fogState.on then return end
        tw(atmo, {
            Density = fogState.density,
            Offset = fogState.offset,
            Glare = fogState.glare,
            Haze = fogState.haze,
            Color = fogState.color,
            Decay = fogState.decay,
        }, speed or 0.35)
        tw(Lighting, {
            FogStart = fogState.fogStart,
            FogEnd = fogState.fogEnd,
            FogColor = fogState.color,
        }, speed or 0.35)
    end

    local function removeFog()
        if atmoWasCreated then
            tw(atmo, {
                Density = 0, Offset = 0, Glare = 0, Haze = 0,
                Color = Color3.new(1,1,1), Decay = Color3.new(1,1,1),
            })
        else
            tw(atmo, OrigAtmo)
        end
        tw(Lighting, {
            FogStart = Orig.FogStart,
            FogEnd = Orig.FogEnd,
            FogColor = Orig.FogColor,
        })
    end

    local function applyLight(speed)
        if not lightState.on then return end
        tw(Lighting, {
            Brightness = lightState.brightness,
            Ambient = lightState.ambient,
            OutdoorAmbient = lightState.outdoor,
            ExposureCompensation = lightState.exposure,
            EnvironmentDiffuseScale = lightState.diffuse,
            EnvironmentSpecularScale = lightState.specular,
        }, speed or 0.35)
    end

    local function removeLight()
        tw(Lighting, {
            Brightness = Orig.Brightness,
            Ambient = Orig.Ambient,
            OutdoorAmbient = Orig.OutdoorAmbient,
            ExposureCompensation = Orig.ExposureCompensation,
            EnvironmentDiffuseScale = Orig.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = Orig.EnvironmentSpecularScale,
        })
    end

    local function applyFilter(speed)
        if not filterState.on then return end
        cc.Enabled = true
        bloom.Enabled = true
        sunRays.Enabled = true
        dof.Enabled = true

        tw(cc, {
            Brightness = filterState.brightness,
            Contrast = filterState.contrast,
            Saturation = filterState.saturation,
            TintColor = filterState.tint,
        }, speed or 0.35)
        tw(bloom, {
            Intensity = filterState.bloomIntensity,
            Threshold = filterState.bloomThreshold,
            Size = filterState.bloomSize,
        }, speed or 0.35)
        tw(sunRays, {
            Intensity = filterState.sunIntensity,
            Spread = filterState.sunSpread,
        }, speed or 0.35)
        tw(dof, {
            FarIntensity = filterState.dofFar / 100,
            FocusDistance = filterState.dofFocus,
            InFocusRadius = filterState.dofNear,
            NearIntensity = 0.25,
        }, speed or 0.35)
    end

    local function removeFilter()
        tw(cc, { Brightness = 0, Contrast = 0, Saturation = 0, TintColor = Color3.new(1,1,1) })
        tw(bloom, { Intensity = 0, Threshold = 1 })
        tw(sunRays, { Intensity = 0 })
        tw(dof, { FarIntensity = 0, NearIntensity = 0 })
        task.delay(TWEEN_TIME + 0.1, function()
            if not filterState.on then
                pcall(function() cc.Enabled = false end)
                pcall(function() bloom.Enabled = false end)
                pcall(function() sunRays.Enabled = false end)
                pcall(function() dof.Enabled = false end)
            end
        end)
    end

    local function applyFOV()
        local cam = Workspace.CurrentCamera
        if not cam then return end
        pcall(function()
            cam.FieldOfView = math.clamp(tonumber(fovState.value) or 70, 1, 120)
        end)
    end

    local function removeFOV()
        local cam = Workspace.CurrentCamera
        if not cam then return end
        pcall(function()
            cam.FieldOfView = fovState.orig
        end)
    end

    -- 时间循环
    RunService.Heartbeat:Connect(function(dt)
        if not timeState.on then return end
        pcall(function()
            local diff = timeState.target - timeState.current
            if diff > 12 then diff = diff - 24 end
            if diff < -12 then diff = diff + 24 end
            local k = math.min(dt * timeState.speedMul * 0.85, 1)
            timeState.current = (timeState.current + diff * k) % 24
            if timeState.current < 0 then timeState.current = timeState.current + 24 end
            Lighting.ClockTime = timeState.current
        end)
    end)

    -- ★ FOV 持续保持（改为 Heartbeat 循环）
-- 依然每帧强制设置 FOV（防止被其他脚本覆盖）
-- 但执行顺序在 RenderStepped 之前，ESP 投影读到的一定是最新 FOV，不会偏框
RunService.Heartbeat:Connect(function()
    if not fovState.on then return end
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local target = math.clamp(tonumber(fovState.value) or 70, 1, 120)
    if math.abs(cam.FieldOfView - target) > 0.01 then
        pcall(function() cam.FieldOfView = target end)
    end
end)

    local function turnAllOn()
        fogState.on = true; applyFog()
        lightState.on = true; applyLight()
        filterState.on = true; applyFilter()
        timeState.on = true
        timeState.current = Lighting.ClockTime
    end

    local function disableAll()
        pcall(function() fogState.on = false; removeFog() end)
        pcall(function() timeState.on = false; Lighting.ClockTime = Orig.ClockTime end)
        pcall(function() lightState.on = false; removeLight() end)
        pcall(function() filterState.on = false; removeFilter() end)
    end

    return {
        fogState = fogState,
        timeState = timeState,
        lightState = lightState,
        filterState = filterState,
        fovState = fovState,
        applyFog = applyFog,
        removeFog = removeFog,
        applyLight = applyLight,
        removeLight = removeLight,
        applyFilter = applyFilter,
        removeFilter = removeFilter,
        applyFOV = applyFOV,
        removeFOV = removeFOV,
        turnAllOn = turnAllOn,
        disableAll = disableAll,
        Orig = Orig,
        OrigAtmo = OrigAtmo,
    }
end)()

getgenv().WorldVisual = WorldVisual

-- ═══════════════════════════════════════════════════════════
--  ESP 功能模块（固定宽高比版，任何角度都不会变扁）
-- ═══════════════════════════════════════════════════════════
local ESP = (function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")
    local LocalPlayer = Players.LocalPlayer

    local V2  = Vector2.new
    local U2  = UDim2.new
    local RGB = Color3.fromRGB

    local FONT_BASE  = 11
    local BOX_PAD    = 1.06
    -- ★ 固定宽高比：宽 = 高 × RATIO
    --   0.55 ≈ 人物正常体型
    local BOX_RATIO  = 0.55
    -- ★ 从投影宽 / 高反推的容差（超过则用固定比例兜底）
    local MIN_RATIO  = 0.35   -- 低于此值 → 视为过窄，改用固定比例
    local MAX_RATIO  = 0.95   -- 高于此值 → 视为过宽，改用固定比例

    local function getCam()
        return workspace.CurrentCamera
    end

    local guiParent
    pcall(function() guiParent = gethui() end)
    if not guiParent then pcall(function() guiParent = game:GetService("CoreGui") end) end
    if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

    local fonts = {}; do
        local ok = pcall(function()
            local function RegFont(Name, Weight, Style, Asset)
                if not isfile(Asset.Id) then writefile(Asset.Id, Asset.Font) end
                if isfile(Name .. ".font") then delfile(Name .. ".font") end
                writefile(Name .. ".font", HttpService:JSONEncode({
                    name  = Name,
                    faces = {{ name = "Normal", weight = Weight, style = Style, assetId = getcustomasset(Asset.Id) }},
                }))
                return getcustomasset(Name .. ".font")
            end
            local f = RegFont("tahoma_bold_v1!", 700, "Normal", {
                Id   = "tahoma_bold_v1.ttf",
                Font = game:HttpGet("https://raw.githubusercontent.com/DFTBBO/tff/main/tahoma_bold.ttf"),
            })
            fonts = { main = Font.new(f, Enum.FontWeight.Regular, Enum.FontStyle.Normal) }
        end)
        if not ok then
            fonts = { main = Font.new("rbxasset://fonts/families/SourceSansPro.json") }
        end
    end

    local flags = {
        Enabled = false,
        Names = true, Boxes = true, Box_Type = "Normal",
        Healthbar = true, Distance = true, Weapon = true,
        Scale = 1, FontScale = 1,
    }

    local esp = { players = {}, flags = flags }
    esp.player_status = {}
    esp.status_colors = { None=RGB(255,255,255), Blacklist=RGB(255,0,0), Whitelist=RGB(0,255,0) }
    esp.show_only_blacklist = false
    esp.show_only_whitelist = false

    esp.screen = Instance.new("ScreenGui")
    esp.screen.Name = "ESP_Display"
    esp.screen.IgnoreGuiInset = true
    esp.screen.ResetOnSpawn = false
    esp.screen.DisplayOrder = -1
    esp.screen.Parent = guiParent

    esp.cache = Instance.new("ScreenGui")
    esp.cache.Name = "ESP_Cache"
    esp.cache.Enabled = false
    esp.cache.ResetOnSpawn = false
    esp.cache.Parent = guiParent

    local function mk(c, p)
        local o = Instance.new(c)
        for k, v in pairs(p) do o[k] = v end
        return o
    end

    local function getBaseFontSize()
        local s = flags.FontScale
        if type(s) ~= "number" or s ~= s or s <= 0 then s = 1 end
        return math.max(6, FONT_BASE * s)
    end

    function esp:setFontScale(scale)
        if type(scale) ~= "number" or scale ~= scale or scale <= 0 then return end
        self.flags.FontScale = scale
    end

    -----------------------------------------------------------
    -- ★★★ 稳定 box（任何角度都不会变扁）
    --   1. 世界 AABB → 8 角投影得到屏幕 Y 范围 → 高度
    --   2. 宽度 = 高度 × 固定比例（0.55）
    --   3. 只有当投影宽 / 高比例在 [0.35, 0.95] 之间才用投影宽
    --      （避免人物横向展开时 box 过宽，或斜角时 box 过窄）
    -----------------------------------------------------------
    function esp:box(char, data)
        if not char then return nil end
        local cam = getCam()
        if not cam then return nil end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return nil end

        -- 部件缓存
        if not data.parts or data.cachedChar ~= char then
            data.cachedChar = char
            data.parts = {}
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart")
                   and not p:FindFirstAncestorOfClass("Accessory")
                   and not p:FindFirstAncestorOfClass("Tool") then
                    table.insert(data.parts, p)
                end
            end
        end

        -- 世界 AABB
        local minX, minY, minZ =  math.huge,  math.huge,  math.huge
        local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
        local valid = false

        for _, part in ipairs(data.parts) do
            if part.Parent then
                valid = true
                local pos  = part.Position
                local half = part.Size * 0.5
                if pos.X - half.X < minX then minX = pos.X - half.X end
                if pos.Y - half.Y < minY then minY = pos.Y - half.Y end
                if pos.Z - half.Z < minZ then minZ = pos.Z - half.Z end
                if pos.X + half.X > maxX then maxX = pos.X + half.X end
                if pos.Y + half.Y > maxY then maxY = pos.Y + half.Y end
                if pos.Z + half.Z > maxZ then maxZ = pos.Z + half.Z end
            end
        end

        if not valid then return nil end

        -- 8 角投影
        local camPos = cam.CFrame.Position
        local minSX, minSY =  math.huge,  math.huge
        local maxSX, maxSY = -math.huge, -math.huge
        local projected = 0

        for xi = 0, 1 do
            for yi = 0, 1 do
                for zi = 0, 1 do
                    local corner = Vector3.new(
                        xi == 0 and minX or maxX,
                        yi == 0 and minY or maxY,
                        zi == 0 and minZ or maxZ
                    )
                    local sp, on = cam:WorldToViewportPoint(corner)
                    if on and sp.Z > 0 then
                        projected = projected + 1
                        if sp.X < minSX then minSX = sp.X end
                        if sp.X > maxSX then maxSX = sp.X end
                        if sp.Y < minSY then minSY = sp.Y end
                        if sp.Y > maxSY then maxSY = sp.Y end
                    end
                end
            end
        end

        if projected < 2 then return nil end

        local projW = math.max(maxSX - minSX, 1)
        local projH = math.max(maxSY - minSY, 1)

        -- ★ 高度以投影高为准
        local h = projH

        -- ★ 宽度默认按固定比例
        local w = h * BOX_RATIO

        -- ★ 如果投影宽 / 高在合理范围，则允许采用真实投影宽
        local ratio = projW / projH
        if ratio >= MIN_RATIO and ratio <= MAX_RATIO then
            -- 投影宽合理 → 取"固定比例"和"投影宽"的中间值，更贴合
            w = (w + projW) * 0.5
        end

        -- 加 6% padding
        w = w * BOX_PAD
        h = h * BOX_PAD

        -- 用户缩放
        local scale = (self.flags and self.flags.Scale) or 1
        if type(scale) ~= "number" or scale <= 0 then scale = 1 end
        w = math.max(4, w * scale)
        h = math.max(4, h * scale)

        -- 居中
        local cx = (minSX + maxSX) * 0.5
        local cy = (minSY + maxSY) * 0.5
        local posX = math.floor(cx - w * 0.5)
        local posY = math.floor(cy - h * 0.5)

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local dist = hrp and (hrp.Position - camPos).Magnitude or 0

        local vs = cam.ViewportSize
        local M = 200
        local vis = (posX + w > -M) and (posX < vs.X + M)
                and (posY + h > -M) and (posY < vs.Y + M)
                and dist > 0.5

        return Vector2.new(math.floor(w), math.floor(h)),
               Vector2.new(posX, posY),
               vis, dist
    end

    -----------------------------------------------------------
    -- UI 构建
    -----------------------------------------------------------
    local function build(player)
        local holder = mk("Frame", {
            Parent = esp.cache, BackgroundTransparency = 1,
            Position = U2(0,0,0,0), Size = U2(0,0,0,0),
            BorderSizePixel = 0, Visible = false,
        })

        local name = mk("TextLabel", {
            Parent = holder, FontFace = fonts.main,
            TextColor3 = RGB(255,255,255), TextStrokeColor3 = RGB(0,0,0),
            Text = string.format("%s (@%s)", player.DisplayName, player.Name),
            TextStrokeTransparency = 0, AnchorPoint = V2(0,1),
            Size = U2(1,0,0,0), BackgroundTransparency = 1,
            Position = U2(0,0,0,-5), BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y, TextSize = 11,
        })

        local boxH = mk("Frame", {
            Parent = esp.cache, BackgroundTransparency = 1,
            Position = U2(0,1,0,1), Size = U2(1,-2,1,-2), BorderSizePixel = 0,
        })
        mk("UIStroke", { Parent = boxH, Color = RGB(0,0,0), Thickness = 1 })

        local boxInner = mk("Frame", {
            Parent = boxH, BackgroundTransparency = 1,
            Position = U2(0,1,0,1), Size = U2(1,-2,1,-2), BorderSizePixel = 0,
        })
        local boxS = mk("UIStroke", { Parent = boxInner, Color = RGB(255,255,255), Thickness = 1 })

        local corners = mk("Frame", {
            Parent = esp.cache, BackgroundTransparency = 1,
            Position = U2(0,-1,0,2), Size = U2(1,0,1,0), BorderSizePixel = 0,
        })
        local cDefs = {
            {U2(0,0,0,-2),U2(0.4,0,0,3),V2(0,0)}, {U2(0,0,0,1),U2(0,3,0.25,0),V2(0,0)},
            {U2(1,0,0,-2),U2(0.4,0,0,3),V2(1,0)}, {U2(1,0,0,1),U2(0,3,0.25,0),V2(1,0)},
            {U2(0,0,1,-2),U2(0.4,0,0,3),V2(0,1)}, {U2(0,0,1,-5),U2(0,3,0.25,0),V2(0,1)},
            {U2(1,0,1,-2),U2(0.4,0,0,3),V2(1,1)}, {U2(1,0,1,-5),U2(0,3,0.25,0),V2(1,1)},
        }
        local cInners = {}
        for _, d in ipairs(cDefs) do
            local outer = mk("Frame", {
                Parent = corners, Position = d[1], Size = d[2], AnchorPoint = d[3],
                BackgroundColor3 = RGB(0,0,0), BorderSizePixel = 0,
            })
            local inner = mk("Frame", {
                Parent = outer, Position = U2(0,1,0,1),
                Size = U2(1,-2,1,-2), BorderSizePixel = 0,
                BackgroundColor3 = RGB(255,255,255),
            })
            table.insert(cInners, inner)
        end

        local hbH = mk("Frame", {
            Parent = esp.cache, AnchorPoint = V2(1,0),
            Position = U2(0,-5,0,-1), Size = U2(0,4,1,2),
            BorderSizePixel = 0, BackgroundColor3 = RGB(0,0,0),
        })
        local hb = mk("Frame", {
            Parent = hbH, Position = U2(0,1,0,1), Size = U2(1,-2,1,-2),
            BorderSizePixel = 0, BackgroundColor3 = RGB(255,255,255),
        })

        local dist = mk("TextLabel", {
            Parent = holder, FontFace = fonts.main,
            TextColor3 = RGB(255,255,255), TextStrokeColor3 = RGB(0,0,0),
            Text = "0st", TextStrokeTransparency = 0,
            Size = U2(1,0,0,0), BackgroundTransparency = 1,
            Position = U2(0,0,1,5), BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y, TextSize = 11,
        })

        local wpn = mk("TextLabel", {
            Parent = esp.cache, FontFace = fonts.main,
            TextColor3 = RGB(255,255,255), TextStrokeColor3 = RGB(0,0,0),
            Text = "[--]", TextStrokeTransparency = 0,
            Size = U2(1,0,0,0), BackgroundTransparency = 1,
            Position = U2(0,0,1,19), BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y, TextSize = 11,
        })

        return {
            holder=holder, name=name, boxH=boxH, boxS=boxS,
            corners=corners, cInners=cInners,
            hbH=hbH, hb=hb, dist=dist, wpn=wpn,
        }
    end

    function esp:getColor(n)
        local s = esp.player_status[n] or "None"
        return esp.status_colors[s] or esp.status_colors.None
    end

    function esp:shouldShow(name)
        local status = esp.player_status[name] or "None"
        local onlyBL = esp.show_only_blacklist
        local onlyWL = esp.show_only_whitelist
        if not onlyBL and not onlyWL then return true end
        if onlyBL and not onlyWL then return status == "Blacklist" end
        if onlyWL and not onlyBL then return status == "Whitelist" end
        return status == "Blacklist" or status == "Whitelist"
    end

    function esp:updateVisual(n)
        local d = esp.players[n]
        if not d then return end
        local c = esp:getColor(n)
        local o = d.objects
        o.name.TextColor3 = c
        o.boxS.Color = c
        o.dist.TextColor3 = c
        o.wpn.TextColor3 = c
        o.hb.BackgroundColor3 = c
        for _, inner in ipairs(o.cInners) do
            inner.BackgroundColor3 = c
        end
    end

    function esp:updateAll()
        for n in pairs(esp.players) do
            pcall(function() esp:updateVisual(n) end)
        end
    end

    local function bindChar(player, data, char)
        local hum = char:WaitForChild("Humanoid", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if not hum or not root then return end
        data.humanoid = hum
        data.root = root
        data.character = char
        data.parts = nil
        data.cachedChar = nil

        local function updateHB()
            local maxHP = hum.MaxHealth
            if not maxHP or maxHP <= 0 then maxHP = 100 end
            local hp = hum.Health or 0
            local m = math.clamp(hp / maxHP, 0, 1)
            data.objects.hb.Size = U2(1, -2, m, -2)
            data.objects.hb.Position = U2(0, 1, 1 - m, 1)
        end

        pcall(updateHB)
        hum.HealthChanged:Connect(function() pcall(updateHB) end)
        hum:GetPropertyChangedSignal("MaxHealth"):Connect(function() pcall(updateHB) end)

        char.ChildAdded:Connect(function(i)
            if i:IsA("Tool") then data.objects.wpn.Text = i.Name end
        end)
        char.ChildRemoved:Connect(function(i)
            if i:IsA("Tool") then data.objects.wpn.Text = "[--]" end
        end)
        local t = char:FindFirstChildOfClass("Tool")
        if t then data.objects.wpn.Text = t.Name end

        esp:updateVisual(player.Name)
        pcall(function() esp:refresh() end)
    end

    function esp:create(player)
        if esp.players[player.Name] then return end
        local data = { objects = build(player), humanoid=nil, root=nil, character=nil }
        esp.players[player.Name] = data
        esp:updateVisual(player.Name)
        if player.Character then task.spawn(bindChar, player, data, player.Character) end

        player.CharacterAdded:Connect(function(c)
            data.humanoid, data.root, data.character = nil, nil, nil
            data.parts = nil
            data.cachedChar = nil
            task.spawn(bindChar, player, data, c)
            task.wait(0.5)
            pcall(function() esp:refresh() end)
            pcall(function() esp:updateVisual(player.Name) end)
        end)
    end

    function esp:remove(player)
        local d = esp.players[player.Name]
        if not d then return end
        pcall(function() d.objects.holder:Destroy() end)
        esp.players[player.Name] = nil
    end

    function esp:refresh()
        for _, v in ipairs(Players:GetPlayers()) do
            if v == LocalPlayer then continue end
            local d = esp.players[v.Name]
            if not d then continue end
            local o = d.objects
            local char = v.Character

            o.holder.Parent = flags.Enabled and esp.screen or esp.cache
            o.name.Parent = flags.Names and o.holder or esp.cache

            local isCorner = flags.Box_Type == "Corner"
            if flags.Boxes then
                o.corners.Parent = (isCorner and o.holder) or esp.cache
                o.boxH.Parent = (isCorner and esp.cache or o.holder)
            else
                o.corners.Parent = esp.cache
                o.boxH.Parent = esp.cache
            end

            o.hbH.Parent = flags.Healthbar and o.holder or esp.cache

            local hasTool = char and char:FindFirstChildOfClass("Tool")
            o.wpn.Parent = (flags.Weapon and hasTool) and o.holder or esp.cache
            o.dist.Parent = flags.Distance and o.holder or esp.cache

            esp:updateVisual(v.Name)
        end
    end

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        pcall(function() esp:refresh() end)
        pcall(function() esp:updateAll() end)
    end)

    local lastFont = {}
    local lastHB   = {}

    RunService.RenderStepped:Connect(function()
        if not flags.Enabled then return end

        local baseFont = getBaseFontSize()

        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            local d = esp.players[p.Name]
            if not d then continue end
            local o = d.objects
            if not o then continue end

            local hide = false
            if not esp:shouldShow(p.Name) then
                hide = true
            elseif not d.character or not d.root or not d.root.Parent then
                hide = true
            end
            if hide then
                if o.holder.Visible then o.holder.Visible = false end
                continue
            end

            local size, pos, vis, ds = esp:box(d.character, d)
            if not size then
                if o.holder.Visible then o.holder.Visible = false end
                continue
            end

            if vis then
                o.holder.Position = UDim2.fromOffset(pos.X, pos.Y)
                o.holder.Size = UDim2.fromOffset(size.X, size.Y)

                local txt = tostring(math.round(ds)) .. "st"
                if o.dist.Text ~= txt then o.dist.Text = txt end
                if not o.holder.Visible then o.holder.Visible = true end

                local targetFont = math.clamp(
                    math.floor(baseFont * (size.Y / 100) + 0.5),
                    6, 32
                )
                if (lastFont[p.Name] or 0) ~= targetFont then
                    lastFont[p.Name] = targetFont
                    o.name.TextSize = targetFont
                    o.dist.TextSize = targetFont
                    o.wpn.TextSize = targetFont
                    o.name.Position = UDim2.new(0, 0, 0, -(targetFont * 0.45))
                    o.dist.Position = UDim2.new(0, 0, 1, targetFont * 0.45)
                    o.wpn.Position = UDim2.new(0, 0, 1, targetFont * 1.75)
                end

                local targetHB = math.clamp(
                    math.floor(size.Y * 0.04 + 0.5),
                    4, 6
                )
                if (lastHB[p.Name] or 0) ~= targetHB then
                    lastHB[p.Name] = targetHB
                    o.hbH.Size = UDim2.new(0, targetHB, 1, 2)
                    o.hbH.Position = UDim2.new(0, -(targetHB + 1), 0, -1)
                end

                local showBox = flags.Boxes
                if o.boxH.Visible ~= showBox then o.boxH.Visible = showBox end
                if o.corners.Visible ~= showBox then o.corners.Visible = showBox end
            else
                if o.holder.Visible then o.holder.Visible = false end
            end
        end
    end)

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then esp:create(v) end
    end
    Players.PlayerAdded:Connect(function(v)
        esp:create(v)
        pcall(function() esp:refresh() end)
    end)
    Players.PlayerRemoving:Connect(function(v)
        esp:remove(v)
        esp.player_status[v.Name] = nil
        lastFont[v.Name] = nil
        lastHB[v.Name] = nil
    end)

    return esp
end)()

pcall(function() ESP:refresh() end)

-- ═══════════════════════════════════════════════════════════
--  Chams 功能
-- ═══════════════════════════════════════════════════════════
local Chams = (function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local guiParent
    pcall(function() guiParent = gethui() end)
    if not guiParent then pcall(function() guiParent = game:GetService("CoreGui") end) end
    if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

    local MAX_GLOW = 8

    local BODY_PARTS = {
        "Head", "UpperTorso", "LowerTorso", "Torso",
        "LeftUpperArm","LeftLowerArm","LeftHand",
        "RightUpperArm","RightLowerArm","RightHand",
        "Left Arm","Right Arm",
        "LeftUpperLeg","LeftLowerLeg","LeftFoot",
        "RightUpperLeg","RightLowerLeg","RightFoot",
        "Left Leg","Right Leg",
    }

    local EXCLUDE_NAMES = { ["Handle"]=true, ["Effect"]=true, ["Trail"]=true, ["Beam"]=true }

    local state = {
        enabled = false,
        outline = true, outlineCol = Color3.fromRGB(120,200,200), outlineAlpha = 0.50, outlineSize = 0.30,
        glow = true, glowLayers = 0.50, glowRange = 0.30, glowBright = 0.30,
        inline = true, inlineCol = Color3.fromRGB(0,0,0), inlineAlpha = 0.50, inlineSize = 0.20,
    }

    local playerCache = {}
    local adornList = {}
    local conns = { perPlayer = {}, added = nil, removed = nil }
    local scheduled = false
    local lastCheck = 0
    local snapshot = nil

    local function num(v, fb)
        if type(v) ~= "number" then return fb end
        if v ~= v then return fb end
        if v == math.huge or v == -math.huge then return fb end
        return v
    end

    local function clamp01(v)
        v = num(v, 0)
        if v < 0 then return 0 end
        if v > 1 then return 1 end
        return v
    end

    local function buildSnapshot()
        local snap = {
            outline = state.outline,
            outlineCol = state.outlineCol,
            outlineAlpha = clamp01(state.outlineAlpha),
            outlineSize = clamp01(state.outlineSize),
            glow = state.glow,
            glowLayers = math.floor(clamp01(state.glowLayers) * MAX_GLOW + 0.5),
            glowRange = clamp01(state.glowRange),
            glowBright = clamp01(state.glowBright),
            inline = state.inline,
            inlineCol = state.inlineCol,
            inlineAlpha = clamp01(state.inlineAlpha),
            inlineSize = clamp01(state.inlineSize),
        }

        snap.glowCurves = {}
        local baseCol = snap.outlineCol
        if snap.glowLayers > 0 then
            for i = 1, snap.glowLayers do
                local t = i / snap.glowLayers
                local curve = math.sin(t * math.pi * 0.5)
                local boost = 1 + t * 0.35
                snap.glowCurves[i] = {
                    alpha = snap.outlineAlpha + (snap.glowBright - snap.outlineAlpha) * curve,
                    size = snap.outlineSize + snap.glowRange * t,
                    color = Color3.new(
                        math.min(baseCol.R * boost, 1),
                        math.min(baseCol.G * boost, 1),
                        math.min(baseCol.B * boost, 1)
                    ),
                }
            end
        end
        return snap
    end

    local function getSnapshot()
        if not snapshot then snapshot = buildSnapshot() end
        return snapshot
    end

    local function getStatus(name)
        local esp
        local ok1, e1 = pcall(function() return ESP end)
        if ok1 and e1 and e1.player_status then esp = e1
        else
            local env = getgenv()
            if env and env.ESP and env.ESP.player_status then esp = env.ESP end
        end
        if not esp then return "None" end
        return esp.player_status[name] or "None"
    end

    local function passesFilter(name)
        local esp
        local ok1, e1 = pcall(function() return ESP end)
        if ok1 and e1 then esp = e1
        else
            local env = getgenv()
            if env and env.ESP then esp = env.ESP end
        end
        if not esp then return true end

        local onlyBL = esp.show_only_blacklist
        local onlyWL = esp.show_only_whitelist
        if not onlyBL and not onlyWL then return true end

        local st = getStatus(name)
        if onlyBL and not onlyWL then return st == "Blacklist" end
        if onlyWL and not onlyBL then return st == "Whitelist" end
        return st == "Blacklist" or st == "Whitelist"
    end

    local function safeDestroy(x) if x then pcall(function() x:Destroy() end) end end

    local function calcSize(pSize, pad)
        pad = num(pad, 0)
        if pad < 0 then pad = 0 end
        return Vector3.new(
            math.max(pSize.X + pad, 0.05),
            math.max(pSize.Y + pad, 0.05),
            math.max(pSize.Z + pad, 0.05)
        )
    end

    local function makeAdorn(part, z, name)
        local a = Instance.new("BoxHandleAdornment")
        a.Adornee = part
        a.AlwaysOnTop = true
        a.ZIndex = z
        a.Color3 = Color3.new(1,1,1)
        a.Transparency = 1
        a.Size = part.Size
        a.Name = name
        a.Parent = guiParent
        return a
    end

    local function isBodyPart(obj, char)
        if not obj or not obj:IsA("BasePart") then return false end
        if EXCLUDE_NAMES[obj.Name] then return false end
        local parent = obj.Parent
        while parent and parent ~= char do
            if parent:IsA("Accessory") or parent:IsA("Tool") or parent:IsA("Handles") then
                return false
            end
            parent = parent.Parent
        end
        return true
    end

    local function collectParts(char)
        local seen, out = {}, {}
        for _, pn in ipairs(BODY_PARTS) do
            local obj = char:FindFirstChild(pn)
            if obj and obj:IsA("BasePart") and not seen[obj] then
                seen[obj] = true
                table.insert(out, obj)
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if not seen[obj] and isBodyPart(obj, char) then
                seen[obj] = true
                table.insert(out, obj)
            end
        end
        return out
    end

    local function rebuildAdornList()
        adornList = {}
        for _, rec in pairs(playerCache) do
            for part, data in pairs(rec.parts) do
                if data.core and data.core.Parent then
                    table.insert(adornList, { data.core, part, "core", 0 })
                end
                for i, g in ipairs(data.glows) do
                    if g and g.Parent then
                        table.insert(adornList, { g, part, "glow", i })
                    end
                end
                if data.inline and data.inline.Parent then
                    table.insert(adornList, { data.inline, part, "inline", 0 })
                end
            end
        end
    end

    local function applyOne(adorn, part, kind, layer, snap)
        if not adorn or not adorn.Parent then return end
        if not part or not part.Parent then return end
        local pSize = part.Size

        if kind == "core" then
            if snap.outline then
                adorn.Color3 = snap.outlineCol
                adorn.Transparency = snap.outlineAlpha
                adorn.Size = calcSize(pSize, snap.outlineSize)
            else
                adorn.Transparency = 1
            end
        elseif kind == "glow" then
            if snap.glow and snap.outline and layer <= snap.glowLayers then
                local c = snap.glowCurves[layer]
                if c then
                    adorn.Color3 = c.color
                    adorn.Transparency = math.clamp(c.alpha, 0, 1)
                    adorn.Size = calcSize(pSize, c.size)
                else
                    adorn.Transparency = 1
                end
            else
                adorn.Transparency = 1
            end
        elseif kind == "inline" then
            if snap.inline then
                adorn.Color3 = snap.inlineCol
                adorn.Transparency = snap.inlineAlpha
                adorn.Size = calcSize(pSize, snap.inlineSize)
            else
                adorn.Transparency = 1
            end
        end
    end

    local function flushProperties()
        if not state.enabled then return end
        local snap = getSnapshot()
        local n = #adornList
        pcall(function()
            for i = 1, n do
                local e = adornList[i]
                applyOne(e[1], e[2], e[3], e[4], snap)
            end
        end)
    end

    local function schedule()
        if scheduled then return end
        scheduled = true
        task.spawn(function()
            scheduled = false
            if state.enabled then flushProperties() end
        end)
    end

    local function clearPlayer(p)
        local rec = playerCache[p]
        if not rec then return end
        for _, data in pairs(rec.parts) do
            safeDestroy(data.core)
            for _, g in ipairs(data.glows) do safeDestroy(g) end
            safeDestroy(data.inline)
        end
        playerCache[p] = nil
        rebuildAdornList()
    end

    local function buildPlayer(p, char)
        clearPlayer(p)
        if not char then return end
        local rec = { char = char, parts = {} }
        for _, obj in ipairs(collectParts(char)) do
            local data = { core = nil, glows = {}, inline = nil }
            data.core = makeAdorn(obj, -1, "core")
            for i = 1, MAX_GLOW do
                data.glows[i] = makeAdorn(obj, -2 - i, "glow"..i)
            end
            data.inline = makeAdorn(obj, 1, "inline")
            rec.parts[obj] = data
        end
        playerCache[p] = rec
        rebuildAdornList()
        flushProperties()
    end

    local function ensurePlayer(p)
        if p == LocalPlayer then return end
        if not passesFilter(p.Name) then
            clearPlayer(p)
            return
        end
        local char = p.Character
        if not char or not char:FindFirstChildOfClass("Humanoid") then
            clearPlayer(p)
            return
        end
        local rec = playerCache[p]
        if not rec or rec.char ~= char then
            pcall(buildPlayer, p, char)
        end
    end

    local api = {}
    api.state = state

    function api.touch()
        snapshot = nil
        schedule()
    end

    function api.enable()
        state.enabled = true
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if conns.perPlayer[p] then
                    pcall(function() conns.perPlayer[p]:Disconnect() end)
                end
                conns.perPlayer[p] = p.CharacterAdded:Connect(function()
                    task.wait(1)
                    pcall(ensurePlayer, p)
                end)
                pcall(ensurePlayer, p)
            end
        end
        conns.added = Players.PlayerAdded:Connect(function(p)
            if p == LocalPlayer then return end
            if conns.perPlayer[p] then
                pcall(function() conns.perPlayer[p]:Disconnect() end)
            end
            conns.perPlayer[p] = p.CharacterAdded:Connect(function()
                task.wait(1)
                pcall(ensurePlayer, p)
            end)
            if p.Character then pcall(ensurePlayer, p) end
        end)
        conns.removed = Players.PlayerRemoving:Connect(function(p)
            if conns.perPlayer[p] then
                pcall(function() conns.perPlayer[p]:Disconnect() end)
                conns.perPlayer[p] = nil
            end
            clearPlayer(p)
        end)
        flushProperties()
    end

    function api.disable()
        state.enabled = false
        for _, c in pairs(conns.perPlayer) do pcall(function() c:Disconnect() end) end
        conns.perPlayer = {}
        if conns.added then pcall(function() conns.added:Disconnect() end); conns.added = nil end
        if conns.removed then pcall(function() conns.removed:Disconnect() end); conns.removed = nil end
        for p in pairs(playerCache) do clearPlayer(p) end
        playerCache = {}
        adornList = {}
    end

    function api.rebuildAll()
        if not state.enabled then return end
        for p in pairs(playerCache) do
            if not p.Character or not p.Character:FindFirstChildOfClass("Humanoid") then
                clearPlayer(p)
            end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then pcall(ensurePlayer, p) end
        end
        rebuildAdornList()
        flushProperties()
    end

    function api.refreshFilter()
        if not state.enabled then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then pcall(ensurePlayer, p) end
        end
    end

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if state.enabled then pcall(function() api.rebuildAll() end) end
    end)

    RunService.Heartbeat:Connect(function()
        if not state.enabled then
            scheduled = false
            return
        end
        local now = tick()
        if now - lastCheck < 0.5 then return end
        lastCheck = now

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if not passesFilter(p.Name) then
                    clearPlayer(p)
                else
                    local rec = playerCache[p]
                    local char = p.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        local need = (not rec) or (rec.char ~= char)
                        if need then
                            pcall(ensurePlayer, p)
                        else
                            local alive = false
                            for _, data in pairs(rec.parts) do
                                if data.core and data.core.Parent then alive = true; break end
                            end
                            if not alive then pcall(ensurePlayer, p) end
                        end
                    else
                        clearPlayer(p)
                    end
                end
            end
        end
    end)

    return api
end)()

getgenv().Chams = Chams

-- ═══════════════════════════════════════════════════════════
--  【功能 · 共享变量】Bridge
-- ═══════════════════════════════════════════════════════════
local Bridge = { SelectedPlayer = "" }

-- ═══════════════════════════════════════════════════════════
--  Module 2: Movement
--    * Speed / Jump via sliders
--    * Never freezes the character: original values are
--      snapshotted with sanitization (never 0, never NaN),
--      and restored exactly when you disable.
--    * Defaults: WalkSpeed 32, JumpPower 75
-- ═══════════════════════════════════════════════════════════
local Movement = (function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    -- Safe defaults used only when the current value is unusable
    local DEFAULT_SPEED = 32
    local DEFAULT_JUMP  = 75
    local DEFAULT_JH    = 7.35

    local mod = {
        SpeedEnabled = false, SpeedValue = DEFAULT_SPEED,
        JumpEnabled  = false, JumpValue  = DEFAULT_JUMP,
    }

    local currentHumanoid = nil
    local savedSpeed = nil                 -- number
    local savedJump  = nil                 -- { JumpPower, JumpHeight, UseJumpPower }

    local function isNumber(v)
        return type(v) == "number" and v == v   -- reject NaN
    end

    local function sanitize(v, fallback)
        if not isNumber(v) or v <= 0 then return fallback end
        return v
    end

    local function getHumanoid()
        if currentHumanoid and currentHumanoid.Parent then return currentHumanoid end
        local char = LocalPlayer.Character
        if not char then return nil end
        local hum = char:FindFirstChildOfClass("Humanoid")
        currentHumanoid = hum
        return hum
    end

    -- Snapshot the ORIGINAL values (only once per enable-cycle)
    local function captureSpeed(hum)
        if savedSpeed ~= nil then return end
        if not hum or hum.Health <= 0 then return end
        savedSpeed = sanitize(hum.WalkSpeed, DEFAULT_SPEED)
    end

    local function captureJump(hum)
        if savedJump ~= nil then return end
        if not hum or hum.Health <= 0 then return end
        savedJump = {
            JumpPower    = sanitize(hum.JumpPower,  DEFAULT_JUMP),
            JumpHeight   = sanitize(hum.JumpHeight, DEFAULT_JH),
            UseJumpPower = hum.UseJumpPower,
        }
    end

    -- Apply current modifier values
    local function applySpeed(hum)
        if not hum or hum.Health <= 0 then return end
        local target = mod.SpeedValue
        if target < 1 then target = 1 end        -- never 0
        if hum.WalkSpeed ~= target then hum.WalkSpeed = target end
    end

    local function applyJump(hum)
        if not hum or hum.Health <= 0 then return end
        if not hum.UseJumpPower then hum.UseJumpPower = true end
        local target = mod.JumpValue
        if target < 1 then target = 1 end        -- never 0
        if hum.JumpPower ~= target then hum.JumpPower = target end
    end

    local function sync()
        local hum = getHumanoid()
        if not hum or hum.Health <= 0 then return end
        if mod.SpeedEnabled then applySpeed(hum) end
        if mod.JumpEnabled  then applyJump(hum)  end
    end

    -- IMPORTANT: no side effect when both are off
    RunService.Stepped:Connect(function()
        if mod.SpeedEnabled or mod.JumpEnabled then sync() end
    end)
    RunService.Heartbeat:Connect(function()
        if mod.SpeedEnabled or mod.JumpEnabled then sync() end
    end)

    local function bindCharacter(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then return end
        currentHumanoid = hum
        -- New life -> discard old snapshots so we capture fresh values
        savedSpeed = nil
        savedJump  = nil
        if mod.SpeedEnabled or mod.JumpEnabled then
            if mod.SpeedEnabled then captureSpeed(hum); applySpeed(hum) end
            if mod.JumpEnabled  then captureJump(hum);  applyJump(hum)  end
        end
    end

    if LocalPlayer.Character then task.spawn(bindCharacter, LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(function(char)
        currentHumanoid = nil
        task.spawn(bindCharacter, char)
    end)

    -- Public API ---------------------------------------------------
    function mod:SetSpeedEnabled(state)
        self.SpeedEnabled = state and true or false
        local hum = getHumanoid()

        if self.SpeedEnabled then
            captureSpeed(hum)
            applySpeed(hum)
        else
            -- restore the ORIGINAL WalkSpeed (only if we changed it)
            if hum and savedSpeed ~= nil then
                hum.WalkSpeed = savedSpeed
            end
            savedSpeed = nil
        end
    end

    function mod:SetSpeedValue(v)
        if not isNumber(v) then return end
        if v < 1 then v = 1 end
        self.SpeedValue = v
        if self.SpeedEnabled then applySpeed(getHumanoid()) end
    end

    function mod:SetJumpEnabled(state)
        self.JumpEnabled = state and true or false
        local hum = getHumanoid()

        if self.JumpEnabled then
            captureJump(hum)
            applyJump(hum)
        else
            if hum and savedJump ~= nil then
                hum.UseJumpPower = savedJump.UseJumpPower
                if savedJump.UseJumpPower then
                    hum.JumpPower  = savedJump.JumpPower
                else
                    hum.JumpHeight = savedJump.JumpHeight
                end
            end
            savedJump = nil
        end
    end

    function mod:SetJumpValue(v)
        if not isNumber(v) then return end
        if v < 1 then v = 1 end
        self.JumpValue = v
        if self.JumpEnabled then applyJump(getHumanoid()) end
    end

    return mod
end)()

-- ═══════════════════════════════════════════════════════════
--  Infinite Stamina 功能模块
--   ★ 优先 hookfunction（hook _G.S_Take）
--   ★ 失败则 fallback：每帧把 S=100 的表全部刷一遍
--   ★ 全程 pcall 保护，不会报错
--   ★ 换角色 / 重生自动重新绑定
-- ═══════════════════════════════════════════════════════════
local InfiniteStamina = (function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local state = {
        Enabled = false,
        Conn    = nil,
        Hooked  = false,
    }

    local tbls = {}
    local lastCollect = 0

    local function safeGetUpvalue()
        local ok = pcall(function()
            local tgt = getupvalue(getrenv()._G.S_Take, 2)
            if not tgt or type(tgt) ~= "function" then
                error("invalid S_Take")
            end
            local old
            old = hookfunction(tgt, function(v1, ...)
                if state.Enabled then v1 = 0 end
                return old(v1, ...)
            end)
            state.Hooked = true
        end)
        return ok
    end

    local function collectTables()
        tbls = {}
        pcall(function()
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "S") then
                    tbls[#tbls + 1] = v
                end
            end
        end)
    end

    local function startFallback()
        collectTables()
        if state.Conn then
            pcall(function() state.Conn:Disconnect() end)
            state.Conn = nil
        end
        state.Conn = RunService.RenderStepped:Connect(function()
            if not state.Enabled then return end
            pcall(function()
                local now = tick()
                if now - lastCollect > 5 then
                    lastCollect = now
                    collectTables()
                end
                for _, t in ipairs(tbls) do
                    pcall(function() t.S = 100 end)
                end
                local c = LocalPlayer.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h then h:SetAttribute("ZSPRN_M", true) end
            end)
        end)
    end

    local function enable()
        if state.Enabled then return end
        state.Enabled = true

        local ok = safeGetUpvalue()
        if not ok then
            startFallback()
        end
    end

    local function disable()
        if not state.Enabled then return end
        state.Enabled = false

        if state.Conn then
            pcall(function() state.Conn:Disconnect() end)
            state.Conn = nil
        end

        pcall(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then h:SetAttribute("ZSPRN_M", nil) end
        end)
    end

    -- 角色重生：如果开启中，重新走一遍启用流程
    LocalPlayer.CharacterAdded:Connect(function()
        if state.Enabled then
            task.wait(0.5)
            pcall(function()
                if not state.Hooked then
                    startFallback()
                end
            end)
        end
    end)

    return {
        SetEnabled = function(v)
            v = v and true or false
            if v then enable() else disable() end
        end,
        IsEnabled = function() return state.Enabled end,
        Toggle = function(v)
            if v == nil then v = not state.Enabled end
            if v then enable() else disable() end
            return state.Enabled
        end,
    }
end)()

getgenv().InfiniteStamina = InfiniteStamina

-- ============================================================
-- == Ragebot 功能（Lock = ESP.player_status 里的 Blacklist）
-- ============================================================
do
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local Workspace   = game:GetService("Workspace")
    local RepStorage  = game:GetService("ReplicatedStorage")
    local UIS         = game:GetService("UserInputService")
    local Debris      = game:GetService("Debris")
    local LocalPlayer = Players.LocalPlayer

    local GN_S = RepStorage.Events.GNX_S
    local ZF_H = RepStorage.Events.ZFKLF__H

    RB_State, RF_State, DownCheck = false, false, false
    Debug_Rays, HitSoundSelection = false, "None"
    TargetMode = "Nearby"     -- ★ Nearby / Lock（Lock = 打 ESP 黑名单）

    Origin_Radius, Hit_Radius = 18.50, 23.50
    Origin_Scans, Hit_Scans = 24, 24
    ScanRate = 14
    Last_Shot, Valid_Pair, Locked_Path = 0, nil, nil
    WB = {LastScan=0, Cached=false, Toggle=false, Threshold=0.5, Round=0}
    Selected_HitParts = {"Head", "HumanoidRootPart"}
    CustomMuzzleSound_State = false
    CustomMuzzleFlash_State = false

    TR = {Enabled=false, Size=1, Color=Color3.fromRGB(255,255,255), Alpha=0, Texture="Taser"}
    DS = DS or {AppliedOffset = Vector3.zero}

    HitSounds = {
        ["Rust"]="rbxassetid://5043539486", ["CODE200"]="rbxassetid://98545664405431",
        ["Minecraft"]="rbxassetid://7151570575", ["Neverlose"]="rbxassetid://6607204501",
        ["Gamesense"]="rbxassetid://5633695679", ["Bonk"]="rbxassetid://3765689841",
        ["Bat"]="rbxassetid://3333907347", ["Laser Beam"]="rbxassetid://130791043",
        ["Fatality"]="rbxassetid://6607142036", ["Bow"]="rbxassetid://93158957747276",
        ["koch"]="rbxassetid://126832876895392", ["golda"]="rbxassetid://72129857868180",
        ["agpa1"]="rbxassetid://136193374775854", ["agpa2"]="rbxassetid://104673402060812",
        ["Bameware"]="rbxassetid://3124331820", ["Bell"]="rbxassetid://6534947240",
        ["Bubble"]="rbxassetid://6534947588", ["Pick"]="rbxassetid://1347140027",
        ["Pop"]="rbxassetid://198598793", ["Sans"]="rbxassetid://3188795283",
        ["Fart"]="rbxassetid://130833677", ["Big"]="rbxassetid://5332005053",
        ["Vine"]="rbxassetid://5332680810", ["Bruh"]="rbxassetid://4578740568",
        ["Skeet"]="rbxassetid://5633695679",
    }

    local function GetLocalRealPosition()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return Vector3.zero end
        return hrp.Position - DS.AppliedOffset
    end

    -- FPS 优化：raycast 预算
    local RC_BUDGET = 40
    local rcUsed = 0

    local function VisualizeRay(o, t, col)
        if not Debug_Rays then return end
        local d=(t-o).Magnitude; if d<0.1 then return end
        local rp=Instance.new("Part"); rp.Anchored=true; rp.CanCollide=false; rp.Material=Enum.Material.Neon; rp.Color=col
        rp.Size=Vector3.new(0.05,0.05,d); rp.CFrame=CFrame.lookAt(o,t)*CFrame.new(0,0,-d/2); rp.Parent=Workspace; Debris:AddItem(rp,1)
    end

    local function CheckWallbang(p1, p2)
        if rcUsed >= RC_BUDGET then return false end
        rcUsed = rcUsed + 1
        local Camera = Workspace.CurrentCamera
        if not Camera then return false end
        local params=RaycastParams.new()
        params.FilterDescendantsInstances={LocalPlayer.Character, Camera}
        params.FilterType=Enum.RaycastFilterType.Exclude
        local d=(p2-p1).Magnitude
        local r=Workspace:Raycast(p1,(p2-p1).Unit*d,params)
        local ok=not r or (r.Position-p2).Magnitude<=24
        if Debug_Rays then VisualizeRay(p1, ok and p2 or (r and r.Position or p2), ok and Color3.new(0,1,0) or Color3.new(1,0,0)) end
        return ok
    end

    -- FPS 优化：目标缓存
    local cachedTarget = nil
    local cacheTick = 0
    local TARGET_TTL = 0.08

    local function GetTargetRaw()
        local Camera = Workspace.CurrentCamera
        if not Camera then return nil end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end

        local ESPref = ESP
        if not ESPref then
            local ok, g = pcall(function() return getgenv() end)
            if ok and g then ESPref = g.ESP end
        end
        local statuses = (ESPref and ESPref.player_status) or {}

        local best, metric = nil, math.huge
        local myPos = GetLocalRealPosition()

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local status = statuses[p.Name] or "None"

                -- ★ Target Mode 分支
                if TargetMode == "Lock" then
                    -- ★ Lock：只打 ESP 里标记为 Blacklist 的玩家
                    if status ~= "Blacklist" then continue end
                else
                    -- ★ Nearby：打最近的人（白名单永远跳过）
                    if status == "Whitelist" then continue end
                end

                local pr = p.Character:FindFirstChild("HumanoidRootPart")
                local ph = p.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and ph.Health > (DownCheck and 15 or 0)
                   and not p.Character:FindFirstChildOfClass("ForceField") then
                    local d = (myPos - pr.Position).Magnitude
                    if d < metric then metric = d; best = p end
                end
            end
        end
        return best
    end

    local function GetTarget()
        local now = tick()
        if cachedTarget and (now - cacheTick) < TARGET_TTL then
            local ch = cachedTarget.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                return cachedTarget
            end
        end
        cachedTarget = GetTargetRaw()
        cacheTick = now
        return cachedTarget
    end

    local TTexs = {
        ["Obelus"]   ={Tex="rbxassetid://2382169232", Len=5, Spd=0, Mode="Stretch", Segs=1, W0=0.3, W1=0.3},
        ["Lightning"]={Tex="rbxassetid://7151778302", Len=1, Spd=1, Mode="Stretch", Segs=10,W0=1.2, W1=1.2},
        ["DNA"]      ={Tex="rbxassetid://7071778278", Len=12,Spd=1, Mode="Wrap",    Segs=1, W0=0.6, W1=0.6},
        ["Straight"] ={Tex="rbxassetid://4595131819", Len=5, Spd=0, Mode="Stretch", Segs=1, W0=0.3, W1=0.3},
        ["Taser"]    ={Tex="rbxassetid://446111271",  Len=8, Spd=1, Mode="Stretch", Segs=6, W0=0.8, W1=0.8},
        ["Edge"]     ={Tex="rbxassetid://9149045341", Len=6, Spd=1, Mode="Stretch", Segs=1, W0=0.6, W1=0.6},
        ["Energy"]   ={Tex="rbxassetid://6091341618", Len=10,Spd=1, Mode="Wrap",    Segs=4, W0=0.9, W1=0.9},
    }

    local function CreateTracer(origin, dir)
        if not TR.Enabled then return end
        local t = TTexs[TR.Texture] or TTexs["Taser"]
        local a0 = Instance.new("Attachment", Workspace.Terrain); a0.Position = origin
        local a1 = Instance.new("Attachment", Workspace.Terrain); a1.Position = origin + dir.Unit*1000
        local beam = Instance.new("Beam", Workspace.Terrain)
        beam.Texture = t.Tex; beam.TextureLength = t.Len; beam.TextureSpeed = t.Spd
        beam.TextureMode = Enum.TextureMode[t.Mode] or Enum.TextureMode.Stretch
        beam.Segments = t.Segs
        beam.Width0 = t.W0 * (TR.Size or 1); beam.Width1 = t.W1 * (TR.Size or 1)
        beam.Color = ColorSequence.new(TR.Color)
        beam.Transparency = NumberSequence.new(TR.Alpha)
        beam.Attachment0, beam.Attachment1 = a0, a1
        beam.FaceCamera, beam.LightEmission = true, 1
        Debris:AddItem(a0,4); Debris:AddItem(a1,4); Debris:AddItem(beam,4)
    end

    local ScanVectors = {
        Vector3.new(1,0,0), Vector3.new(0,0,1), Vector3.new(0,1,0),
        -Vector3.new(1,0,0), -Vector3.new(0,0,1), -Vector3.new(0,1,0),
        Vector3.new(1,1,0)/math.sqrt(2), Vector3.new(1,0,1)/math.sqrt(2), Vector3.new(0,1,1)/math.sqrt(2),
        Vector3.new(-1,1,0)/math.sqrt(2), Vector3.new(-1,0,1)/math.sqrt(2),
        -Vector3.new(1,0,1)/math.sqrt(2), -Vector3.new(-1,0,1)/math.sqrt(2), -Vector3.new(0,-1,1)/math.sqrt(2),
        Vector3.new(1,1,1)/math.sqrt(3), Vector3.new(-1,1,1)/math.sqrt(3), Vector3.new(1,1,-1)/math.sqrt(3),
        -Vector3.new(1,1,1)/math.sqrt(3), -Vector3.new(1,-1,1)/math.sqrt(3),
        Vector3.new(1,2,0)/math.sqrt(5), Vector3.new(-1,2,0)/math.sqrt(5), Vector3.new(1,0,2)/math.sqrt(5), Vector3.new(-1,0,2)/math.sqrt(5),
        -Vector3.new(-1,0,2)/math.sqrt(5), -Vector3.new(1,0,2)/math.sqrt(5),
    }

    local function GetOffsets_Algo1(firePos, targetPos, offset)
        if not offset or offset<=0 then return {firePos} end
        local offsets={firePos}
        local cf=CFrame.new(firePos,targetPos)*CFrame.Angles(0,0,math.rad(math.random(1,360)))
        for _,pos in ipairs(ScanVectors) do table.insert(offsets, cf*(pos*offset)) end
        return offsets
    end

    local function GetOffsets_Algo2(center, poleDir, radius, count)
        if not radius or radius<=0 or count<=0 then return {center} end
        local offsets={center}
        local PHI=0.6180339887
        local arb=math.abs(poleDir.X)<0.9 and Vector3.new(1,0,0) or Vector3.new(0,1,0)
        local t1=poleDir:Cross(arb).Unit
        local t2=poleDir:Cross(t1).Unit
        for i=0,count-1 do
            local phi=i*PHI*2*math.pi
            local cosT=1-(i+0.5)/count
            local sinT=math.sqrt(1-cosT*cosT)
            local r=radius*(math.random()^(1/3))
            local dir=t1*(sinT*math.cos(phi))+t2*(sinT*math.sin(phi))+poleDir*cosT
            table.insert(offsets, center+dir*r)
        end
        return offsets
    end

    local function GetOffsets_Marsaglia(center, poleDir, radius, count)
        if not radius or radius<=0 or count<=0 then return {center} end
        local offsets={center}
        for i=1,count do
            local x1,x2,s
            repeat x1=math.random()*2-1; x2=math.random()*2-1; s=x1*x1+x2*x2 until s<1
            local scale=2*math.sqrt(1-s)
            local rawDir=Vector3.new(x1*scale,x2*scale,1-2*s).Unit
            if rawDir:Dot(poleDir)<0 then rawDir=-rawDir end
            local r=radius*(math.random()^(1/3))
            table.insert(offsets, center+rawDir*r)
        end
        return offsets
    end

    local function GetOffsets_AxisAligned(center, radius, count)
        if not radius or radius<=0 then return {center} end
        local offsets={center}
        local axes={Vector3.new(1,0,0),Vector3.new(-1,0,0),Vector3.new(0,1,0),Vector3.new(0,-1,0),Vector3.new(0,0,1),Vector3.new(0,0,-1)}
        for _,ax in ipairs(axes) do
            table.insert(offsets, center+ax*radius)
            table.insert(offsets, center+ax*(radius*0.5))
        end
        for i=1,count do
            local rx=(math.random()-0.5)*2*radius
            local ry=(math.random()-0.5)*2*radius*1.2
            local rz=(math.random()-0.5)*2*radius
            table.insert(offsets, center+Vector3.new(rx,ry,rz))
        end
        return offsets
    end

    local function DoRagebot()
        rcUsed = 0
        if not RB_State then Valid_Pair=nil; Locked_Path=nil; return end
        local target=GetTarget()
        if not target or not target.Character then Valid_Pair=nil; Locked_Path=nil; return end
        if Locked_Path and Locked_Path.Target~=target then Locked_Path=nil end

        local myRoot=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local tRoot=target.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot or not tRoot then return end
        local myPos=GetLocalRealPosition()
        local tPos=tRoot.Position

        if Locked_Path then
            local dO=(myPos-Locked_Path.MyPos).Magnitude
            local dH=(tPos-Locked_Path.TPos).Magnitude
            local inRange=(myPos-Locked_Path.AbsO).Magnitude<=Origin_Radius
                         and (tPos-Locked_Path.AbsH).Magnitude<=Hit_Radius
            if dO<=WB.Threshold and dH<=WB.Threshold and inRange then
                if CheckWallbang(Locked_Path.AbsO,Locked_Path.AbsH) then
                    Valid_Pair={Origin=Locked_Path.AbsO,Hit=Locked_Path.AbsH,Target=target}
                    WB.Cached=true; return
                end
            end
            Locked_Path=nil
        end

        if tick()-WB.LastScan < 1/ScanRate then return end
        WB.LastScan=tick(); WB.Round=WB.Round+1

        local newOrigin, newTarget
        local algoType=(WB.Round%4)+1
        local oPole=(tPos-myPos)
        if oPole.Magnitude<0.001 then return end
        oPole=oPole.Unit
        local hPole=-oPole

        if algoType==1 then
            newOrigin=GetOffsets_Algo1(myPos,tPos,Origin_Radius)
            newTarget=GetOffsets_Algo1(tPos,myPos,Hit_Radius)
        elseif algoType==2 then
            newOrigin=GetOffsets_Algo2(myPos,oPole,Origin_Radius,Origin_Scans)
            newTarget=GetOffsets_Algo2(tPos,hPole,Hit_Radius,Hit_Scans)
        elseif algoType==3 then
            newOrigin=GetOffsets_Marsaglia(myPos,oPole,Origin_Radius,Origin_Scans)
            newTarget=GetOffsets_Marsaglia(tPos,hPole,Hit_Radius,Hit_Scans)
        else
            newOrigin=GetOffsets_AxisAligned(myPos,Origin_Radius,Origin_Scans)
            newTarget=GetOffsets_AxisAligned(tPos,Hit_Radius,Hit_Scans)
        end

        local bestPO, bestPH = nil, nil
        for _,pO in ipairs(newOrigin) do
            if rcUsed >= RC_BUDGET then break end
            for _,pH in ipairs(newTarget) do
                if rcUsed >= RC_BUDGET then break end
                if CheckWallbang(pO,pH) then bestPO=pO; bestPH=pH; break end
            end
            if bestPO then break end
        end
        if not bestPO and rcUsed < RC_BUDGET then
            if CheckWallbang(myPos,tPos) then bestPO=myPos; bestPH=tPos end
        end

        if bestPO then
            Locked_Path={AbsO=bestPO,AbsH=bestPH,Target=target,MyPos=myPos,TPos=tPos}
            Valid_Pair={Origin=bestPO,Hit=bestPH,Target=target}
            WB.Cached=false
        else
            Valid_Pair=nil
        end
    end

    RunService.Heartbeat:Connect(function()
        if not RB_State or not Valid_Pair then return end
        local char=LocalPlayer.Character
        local tool=char and char:FindFirstChildOfClass("Tool")
        if not (tool and tool:FindFirstChild("IsGun")) then return end

        local waitTime=0
        if RF_State then
            local gn=tool.Name
            if (gn:find("Beretta") or gn:find("TEC")) then waitTime=0.01 else
                local cfg=tool:FindFirstChild("Config")
                if cfg and cfg:IsA("ModuleScript") then
                    local ok,gs=pcall(require,cfg)
                    if ok and gs then waitTime=1/(gs.FireRate or 3) else waitTime=0.1 end
                else waitTime=0.1 end
            end
        else waitTime=0.5 end

        if tick()-Last_Shot < waitTime then return end

        local vals=tool:FindFirstChild("Values")
        local ammo=vals and vals:FindFirstChild("SERVER_Ammo")
        if not (ammo and ammo.Value>0) then return end

        local targetChar=Valid_Pair.Target and Valid_Pair.Target.Character
        if not targetChar then return end

        local headPart  = targetChar:FindFirstChild("Head")
        local torsoPart = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
        local hrpPart   = targetChar:FindFirstChild("HumanoidRootPart")

        local selectedParts=Selected_HitParts
        local validPartsList={}
        if type(selectedParts)=="table" then
            if selectedParts["Head"] or selectedParts[1]=="Head" then table.insert(validPartsList,headPart) end
            if selectedParts["Torso"] or selectedParts[1]=="Torso" or selectedParts[2]=="Torso" then table.insert(validPartsList,torsoPart) end
            if selectedParts["HumanoidRootPart"] or selectedParts[3]=="HumanoidRootPart" then table.insert(validPartsList,hrpPart) end
        end
        if #validPartsList==0 then validPartsList={headPart,hrpPart,torsoPart} end

        local part=nil
        local hitPos=Valid_Pair.Hit
        for _,candidate in ipairs(validPartsList) do
            if candidate then
                part=candidate
                local cp=candidate.Position
                if candidate==torsoPart or candidate==hrpPart then
                    if hrpPart then
                        local d=(cp-hrpPart.Position).Magnitude
                        if d>5 or (Valid_Pair.Origin-cp).Magnitude>50 then
                            hitPos=cp+Vector3.new(0,0.5,0)
                        else hitPos=cp end
                    else hitPos=cp end
                else hitPos=Valid_Pair.Hit end
                break
            end
        end
        if not part then
            part=headPart or hrpPart
            if not part then return end
        end

        local key="K"..math.random(1000,9999)
        local dir=(hitPos-Valid_Pair.Origin).Unit

        local function shoot()
            GN_S:FireServer(tick(), key, tool, "FDS9I83", Valid_Pair.Origin, {dir}, false)
            if TR.Enabled then task.spawn(CreateTracer, Valid_Pair.Origin, dir) end
            ZF_H:FireServer("🧈", tool, key, 1, part, hitPos, dir)
            if tool:FindFirstChild("Hitmarker") then tool.Hitmarker:Fire(part) end

            if tool:FindFirstChild("Handle") then
                local handle=tool.Handle
                local fireSound=handle:FindFirstChild("Fire") or handle:FindFirstChild("Shoot") or handle:FindFirstChildOfClass("Sound")
                if fireSound and fireSound:IsA("Sound") then fireSound:Play() end
            end

            if CustomMuzzleSound_State then
                pcall(function()
                    local wh=tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle")
                    if wh then
                        local mz=wh:FindFirstChild("Muzzle")
                        if mz then
                            local ms=mz:FindFirstChild("Fire Sound1") or mz:FindFirstChild("FireSound1") or mz:FindFirstChildOfClass("Sound")
                            if ms and ms:IsA("Sound") then
                                local cs=ms:Clone(); cs.Parent=mz; cs.Volume=ms.Volume; cs:Play()
                                task.delay(cs.TimeLength>0 and cs.TimeLength or 2, function() if cs then cs:Destroy() end end)
                            end
                        end
                    end
                end)
            end

            if CustomMuzzleFlash_State then
                pcall(function()
                    local wh=tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle")
                    if wh then
                        local mz=wh:FindFirstChild("Muzzle")
                        if mz then
                            local fp=mz:FindFirstChild("Muzzle Flash 1") or mz:FindFirstChild("MuzzleFlash1") or mz:FindFirstChildOfClass("ParticleEmitter")
                            if fp and fp:IsA("ParticleEmitter") then
                                fp:Emit(fp.Rate>0 and math.clamp(fp.Rate,1,10) or 5)
                            end
                        end
                    end
                end)
            end
        end

        shoot()
        Last_Shot=tick()
    end)

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method=="FireServer" and self==ZF_H then
            if HitSoundSelection~="None" and HitSounds[HitSoundSelection] then
                task.spawn(function()
                    local Camera = Workspace.CurrentCamera
                    if not Camera then return end
                    local s=Instance.new("Sound", Camera); s.SoundId=HitSounds[HitSoundSelection]; s.Volume=1; s:Play()
                    Debris:AddItem(s,1)
                end)
            end
        end
        if not checkcaller() then
            if self==ZF_H and method=="FireServer" and args[1]~="🧈" then return nil end
            if self==GN_S and method=="FireServer" and TR.Enabled then
                if typeof(args[5])=="Vector3" and typeof(args[6])=="table" and args[6][1] then
                    task.spawn(CreateTracer, args[5], args[6][1])
                end
            end
        end
        return oldNamecall(self, ...)
    end)

    RunService.Heartbeat:Connect(function() DoRagebot() end)
end

-- ═══════════════════════════════════════════════════════════
--  Shared Bridge
-- ═══════════════════════════════════════════════════════════
local Bridge = {
    MoveSpeed = { enabled = false, value = 32 },
    MoveJump  = { enabled = false, value = 75 },
    SelectedPlayer = "",
}

-- ═══════════════════════════════════════════════════════════
--  UI Startup
-- ═══════════════════════════════════════════════════════════
local Window      = Library:Window({Name = "chz.lol.aa.cc.dc.gg"})
local Watermark   = Library:Watermark("chz.lol.gg.cc.aa.dc")
local KeybindList = Library:KeybindList()

-- ╔═══════════════════════════════════════════════════════╗
-- ║ Home                                                   ║
-- ╚═══════════════════════════════════════════════════════╝
local MainTab = Window:Page({Name = "test", Columns = 2, Subtabs = false})

local Sec1 = MainTab:Section({Name = "Toggles", Side = 1})
Sec1:Toggle({Name = "Sample Toggle", Flag = "demo_toggle", Default = false,
    Callback = function(v) print("Toggle:", v) end})

Sec1:Toggle({Name = "Toggle with Colorpicker", Flag = "demo_toggle_color", Default = false,
    Callback = function(v) print("Toggle:", v) end}):Colorpicker({
    Name = "Color", Flag = "demo_color1",
    Default = Color3.fromRGB(255, 100, 100),
    Callback = function(c) print("Color:", c) end
})
Sec1:Divider()

local Sec1b = MainTab:Section({Name = "Sliders", Side = 1})
Sec1b:Slider({Name = "Normal Slider", Flag = "demo_slider",
    Min = 0, Max = 100, Default = 50, Suffix = "%", Decimals = 1,
    Callback = function(v) print("Slider:", v) end})

Sec1b:Slider({Name = "Compact Slider", Flag = "demo_slider2",
    Min = 0, Max = 200, Default = 100, Compact = true,
    Callback = function(v) print("Compact:", v) end})

local Sec2 = MainTab:Section({Name = "Buttons & Input", Side = 2})
Sec2:Button({Name = "Click Me (Notify)", Callback = function()
    Library:Notification("You clicked the button", 3, Color3.fromRGB(0, 255, 0))
end})

Sec2:Textbox({Name = "Textbox", Flag = "demo_text",
    Placeholder = "Type something...", Default = "",
    Callback = function(v) print("Text:", v) end})

Sec2:Dropdown({Name = "Single Dropdown", Flag = "demo_dropdown",
    Items = {"Option A", "Option B", "Option C"}, Default = "Option A",
    Callback = function(v) print("Selected:", v) end})

Sec2:Dropdown({Name = "Multi Dropdown", Flag = "demo_dropdown_multi",
    Items = {"Apple", "Banana", "Orange"}, Multi = true,
    Callback = function(v) print("Multi:", table.concat(v, ", ")) end})

pcall(function() Watermark:SetVisibility(false)   end)
pcall(function() KeybindList:SetVisibility(false) end)

if type(Chams) ~= "table" or type(Chams.state) ~= "table" then
    Chams = { state = { enabled=false, outline=false, outlineCol=Color3.new(),
        outlineAlpha=0, outlineSize=0, glow=false, glowLayers=0, glowRange=0, glowBright=0,
        inline=false, inlineCol=Color3.new(), inlineAlpha=0, inlineSize=0 },
        touch=function() end, enable=function() end,
        disable=function() end, rebuildAll=function() end }
end

local function note(t, c)
    pcall(function() Library:Notification(t, 2, c or Color3.fromRGB(120,200,255)) end)
end
local function eR() pcall(function() ESP:refresh()   end) end
local function eU() pcall(function() ESP:updateAll() end) end
local function cC(f) pcall(function() f() end) end

-- ═══════════════════════════════════════════════════════════
--  ESP + Chams + World Visual · 完整 UI
--   所有回调均带 pcall 保护，任何操作都不会报错
--   所有 Slider 使用 Decimals = 0.01（支持任意小数）
-- ═══════════════════════════════════════════════════════════
local function note(t, c)
    pcall(function() Library:Notification(t, 2, c or Color3.fromRGB(120,200,255)) end)
end
local function eR() pcall(function() ESP:refresh() end) end
local function eU() pcall(function() ESP:updateAll() end) end
local function cC(f) pcall(function() f() end) end

local Tab  = Window:Page({Name = "ESP / Chams", Columns = 2, Subtabs = false})
local ESec = Tab:Section({Name = "ESP Settings", Side = 1})
local TSec = Tab:Section({Name = "Player Tags",  Side = 1})
local CM   = Tab:Section({Name = "Chams",         Side = 2})
local CO   = Tab:Section({Name = "Chams Outline", Side = 2})
local CG   = Tab:Section({Name = "Chams Glow",    Side = 2})
local CI   = Tab:Section({Name = "Chams Inline",  Side = 2})

-- ═══════════════════════════════════════════════════════════
--  ESP Settings
-- ═══════════════════════════════════════════════════════════
ESec:Toggle({ Name="Enable ESP", Flag="esp_enabled", Default=false,
    Callback=function(v)
        ESP.flags.Enabled = v and true or false; eR()
        note("ESP "..(v and "Enabled" or "Disabled"),
            v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,80,80))
    end })

ESec:Divider()

ESec:Toggle({ Name="Show Names", Flag="esp_names", Default=true,
    Callback=function(v) ESP.flags.Names = v and true or false; eR() end })

ESec:Toggle({ Name="Show Boxes", Flag="esp_boxes", Default=true,
    Callback=function(v) ESP.flags.Boxes = v and true or false; eR() end })

ESec:Dropdown({ Name="Box Type", Flag="esp_box_type",
    Items={"Normal","Corner"}, Default="Normal",
    Callback=function(v) ESP.flags.Box_Type=v; eR() end })

ESec:Toggle({ Name="Show Healthbar", Flag="esp_healthbar", Default=true,
    Callback=function(v) ESP.flags.Healthbar = v and true or false; eR() end })

ESec:Toggle({ Name="Show Distance", Flag="esp_distance", Default=true,
    Callback=function(v) ESP.flags.Distance = v and true or false; eR() end })

ESec:Toggle({ Name="Show Weapon", Flag="esp_weapon", Default=true,
    Callback=function(v) ESP.flags.Weapon = v and true or false; eR() end })

ESec:Divider()

-- ★ ESP 大小（步进 0.01，任意小数）
ESec:Slider({
    Name = "ESP Size Scale", Flag = "esp_scale",
    Min = 0.5, Max = 3, Default = 1,
    Decimals = 0.01, Suffix = "x",
    Callback = function(v)
        ESP.flags.Scale = v
        eR()
    end
})

-- ★ 字体大小（步进 0.01，任意小数）
ESec:Slider({
    Name = "Font Size Scale", Flag = "esp_fontscale",
    Min = 0.5, Max = 2.5, Default = 1,
    Decimals = 0.01, Suffix = "x",
    Callback = function(v)
        ESP:setFontScale(v)
    end
})

ESec:Label({Name="ESP Hotkey", Alignment="Left"}):Keybind({
    Name="Toggle ESP", Flag="esp_keybind",
    Default=Enum.KeyCode.RightShift, Mode="Toggle",
    Callback=function(t)
        if t then
            local ns = not ESP.flags.Enabled
            ESP.flags.Enabled = ns; eR()
            pcall(function()
                if Library.SetFlags["esp_enabled"] then
                    Library.SetFlags["esp_enabled"](ns)
                end
            end)
        end
    end })

-- ═══════════════════════════════════════════════════════════
--  Player Tags
-- ═══════════════════════════════════════════════════════════
TSec:Label({Name="Add player to Black/Whitelist", Alignment="Left"})

local LB
LB = TSec:Listbox({ Name="Player List", Items={}, Multi=false,
    Flag="esp_tag_list", Size=130,
    Callback=function(v) Bridge.SelectedPlayer = v or "" end })

-- ★ 名单自动刷新：新玩家自动加入，退出玩家自动移除
do
    local Players     = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function BuildList()
        local l = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                l[#l + 1] = p.Name
            end
        end
        table.sort(l)
        return l
    end

    local function SameList(a, b)
        if #a ~= #b then return false end
        for i = 1, #a do
            if a[i] ~= b[i] then return false end
        end
        return true
    end

    -- 玩家进入：立即加入名单
    Players.PlayerAdded:Connect(function()
        task.defer(function()
            if LB then pcall(function() LB:Refresh(BuildList()) end) end
        end)
    end)

    -- 玩家退出：立即移除名单 + 清掉黑/白名单残留
    Players.PlayerRemoving:Connect(function(leaving)
        task.defer(function()
            pcall(function()
                if ESP and ESP.player_status then
                    ESP.player_status[leaving.Name] = nil
                    if ESP.updateAll then ESP:updateAll() end
                end
            end)
            if LB then pcall(function() LB:Refresh(BuildList()) end) end
        end)
    end)

    -- 兜底轮询：每 2 秒扫一次（防信号丢失）
    task.spawn(function()
        local lastList = {}
        while LB and task.wait(2) do
            local now = BuildList()
            if not SameList(now, lastList) then
                lastList = now
                pcall(function() LB:Refresh(now) end)
            end
        end
    end)

    -- 首次立即拉一遍
    task.defer(function()
        if LB then pcall(function() LB:Refresh(BuildList()) end) end
    end)
end

TSec:Button({Name="Set Blacklist", Callback=function()
    if Bridge.SelectedPlayer == "" then
        note("Select a player first", Color3.fromRGB(255,80,80)); return
    end
    ESP.player_status[Bridge.SelectedPlayer] = "Blacklist"; eU()
    note(Bridge.SelectedPlayer.." -> Blacklist", Color3.fromRGB(255,80,80))
end })

TSec:Button({Name="Set Whitelist", Callback=function()
    if Bridge.SelectedPlayer == "" then
        note("Select a player first", Color3.fromRGB(255,80,80)); return
    end
    ESP.player_status[Bridge.SelectedPlayer] = "Whitelist"; eU()
    note(Bridge.SelectedPlayer.." -> Whitelist", Color3.fromRGB(0,255,120))
end })

TSec:Button({Name="Clear Tag", Callback=function()
    if Bridge.SelectedPlayer == "" then return end
    ESP.player_status[Bridge.SelectedPlayer] = nil; eU()
    note(Bridge.SelectedPlayer.." tag cleared", Color3.fromRGB(200,200,200))
end })

TSec:Divider()

TSec:Label({Name="Default Color", Alignment="Left"}):Colorpicker({
    Name="Default", Flag="esp_color_none", Default=Color3.fromRGB(255,255,255),
    Callback=function(c) ESP.status_colors.None=c; eU() end })

TSec:Label({Name="Blacklist Color", Alignment="Left"}):Colorpicker({
    Name="Blacklist", Flag="esp_color_bl", Default=Color3.fromRGB(255,0,0),
    Callback=function(c) ESP.status_colors.Blacklist=c; eU() end })

TSec:Label({Name="Whitelist Color", Alignment="Left"}):Colorpicker({
    Name="Whitelist", Flag="esp_color_wl", Default=Color3.fromRGB(0,255,0),
    Callback=function(c) ESP.status_colors.Whitelist=c; eU() end })

TSec:Toggle({ Name="Only Show Blacklist", Flag="esp_only_blacklist", Default=false,
    Callback=function(v)
        ESP.show_only_blacklist = v and true or false
        if v then ESP.show_only_whitelist = false end
    end })

TSec:Toggle({ Name="Only Show Whitelist", Flag="esp_only_whitelist", Default=false,
    Callback=function(v)
        ESP.show_only_whitelist = v and true or false
        if v then ESP.show_only_blacklist = false end
    end })

-- ═══════════════════════════════════════════════════════════
--  Chams
-- ═══════════════════════════════════════════════════════════
CM:Toggle({ Name="Enable Chams", Flag="chams_enabled", Default=false,
    Callback=function(v)
        cC(function() if v then Chams.enable() else Chams.disable() end end)
        note("Chams "..(v and "Enabled" or "Disabled"),
            v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,80,80))
    end })

CM:Button({Name="Rebuild Chams", Callback=function()
    cC(function() Chams.rebuildAll() end); note("Chams rebuilt")
end })

CO:Toggle({ Name="Enable Outline", Flag="chams_outline", Default=true,
    Callback=function(v)
        Chams.state.outline = v and true or false
        cC(function() Chams.touch() end)
    end })

CO:Label({Name="Outline Color", Alignment="Left"}):Colorpicker({
    Name="Outline Color", Flag="chams_outline_col", Default=Color3.fromRGB(120,200,255),
    Callback=function(c)
        if typeof(c) == "Color3" then
            Chams.state.outlineCol = c
            cC(function() Chams.touch() end)
        end
    end })

CO:Slider({ Name="Outline Alpha", Flag="chams_outline_alpha",
    Min=0, Max=1, Default=0.50, Decimals=0.01, Suffix="",
    Callback=function(v) Chams.state.outlineAlpha=v; cC(function() Chams.touch() end) end })

CO:Slider({ Name="Outline Size", Flag="chams_outline_size",
    Min=0, Max=1, Default=0.30, Decimals=0.01, Suffix="",
    Callback=function(v) Chams.state.outlineSize=v; cC(function() Chams.touch() end) end })

CG:Toggle({ Name="Enable Glow", Flag="chams_glow", Default=true,
    Callback=function(v)
        Chams.state.glow = v and true or false
        cC(function() Chams.touch() end)
    end })

CG:Slider({ Name="Glow Layers", Flag="chams_glow_layers",
    Min=0, Max=1, Default=0.50, Decimals=0.01, Suffix="",
    Callback=function(v) Chams.state.glowLayers=v; cC(function() Chams.touch() end) end })

CG:Slider({ Name="Glow Range", Flag="chams_glow_range",
    Min=0, Max=1, Default=0.30, Decimals=0.01, Suffix="",
    Callback=function(v) Chams.state.glowRange=v; cC(function() Chams.touch() end) end })

CG:Slider({ Name="Glow Brightness", Flag="chams_glow_bright",
    Min=0, Max=1, Default=0.30, Decimals=0.01, Suffix="",
    Callback=function(v) Chams.state.glowBright=v; cC(function() Chams.touch() end) end })

CI:Toggle({ Name="Enable Inline", Flag="chams_inline", Default=true,
    Callback=function(v)
        Chams.state.inline = v and true or false
        cC(function() Chams.touch() end)
    end })

CI:Label({Name="Inline Color", Alignment="Left"}):Colorpicker({
    Name="Inline Color", Flag="chams_inline_col", Default=Color3.fromRGB(0,0,0),
    Callback=function(c)
        if typeof(c) == "Color3" then
            Chams.state.inlineCol = c
            cC(function() Chams.touch() end)
        end
    end })

CI:Slider({ Name="Inline Alpha", Flag="chams_inline_alpha",
    Min=0, Max=1, Default=0.50, Decimals=0.01, Suffix="",
    Callback=function(v) Chams.state.inlineAlpha=v; cC(function() Chams.touch() end) end })

CI:Slider({ Name="Inline Size", Flag="chams_inline_size",
    Min=0, Max=1, Default=0.20, Decimals=0.01, Suffix="",
    Callback=function(v) Chams.state.inlineSize=v; cC(function() Chams.touch() end) end })

-- ═══════════════════════════════════════════════════════════
--  World Visual + Camera FOV
-- ═══════════════════════════════════════════════════════════
local WV = WorldVisual

local WVFOVSec    = Tab:Section({Name = "Camera FOV",     Side = 1})
local WVMainSec   = Tab:Section({Name = "World Visual",   Side = 1})
local WVFogSec    = Tab:Section({Name = "WV Fog",         Side = 2})
local WVTimeSec   = Tab:Section({Name = "WV Time",        Side = 2})
local WVLightSec  = Tab:Section({Name = "WV Light",       Side = 2})
local WVFilterSec = Tab:Section({Name = "WV Filter",      Side = 2})

WVFOVSec:Toggle({
    Name = "Enable FOV Control", Flag = "wv_fov_on", Default = false,
    Callback = function(v)
        WV.fovState.on = v and true or false
        if v then cC(WV.applyFOV) else cC(WV.removeFOV) end
        note("FOV " .. (v and "ON" or "OFF"),
            v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80))
    end
})

WVFOVSec:Slider({
    Name = "Camera FOV", Flag = "wv_fov_value",
    Min = 1, Max = 120, Default = 70, Decimals = 0.01, Suffix = "°",
    Callback = function(v)
        WV.fovState.value = v
        if WV.fovState.on then cC(WV.applyFOV) end
    end
})

WVFOVSec:Divider()
WVFOVSec:Button({Name = "Preset 70 (Default)", Callback = function()
    WV.fovState.value = 70
    pcall(function()
        if Library.SetFlags["wv_fov_value"] then Library.SetFlags["wv_fov_value"](70) end
    end)
    if WV.fovState.on then cC(WV.applyFOV) end
end})
WVFOVSec:Button({Name = "Preset 90", Callback = function()
    WV.fovState.value = 90
    pcall(function()
        if Library.SetFlags["wv_fov_value"] then Library.SetFlags["wv_fov_value"](90) end
    end)
    if WV.fovState.on then cC(WV.applyFOV) end
end})
WVFOVSec:Button({Name = "Preset 120 (Max)", Callback = function()
    WV.fovState.value = 120
    pcall(function()
        if Library.SetFlags["wv_fov_value"] then Library.SetFlags["wv_fov_value"](120) end
    end)
    if WV.fovState.on then cC(WV.applyFOV) end
end})

WVMainSec:Label({Name = "Beautiful Presets", Alignment = "Left"})

WVMainSec:Button({Name = "Golden Hour", Callback = function()
    cC(function()
        WV.turnAllOn()
        WV.timeState.target = 17.2
        WV.fogState.color = Color3.fromRGB(255, 224, 199)
        WV.fogState.decay = Color3.fromRGB(158, 174, 214)
        WV.fogState.density = 0.16
        WV.fogState.haze = 1.40
        WV.fogState.glare = 0.22
        WV.filterState.tint = Color3.fromRGB(255, 240, 220)
        WV.filterState.saturation = 0.22
        WV.filterState.contrast = 0.10
        WV.filterState.brightness = 0.05
        WV.filterState.bloomIntensity = 0.50
        WV.filterState.bloomThreshold = 0.72
        WV.filterState.bloomSize = 24
        WV.filterState.sunIntensity = 0.12
        WV.lightState.ambient = Color3.fromRGB(96, 84, 96)
        WV.lightState.outdoor = Color3.fromRGB(158, 140, 126)
        WV.lightState.exposure = 0.15
        WV.applyFog(0.6); WV.applyLight(0.6); WV.applyFilter(0.6)
    end)
    note("Golden Hour applied", Color3.fromRGB(255, 200, 100))
end})

WVMainSec:Button({Name = "Dreamy Dusk", Callback = function()
    cC(function()
        WV.turnAllOn()
        WV.timeState.target = 19.4
        WV.fogState.color = Color3.fromRGB(214, 176, 214)
        WV.fogState.decay = Color3.fromRGB(126, 122, 186)
        WV.fogState.density = 0.20
        WV.fogState.haze = 1.80
        WV.fogState.glare = 0.30
        WV.filterState.tint = Color3.fromRGB(246, 228, 246)
        WV.filterState.saturation = 0.18
        WV.filterState.contrast = 0.14
        WV.filterState.brightness = 0.03
        WV.filterState.bloomIntensity = 0.55
        WV.filterState.bloomThreshold = 0.70
        WV.filterState.bloomSize = 26
        WV.filterState.sunIntensity = 0.06
        WV.lightState.ambient = Color3.fromRGB(84, 78, 108)
        WV.lightState.outdoor = Color3.fromRGB(132, 118, 148)
        WV.lightState.exposure = 0.22
        WV.applyFog(0.6); WV.applyLight(0.6); WV.applyFilter(0.6)
    end)
    note("Dreamy Dusk applied", Color3.fromRGB(200, 160, 255))
end})

WVMainSec:Button({Name = "Soft Morning", Callback = function()
    cC(function()
        WV.turnAllOn()
        WV.timeState.target = 8.6
        WV.fogState.color = Color3.fromRGB(226, 236, 246)
        WV.fogState.decay = Color3.fromRGB(170, 194, 220)
        WV.fogState.density = 0.14
        WV.fogState.haze = 1.20
        WV.fogState.glare = 0.18
        WV.filterState.tint = Color3.fromRGB(240, 246, 255)
        WV.filterState.saturation = 0.16
        WV.filterState.contrast = 0.08
        WV.filterState.brightness = 0.08
        WV.filterState.bloomIntensity = 0.40
        WV.filterState.bloomThreshold = 0.78
        WV.filterState.bloomSize = 20
        WV.filterState.sunIntensity = 0.10
        WV.lightState.ambient = Color3.fromRGB(92, 100, 116)
        WV.lightState.outdoor = Color3.fromRGB(150, 162, 178)
        WV.lightState.exposure = 0.18
        WV.applyFog(0.6); WV.applyLight(0.6); WV.applyFilter(0.6)
    end)
    note("Soft Morning applied", Color3.fromRGB(180, 220, 255))
end})

WVMainSec:Button({Name = "Cinematic Night", Callback = function()
    cC(function()
        WV.turnAllOn()
        WV.timeState.target = 0.5
        WV.fogState.color = Color3.fromRGB(120, 138, 176)
        WV.fogState.decay = Color3.fromRGB(70, 82, 128)
        WV.fogState.density = 0.22
        WV.fogState.haze = 1.60
        WV.fogState.glare = 0.28
        WV.filterState.tint = Color3.fromRGB(208, 220, 255)
        WV.filterState.saturation = 0.14
        WV.filterState.contrast = 0.16
        WV.filterState.brightness = 0.02
        WV.filterState.bloomIntensity = 0.60
        WV.filterState.bloomThreshold = 0.62
        WV.filterState.bloomSize = 28
        WV.filterState.sunIntensity = 0.02
        WV.lightState.ambient = Color3.fromRGB(58, 66, 92)
        WV.lightState.outdoor = Color3.fromRGB(88, 100, 134)
        WV.lightState.exposure = 0.30
        WV.applyFog(0.6); WV.applyLight(0.6); WV.applyFilter(0.6)
    end)
    note("Cinematic Night applied", Color3.fromRGB(140, 160, 220))
end})

WVMainSec:Divider()

WVMainSec:Button({Name = "Disable All & Restore", Callback = function()
    cC(WV.disableAll)
    note("All effects disabled & restored", Color3.fromRGB(255, 200, 100))
end})

WVFogSec:Toggle({
    Name = "Enable Fog", Flag = "wv_fog_on", Default = false,
    Callback = function(v)
        WV.fogState.on = v and true or false
        if v then cC(WV.applyFog) else cC(WV.removeFog) end
    end
})

WVFogSec:Slider({
    Name = "Fog Density", Flag = "wv_fog_density",
    Min = 0, Max = 40, Default = 16, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.fogState.density = v / 100
        if WV.fogState.on then cC(function() WV.applyFog(0.25) end) end
    end
})

WVFogSec:Slider({
    Name = "Height Offset", Flag = "wv_fog_offset",
    Min = 0, Max = 100, Default = 10, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.fogState.offset = v / 100
        if WV.fogState.on then cC(function() WV.applyFog(0.25) end) end
    end
})

WVFogSec:Slider({
    Name = "Glare", Flag = "wv_fog_glare",
    Min = 0, Max = 100, Default = 22, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.fogState.glare = v / 100
        if WV.fogState.on then cC(function() WV.applyFog(0.25) end) end
    end
})

WVFogSec:Slider({
    Name = "Haze", Flag = "wv_fog_haze",
    Min = 0, Max = 300, Default = 140, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.fogState.haze = v / 100
        if WV.fogState.on then cC(function() WV.applyFog(0.25) end) end
    end
})

WVFogSec:Slider({
    Name = "View Distance", Flag = "wv_fog_end",
    Min = 100, Max = 2500, Default = 900, Decimals = 0.01, Suffix = "m",
    Callback = function(v)
        WV.fogState.fogEnd = v
        WV.fogState.fogStart = math.max(5, v * 0.07)
        if WV.fogState.on then cC(function() WV.applyFog(0.25) end) end
    end
})

WVFogSec:Label({Name = "Fog Tint", Alignment = "Left"}):Colorpicker({
    Name = "Fog Tint", Flag = "wv_fog_color",
    Default = Color3.fromRGB(255, 224, 199),
    Callback = function(c)
        if typeof(c) ~= "Color3" then return end
        WV.fogState.color = c
        if WV.fogState.on then cC(function() WV.applyFog(0.25) end) end
    end
})

WVFogSec:Label({Name = "Fog Decay", Alignment = "Left"}):Colorpicker({
    Name = "Fog Decay", Flag = "wv_fog_decay",
    Default = Color3.fromRGB(158, 174, 214),
    Callback = function(c)
        if typeof(c) ~= "Color3" then return end
        WV.fogState.decay = c
        if WV.fogState.on then cC(function() WV.applyFog(0.25) end) end
    end
})

WVTimeSec:Toggle({
    Name = "Enable Time Control", Flag = "wv_time_on", Default = false,
    Callback = function(v)
        WV.timeState.on = v and true or false
        pcall(function()
            if v then
                WV.timeState.current = game:GetService("Lighting").ClockTime
                WV.timeState.target = game:GetService("Lighting").ClockTime
            else
                game:GetService("Lighting").ClockTime = WV.Orig.ClockTime
            end
        end)
    end
})

WVTimeSec:Slider({
    Name = "World Time Hours", Flag = "wv_clock_time",
    Min = 0, Max = 24, Default = 17.2, Decimals = 0.01, Suffix = "h",
    Callback = function(v) WV.timeState.target = v end
})

WVTimeSec:Slider({
    Name = "Transition Speed", Flag = "wv_time_speed",
    Min = 1, Max = 10, Default = 3, Decimals = 0.01,
    Callback = function(v) WV.timeState.speedMul = v end
})

WVLightSec:Toggle({
    Name = "Enable Brightness Control", Flag = "wv_light_on", Default = false,
    Callback = function(v)
        WV.lightState.on = v and true or false
        if v then cC(WV.applyLight) else cC(WV.removeLight) end
    end
})

WVLightSec:Slider({
    Name = "Map Brightness", Flag = "wv_brightness",
    Min = 0, Max = 5, Default = 2.4, Decimals = 0.01,
    Callback = function(v)
        WV.lightState.brightness = v
        if WV.lightState.on then cC(function() WV.applyLight(0.25) end) end
    end
})

WVLightSec:Label({Name = "Ambient Color", Alignment = "Left"}):Colorpicker({
    Name = "Ambient Color", Flag = "wv_ambient_color",
    Default = Color3.fromRGB(96, 84, 96),
    Callback = function(c)
        if typeof(c) ~= "Color3" then return end
        WV.lightState.ambient = c
        if WV.lightState.on then cC(function() WV.applyLight(0.25) end) end
    end
})

WVLightSec:Label({Name = "Outdoor Ambient Color", Alignment = "Left"}):Colorpicker({
    Name = "Outdoor Color", Flag = "wv_outdoor_color",
    Default = Color3.fromRGB(158, 140, 126),
    Callback = function(c)
        if typeof(c) ~= "Color3" then return end
        WV.lightState.outdoor = c
        if WV.lightState.on then cC(function() WV.applyLight(0.25) end) end
    end
})

WVLightSec:Slider({
    Name = "Exposure Compensation", Flag = "wv_exposure",
    Min = -2, Max = 3, Default = 0.15, Decimals = 0.01,
    Callback = function(v)
        WV.lightState.exposure = v
        if WV.lightState.on then cC(function() WV.applyLight(0.25) end) end
    end
})

WVLightSec:Slider({
    Name = "Diffuse Scale", Flag = "wv_diffuse",
    Min = 0, Max = 100, Default = 60, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.lightState.diffuse = v / 100
        if WV.lightState.on then cC(function() WV.applyLight(0.25) end) end
    end
})

WVLightSec:Slider({
    Name = "Specular Scale", Flag = "wv_specular",
    Min = 0, Max = 100, Default = 60, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.lightState.specular = v / 100
        if WV.lightState.on then cC(function() WV.applyLight(0.25) end) end
    end
})

WVFilterSec:Toggle({
    Name = "Enable Filter", Flag = "wv_filter_on", Default = false,
    Callback = function(v)
        WV.filterState.on = v and true or false
        if v then cC(WV.applyFilter) else cC(WV.removeFilter) end
    end
})

WVFilterSec:Slider({
    Name = "Filter Brightness", Flag = "wv_f_bright",
    Min = -20, Max = 30, Default = 5, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.filterState.brightness = v / 100
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Slider({
    Name = "Filter Contrast", Flag = "wv_f_contrast",
    Min = -30, Max = 50, Default = 10, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.filterState.contrast = v / 100
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Slider({
    Name = "Filter Saturation", Flag = "wv_f_saturation",
    Min = -50, Max = 80, Default = 20, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.filterState.saturation = v / 100
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Label({Name = "Filter Tint", Alignment = "Left"}):Colorpicker({
    Name = "Tint Color", Flag = "wv_f_tint",
    Default = Color3.fromRGB(255, 240, 220),
    Callback = function(c)
        if typeof(c) ~= "Color3" then return end
        WV.filterState.tint = c
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Divider()
WVFilterSec:Label({Name = "Bloom", Alignment = "Left"})

WVFilterSec:Slider({
    Name = "Bloom Intensity", Flag = "wv_bloom_intensity",
    Min = 0, Max = 100, Default = 45, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.filterState.bloomIntensity = v / 100
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Slider({
    Name = "Bloom Threshold", Flag = "wv_bloom_threshold",
    Min = 0, Max = 200, Default = 75, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.filterState.bloomThreshold = v / 100
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Slider({
    Name = "Bloom Size", Flag = "wv_bloom_size",
    Min = 0, Max = 56, Default = 22, Decimals = 0.01,
    Callback = function(v)
        WV.filterState.bloomSize = v
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Divider()
WVFilterSec:Label({Name = "Sun Rays", Alignment = "Left"})

WVFilterSec:Slider({
    Name = "Sun Rays Intensity", Flag = "wv_sun_intensity",
    Min = 0, Max = 50, Default = 8, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.filterState.sunIntensity = v / 100
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Slider({
    Name = "Sun Rays Spread", Flag = "wv_sun_spread",
    Min = 0, Max = 200, Default = 85, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.filterState.sunSpread = v / 100
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Divider()
WVFilterSec:Label({Name = "Depth Of Field", Alignment = "Left"})

WVFilterSec:Slider({
    Name = "DOF Far Blur", Flag = "wv_dof_far",
    Min = 0, Max = 200, Default = 120, Decimals = 0.01, Suffix = "%",
    Callback = function(v)
        WV.filterState.dofFar = v
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Slider({
    Name = "DOF Focus Distance", Flag = "wv_dof_focus",
    Min = 0, Max = 200, Default = 55, Decimals = 0.01,
    Callback = function(v)
        WV.filterState.dofFocus = v
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

WVFilterSec:Slider({
    Name = "DOF In Focus Radius", Flag = "wv_dof_near",
    Min = 0, Max = 100, Default = 12, Decimals = 0.01,
    Callback = function(v)
        WV.filterState.dofNear = v
        if WV.filterState.on then cC(function() WV.applyFilter(0.25) end) end
    end
})

-- ═══════════════════════════════════════════════════════════
--  【UI · 设置页】
-- ═══════════════════════════════════════════════════════════
Library:CreateSettingsPage(Window, Watermark, KeybindList)
Library:Init()

-- ╔═══════════════════════════════════════════════════════╗
-- ║ Movement  (Speed / Jump via sliders)                   ║
-- ╚═══════════════════════════════════════════════════════╝
local MoveTab  = Window:Page({Name = "Movement", Columns = 2, Subtabs = false})
local SpeedSec = MoveTab:Section({Name = "Speed", Side = 1})
local JumpSec  = MoveTab:Section({Name = "Jump",  Side = 2})

-- ── Speed ─────────────────────────────
SpeedSec:Toggle({
    Name = "Enable Speed Modifier", Flag = "move_speed_enabled", Default = false,
    Callback = function(v)
        Movement:SetSpeedEnabled(v)
        Bridge.MoveSpeed.enabled = v
        if v then Movement:SetSpeedValue(Bridge.MoveSpeed.value) end
        Library:Notification("Speed Modifier " .. (v and "Enabled" or "Disabled"), 2,
            v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80))
    end
})

-- Main speed slider — default 32, min 1 (never 0)
SpeedSec:Slider({
    Name = "WalkSpeed",
    Flag = "move_speed_value",
    Min = 1, Max = 500,
    Default = 32,
    Decimals = 0,
    Suffix = " ws",
    Callback = function(v)
        Movement:SetSpeedValue(v)
        Bridge.MoveSpeed.value = v
    end
})

-- Fine tune (default 32, up to 100)
SpeedSec:Slider({
    Name = "Fine Tune (1-100)",
    Flag = "move_speed_value_fine",
    Min = 1, Max = 100,
    Default = 32,
    Decimals = 1,
    Suffix = " ws",
    Callback = function(v)
        Movement:SetSpeedValue(v)
        Bridge.MoveSpeed.value = v
        if Library.SetFlags["move_speed_value"] then
            Library.SetFlags["move_speed_value"](v)
        end
    end
})

SpeedSec:Button({Name = "Preset 16", Callback = function()
    Movement:SetSpeedValue(16); Bridge.MoveSpeed.value = 16
    if Library.SetFlags["move_speed_value"] then Library.SetFlags["move_speed_value"](16) end
end})
SpeedSec:Button({Name = "Preset 32 (Default)", Callback = function()
    Movement:SetSpeedValue(32); Bridge.MoveSpeed.value = 32
    if Library.SetFlags["move_speed_value"] then Library.SetFlags["move_speed_value"](32) end
end})
SpeedSec:Button({Name = "Preset 100", Callback = function()
    Movement:SetSpeedValue(100); Bridge.MoveSpeed.value = 100
    if Library.SetFlags["move_speed_value"] then Library.SetFlags["move_speed_value"](100) end
end})

SpeedSec:Label({Name = "Speed Hotkey", Alignment = "Left"}):Keybind({
    Name = "Toggle Speed", Flag = "move_speed_keybind",
    Default = Enum.KeyCode.RightAlt, Mode = "Toggle",
    Callback = function(toggled)
        if toggled then
            local ns = not Bridge.MoveSpeed.enabled
            Movement:SetSpeedEnabled(ns)
            Bridge.MoveSpeed.enabled = ns
            if Library.SetFlags["move_speed_enabled"] then Library.SetFlags["move_speed_enabled"](ns) end
        end
    end
})

-- ── Jump ──────────────────────────────
JumpSec:Toggle({
    Name = "Enable Jump Modifier", Flag = "move_jump_enabled", Default = false,
    Callback = function(v)
        Movement:SetJumpEnabled(v)
        Bridge.MoveJump.enabled = v
        if v then Movement:SetJumpValue(Bridge.MoveJump.value) end
        Library:Notification("Jump Modifier " .. (v and "Enabled" or "Disabled"), 2,
            v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80))
    end
})

-- Main jump slider — default 75, min 50
JumpSec:Slider({
    Name = "JumpPower",
    Flag = "move_jump_value",
    Min = 50, Max = 500,
    Default = 75,
    Decimals = 0,
    Suffix = " jp",
    Callback = function(v)
        Movement:SetJumpValue(v)
        Bridge.MoveJump.value = v
    end
})

-- Fine tune (default 75, up to 150)
JumpSec:Slider({
    Name = "Fine Tune (50-150)",
    Flag = "move_jump_value_fine",
    Min = 50, Max = 150,
    Default = 75,
    Decimals = 1,
    Suffix = " jp",
    Callback = function(v)
        Movement:SetJumpValue(v)
        Bridge.MoveJump.value = v
        if Library.SetFlags["move_jump_value"] then
            Library.SetFlags["move_jump_value"](v)
        end
    end
})

JumpSec:Button({Name = "Preset 50", Callback = function()
    Movement:SetJumpValue(50); Bridge.MoveJump.value = 50
    if Library.SetFlags["move_jump_value"] then Library.SetFlags["move_jump_value"](50) end
end})
JumpSec:Button({Name = "Preset 75 (Default)", Callback = function()
    Movement:SetJumpValue(75); Bridge.MoveJump.value = 75
    if Library.SetFlags["move_jump_value"] then Library.SetFlags["move_jump_value"](75) end
end})
JumpSec:Button({Name = "Preset 150", Callback = function()
    Movement:SetJumpValue(150); Bridge.MoveJump.value = 150
    if Library.SetFlags["move_jump_value"] then Library.SetFlags["move_jump_value"](150) end
end})

JumpSec:Label({Name = "Jump Hotkey", Alignment = "Left"}):Keybind({
    Name = "Toggle Jump", Flag = "move_jump_keybind",
    Default = Enum.KeyCode.RightControl, Mode = "Toggle",
    Callback = function(toggled)
        if toggled then
            local ns = not Bridge.MoveJump.enabled
            Movement:SetJumpEnabled(ns)
            Bridge.MoveJump.enabled = ns
            if Library.SetFlags["move_jump_enabled"] then Library.SetFlags["move_jump_enabled"](ns) end
        end
    end
})

JumpSec:Divider()

-- Live readout of the real values
local StatusBox = JumpSec:Textbox({
    Name = "Current Status", Flag = "move_status_display",
    Placeholder = "Reading...", Default = "",
    Callback = function() end,
})

task.spawn(function()
    local lp = game:GetService("Players").LocalPlayer
    while Library and task.wait(0.3) do
        local ok, char = pcall(function() return lp.Character end)
        local hum = ok and char and char:FindFirstChildOfClass("Humanoid") or nil
        if hum then
            local sp = math.floor(hum.WalkSpeed + 0.5)
            local jp = math.floor(((hum.UseJumpPower and hum.JumpPower) or hum.JumpHeight) + 0.5)
            local txt = "Speed " .. sp .. " | Jump " .. jp
            if StatusBox and StatusBox.Set and StatusBox.Value ~= txt then
                StatusBox:Set(txt)
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
--  Infinite Stamina UI（追加到 Movement 页面）
-- ═══════════════════════════════════════════════════════════
local StaminaSec = MoveTab:Section({Name = "Infinite Stamina", Side = 1})

StaminaSec:Toggle({
    Name = "Infinite Stamina", Flag = "CAT_PL_InfStamina", Default = false,
    Callback = function(Value)
        pcall(function()
            InfiniteStamina.SetEnabled(Value)
        end)
        if Library and Library.Notification then
            Library:Notification(
                "Infinite Stamina " .. (Value and "Enabled" or "Disabled"),
                2,
                Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80)
            )
        end
    end
}):Keybind({
    Name = "Stamina Hotkey", Flag = "CAT_PL_InfStamina_KB",
    Default = Enum.KeyCode.H, Mode = "Toggle",
    Callback = function(v)
        if v then
            if Library and Library.SetFlags and Library.SetFlags["CAT_PL_InfStamina"] then
                Library.SetFlags["CAT_PL_InfStamina"](not InfiniteStamina.IsEnabled())
            end
        end
    end
})

-- ═══════════════════════════════════════════════════════════
--  Aimbot + No Recoil 功能模块
--   ★ Aimbot：死亡 / FF / 倒地检测 + 准星最近优先
--   ★ Aimbot：仅总开关带快捷键
--   ★ No Recoil：完整原版功能 + FPS 优化 + 强度可调
-- ═══════════════════════════════════════════════════════════

-- ★ Slider NaN 补丁（防重复包装）
if not Library.__AimbotSliderPatched then
    Library.__AimbotSliderPatched = true
    local _origSlider = Library.Sections.Slider
    Library.Sections.Slider = function(self, Data)
        Data = Data or {}
        local d = Data.Decimals or Data.decimals
        if type(d) ~= "number" or d <= 0 then
            Data.Decimals = 1
        end
        return _origSlider(self, Data)
    end
end

-- ═══════════════════════════════════════════════════════════
--  Aimbot 功能
-- ═══════════════════════════════════════════════════════════
local Aimbot = (function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local Workspace   = game:GetService("Workspace")
    local UIS         = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer

    local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

    local BIND_NAME = "AimbotCamera_RenderHook"
    pcall(function() RunService:UnbindFromRenderStep(BIND_NAME) end)

    local function getGuiParent()
        local ok, hui = pcall(function() return gethui() end)
        if ok and hui then return hui end
        local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
        if ok2 and cg then return cg end
        local ok3, pg = pcall(function()
            return LocalPlayer:FindFirstChildOfClass("PlayerGui")
        end)
        if ok3 and pg then return pg end
        return nil
    end

    local mod = {
        Enabled    = false,
        AutoMode   = true,
        KeyHeld    = false,

        OuterFOV   = 200,
        InnerFOV   = 50,
        Smoothness = 0.30,
        Prediction = 0.10,
        MaxRange   = 300,

        WallCheck       = false,
        TeamCheck       = true,
        AutoSnap        = false,
        VisualCheck     = false,

        DeathCheck      = true,
        FFCheck         = true,
        DownCheck       = false,

        ShowOuterFOV    = true,
        ShowInnerFOV    = true,

        UseBlacklist    = false,
        IgnoreWhitelist = true,

        Target     = nil,
        Destroyed  = false,
    }

    if IsMobile then mod.AutoMode = true end

    local connections = {}
    local function track(conn)
        if conn then table.insert(connections, conn) end
        return conn
    end

    local function getStatus(name)
        local ok, status = pcall(function()
            local esp
            local ok1, e1 = pcall(function() return ESP end)
            if ok1 and e1 and e1.player_status then
                esp = e1
            else
                local env = getgenv()
                if env and env.ESP and env.ESP.player_status then
                    esp = env.ESP
                end
            end
            if not esp then return nil end
            return esp.player_status[name]
        end)
        if ok then return status end
        return nil
    end

    local touchCount = 0
    local isTouching = false
    track(UIS.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            touchCount = touchCount + 1
            isTouching = true
        end
    end))
    track(UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            touchCount = math.max(0, touchCount - 1)
            if touchCount == 0 then isTouching = false end
        end
    end))

    local function fovScale()
        if not IsMobile then return 1 end
        local cam = Workspace.CurrentCamera
        if not cam then return 1 end
        local vp = cam.ViewportSize
        if not vp or vp.Y <= 0 then return 1 end
        return math.clamp(vp.Y / 900, 0.6, 1.1)
    end

    local guiParent = getGuiParent()
    if guiParent then
        pcall(function()
            local old = guiParent:FindFirstChild("AimbotFOVGui")
            if old then old:Destroy() end
        end)
    end

    local fovGui = Instance.new("ScreenGui")
    fovGui.Name           = "AimbotFOVGui"
    fovGui.ResetOnSpawn   = false
    fovGui.IgnoreGuiInset = true
    fovGui.DisplayOrder   = 100
    if guiParent then
        pcall(function() fovGui.Parent = guiParent end)
    end

    local function makeRing(transparency)
        local f = Instance.new("Frame")
        f.AnchorPoint            = Vector2.new(0.5, 0.5)
        f.Position               = UDim2.new(0.5, 0, 0.5, 0)
        f.Size                   = UDim2.fromOffset(0, 0)
        f.BackgroundTransparency = 1
        f.BorderSizePixel        = 0
        f.Visible                = false
        f.ZIndex                 = 999
        f.Parent                 = fovGui
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0); c.Parent = f
        local s = Instance.new("UIStroke")
        s.Color           = Color3.fromRGB(255, 255, 255)
        s.Thickness       = 1
        s.Transparency    = transparency
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent          = f
        return f
    end

    local outerRing = makeRing(0.25)
    local innerRing = makeRing(0.65)

    local function redrawFOV()
        if not fovGui or not fovGui.Parent then
            mod.Enabled = false
            return
        end
        if not mod.Enabled then
            outerRing.Visible = false
            innerRing.Visible = false
            return
        end

        local scale = fovScale()
        outerRing.Size = UDim2.fromOffset(mod.OuterFOV * 2 * scale, mod.OuterFOV * 2 * scale)
        innerRing.Size = UDim2.fromOffset(mod.InnerFOV * 2 * scale, mod.InnerFOV * 2 * scale)

        outerRing.Visible = mod.ShowOuterFOV
        innerRing.Visible = mod.ShowInnerFOV
    end

    local BODY_PARTS = {
        "Head",
        "UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot",
    }

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local function isVisible(targetPart, cam)
        if not targetPart or not targetPart.Parent then return false end
        if not cam then return false end

        local filter = { cam }
        if LocalPlayer.Character then
            table.insert(filter, LocalPlayer.Character)
        end
        rayParams.FilterDescendantsInstances = filter

        local origin = cam.CFrame.Position
        local dir    = targetPart.Position - origin

        local ok, result = pcall(function()
            return Workspace:Raycast(origin, dir, rayParams)
        end)
        if not ok then return true end

        return result == nil or result.Instance:IsDescendantOf(targetPart.Parent)
    end

    local function getVisibleParts(char, cam)
        if not char or not cam then return nil end

        local filter = { cam }
        if LocalPlayer.Character then
            table.insert(filter, LocalPlayer.Character)
        end
        rayParams.FilterDescendantsInstances = filter

        local origin = cam.CFrame.Position
        local visible = {}

        for _, partName in ipairs(BODY_PARTS) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                local dir = part.Position - origin
                local ok, result = pcall(function()
                    return Workspace:Raycast(origin, dir, rayParams)
                end)
                if ok then
                    local hit = result and result.Instance
                    if not hit or hit:IsDescendantOf(char) then
                        table.insert(visible, part)
                    end
                end
            end
        end

        if #visible == 0 then return nil end
        return visible
    end

    local function getEdgeFromParts(parts, cam, center)
        local fovRad = math.rad(cam.FieldOfView)
        local vpH    = cam.ViewportSize.Y
        local focal  = vpH / (2 * math.tan(fovRad * 0.5))
        if focal ~= focal or focal <= 0 then return nil end

        local nearestEdge = math.huge
        local camPos = cam.CFrame.Position

        for _, part in ipairs(parts) do
            if part and part.Parent and part:IsA("BasePart") then
                local ok, sp, onScreen = pcall(function()
                    return cam:WorldToViewportPoint(part.Position)
                end)
                if ok and onScreen and sp.Z > 0 then
                    local dx = sp.X - center.X
                    local dy = sp.Y - center.Y
                    local d  = math.sqrt(dx * dx + dy * dy)
                    if d == d and d ~= math.huge then
                        local dist3D = (part.Position - camPos).Magnitude
                        if dist3D == dist3D and dist3D > 0.1 then
                            local realRadius = math.max(part.Size.X, part.Size.Y, part.Size.Z) * 0.5
                            local screenRadius = (realRadius * focal) / dist3D
                            local edge = d - screenRadius
                            if edge == edge and edge < nearestEdge then
                                nearestEdge = edge
                            end
                        end
                    end
                end
            end
        end

        if nearestEdge == math.huge then return nil end
        return nearestEdge
    end

    local function getBodyInfo(char, cam, center)
        local parts = {}
        for _, partName in ipairs(BODY_PARTS) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end

        local edge = getEdgeFromParts(parts, cam, center)
        if not edge then return nil end

        local aimPart = char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso")
            or char:FindFirstChild("HumanoidRootPart")
        if not aimPart then return nil end

        return { edge = edge, aimPart = aimPart }
    end

    local function getCenterDistance(parts, cam, center)
        local nearest = math.huge
        for _, part in ipairs(parts) do
            if part and part.Parent then
                local ok, sp, onScreen = pcall(function()
                    return cam:WorldToViewportPoint(part.Position)
                end)
                if ok and onScreen and sp.Z > 0 then
                    local dx = sp.X - center.X
                    local dy = sp.Y - center.Y
                    local d  = math.sqrt(dx * dx + dy * dy)
                    if d == d and d < nearest then nearest = d end
                end
            end
        end
        return nearest
    end

    local function findTarget(cam)
        local vp     = cam.ViewportSize
        local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
        local best, bestCenterDist = nil, math.huge
        local innerHit = false

        local scale    = fovScale()
        local outerEff = mod.OuterFOV * scale
        local innerEff = mod.InnerFOV * scale

        local downThreshold = mod.DownCheck and 16 or 0

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            if mod.TeamCheck and plr.Team and plr.Team == LocalPlayer.Team then continue end

            local status = getStatus(plr.Name)
            if mod.UseBlacklist    and status ~= "Blacklist" then continue end
            if mod.IgnoreWhitelist and status == "Whitelist" then continue end

            local char = plr.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then continue end

            if mod.DeathCheck and hum.Health <= 0 then continue end
            if mod.FFCheck and char:FindFirstChildOfClass("ForceField") then continue end
            if hum.Health <= downThreshold then continue end

            local edge, aimPool

            if mod.VisualCheck then
                local visibleParts = getVisibleParts(char, cam)
                if not visibleParts then continue end
                edge = getEdgeFromParts(visibleParts, cam, center)
                if not edge then continue end
                aimPool = visibleParts
            else
                local ok, body = pcall(getBodyInfo, char, cam, center)
                if not ok or not body then continue end
                edge = body.edge
                aimPool = nil
            end

            if edge <= innerEff then
                innerHit = true
                continue
            end

            if edge > outerEff then continue end

            local refPart
            if aimPool then
                refPart = aimPool[1]
            else
                refPart = char:FindFirstChild("UpperTorso")
                    or char:FindFirstChild("Torso")
                    or char:FindFirstChild("HumanoidRootPart")
            end
            if not refPart then continue end

            local dist = (refPart.Position - cam.CFrame.Position).Magnitude
            if dist > mod.MaxRange then continue end

            if mod.WallCheck and not mod.VisualCheck then
                if not isVisible(refPart, cam) then continue end
            end

            local centerDist
            if aimPool then
                centerDist = getCenterDistance(aimPool, cam, center)
            else
                local bodyPart = char:FindFirstChild("UpperTorso")
                    or char:FindFirstChild("Torso")
                    or char:FindFirstChild("HumanoidRootPart")
                if bodyPart then
                    local ok, sp, onScreen = pcall(function()
                        return cam:WorldToViewportPoint(bodyPart.Position)
                    end)
                    if ok and onScreen and sp.Z > 0 then
                        local dx = sp.X - center.X
                        local dy = sp.Y - center.Y
                        centerDist = math.sqrt(dx * dx + dy * dy)
                    end
                end
            end

            if not centerDist or centerDist == math.huge then continue end

            if centerDist < bestCenterDist then
                bestCenterDist = centerDist
                best = {
                    player   = plr,
                    edgeDist = edge,
                    distance = dist,
                    pool     = aimPool,
                }
            end
        end

        if innerHit then
            return nil
        end

        if best then
            if best.pool and #best.pool > 0 then
                best.part = best.pool[math.random(1, #best.pool)]
            else
                local char = best.player.Character
                best.part = char and (
                    char:FindFirstChild("UpperTorso")
                    or char:FindFirstChild("Torso")
                    or char:FindFirstChild("HumanoidRootPart")
                ) or nil
            end
            if not best.part or not best.part.Parent then
                return nil
            end
        end

        return best
    end

    track(RunService:BindToRenderStep(BIND_NAME, Enum.RenderPriority.Camera.Value + 1, function(dt)
        pcall(function()
            if mod.Destroyed then return end
            if not mod.Enabled then mod.Target = nil; return end

            redrawFOV()

            if IsMobile and isTouching then mod.Target = nil; return end

            local shouldAim = mod.AutoMode or mod.KeyHeld
            if not shouldAim then mod.Target = nil; return end

            local cam = Workspace.CurrentCamera
            if not cam then return end

            local target = findTarget(cam)
            mod.Target = target
            if not target then return end

            local origin = cam.CFrame.Position
            local aimPart = target.part
            if not aimPart or not aimPart.Parent then return end

            local aimPos = aimPart.Position
            if mod.Prediction > 0 then
                local vel = aimPart.AssemblyLinearVelocity
                aimPos = aimPos + vel * mod.Prediction
            end

            if aimPos.X ~= aimPos.X or aimPos.Y ~= aimPos.Y or aimPos.Z ~= aimPos.Z then return end

            local diff = aimPos - origin
            if diff.Magnitude < 0.01 or diff.Magnitude ~= diff.Magnitude then return end

            local desired = CFrame.lookAt(origin, aimPos)

            if mod.AutoSnap then
                cam.CFrame = desired
                return
            end

            local s = math.clamp(mod.Smoothness, 0, 1)
            local alphaBase = 0.005 + (s ^ 4) * 0.995
            local alpha = 1 - (1 - alphaBase) ^ math.clamp(dt * 60, 0.1, 3)
            if alpha ~= alpha then return end

            cam.CFrame = cam.CFrame:Lerp(desired, alpha)
        end)
    end))

    local function isNum(v)
        return type(v) == "number" and v == v
           and v ~= math.huge and v ~= -math.huge
    end

    function mod:SetEnabled(v)  self.Enabled  = v and true or false; redrawFOV() end
    function mod:SetAutoMode(v) self.AutoMode = v and true or false end
    function mod:SetKeyHeld(v)  self.KeyHeld  = v and true or false end

    function mod:SetOuterFOV(v)
        if not isNum(v) then return end
        self.OuterFOV = math.clamp(v, 20, 1000)
        if self.InnerFOV >= self.OuterFOV then
            self.InnerFOV = math.max(0, self.OuterFOV - 20)
        end
        redrawFOV()
    end

    function mod:SetInnerFOV(v)
        if not isNum(v) then return end
        self.InnerFOV = math.clamp(v, 0, math.max(0, self.OuterFOV - 10))
        redrawFOV()
    end

    function mod:SetSmoothness(v)      if isNum(v) then self.Smoothness      = math.clamp(v, 0, 1) end end
    function mod:SetPrediction(v)      if isNum(v) then self.Prediction      = math.clamp(v, 0, 1) end end
    function mod:SetMaxRange(v)        if isNum(v) then self.MaxRange        = math.clamp(v, 10, 5000) end end
    function mod:SetWallCheck(v)       self.WallCheck       = v and true or false end
    function mod:SetTeamCheck(v)       self.TeamCheck       = v and true or false end
    function mod:SetAutoSnap(v)        self.AutoSnap        = v and true or false end
    function mod:SetVisualCheck(v)     self.VisualCheck     = v and true or false end
    function mod:SetDeathCheck(v)      self.DeathCheck      = v and true or false end
    function mod:SetFFCheck(v)         self.FFCheck         = v and true or false end
    function mod:SetDownCheck(v)       self.DownCheck       = v and true or false end
    function mod:SetUseBlacklist(v)    self.UseBlacklist    = v and true or false end
    function mod:SetIgnoreWhitelist(v) self.IgnoreWhitelist = v and true or false end
    function mod:SetShowOuterFOV(v)    self.ShowOuterFOV    = v and true or false; redrawFOV() end
    function mod:SetShowInnerFOV(v)    self.ShowInnerFOV    = v and true or false; redrawFOV() end

    function mod:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        self.Enabled = false

        for _, c in ipairs(connections) do
            pcall(function() c:Disconnect() end)
        end
        connections = {}

        pcall(function() RunService:UnbindFromRenderStep(BIND_NAME) end)
        pcall(function() if fovGui then fovGui:Destroy() end end)
    end

    mod.IsMobile = IsMobile
    return mod
end)()

getgenv().Aimbot = Aimbot

-- ═══════════════════════════════════════════════════════════
--  No Recoil 功能（集成到 Aimbot 模块区）
--   ★ 原版功能完全保留：Recoil / CameraRecoiling / AngleX/Y/Z / Spread
--   ★ 强度可调：0 = 完全无后座，1 = 原始后座
--   ★ FPS 优化：防抖 + 局部变量 + Heartbeat 兜底
-- ═══════════════════════════════════════════════════════════
local NoRecoil = (function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local NR = {
        Enabled        = false,
        Conns          = {},
        OrigVals       = {},
        Cache          = {},
        RecoilVal      = 0,

        _lastApplyTick = 0,
        _charConn      = nil,
        _debounceToken = 0,
    }

    local function NR_CacheWeapons()
        NR.Cache = {}
        local cache    = NR.Cache
        local origVals = NR.OrigVals
        local count    = 0

        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "EquipTime") then
                count = count + 1
                cache[count] = v

                if not origVals[v] then
                    origVals[v] = {
                        Recoil = v.Recoil,
                        CameraRecoilingEnabled = v.CameraRecoilingEnabled,
                        AngleX_Min = v.AngleX_Min, AngleX_Max = v.AngleX_Max,
                        AngleY_Min = v.AngleY_Min, AngleY_Max = v.AngleY_Max,
                        AngleZ_Min = v.AngleZ_Min, AngleZ_Max = v.AngleZ_Max,
                        Spread     = v.Spread,
                    }
                end
            end
        end
    end

    local function NR_Apply()
        local cache = NR.Cache
        local rv    = NR.RecoilVal
        local n     = #cache

        for i = 1, n do
            local w = cache[i]
            w.Recoil = rv
            w.CameraRecoilingEnabled = false
            w.AngleX_Min = 0; w.AngleX_Max = 0
            w.AngleY_Min = 0; w.AngleY_Max = 0
            w.AngleZ_Min = 0; w.AngleZ_Max = 0
            w.Spread = 0
        end

        NR._lastApplyTick = tick()
    end

    local function NR_Reset()
        for w, val in pairs(NR.OrigVals) do
            if w then
                pcall(function()
                    w.Recoil = val.Recoil
                    w.CameraRecoilingEnabled = val.CameraRecoilingEnabled
                    w.AngleX_Min = val.AngleX_Min; w.AngleX_Max = val.AngleX_Max
                    w.AngleY_Min = val.AngleY_Min; w.AngleY_Max = val.AngleY_Max
                    w.AngleZ_Min = val.AngleZ_Min; w.AngleZ_Max = val.AngleZ_Max
                    w.Spread     = val.Spread
                end)
            end
        end
    end

    local function NR_ScheduleRefresh(delay)
        NR._debounceToken = NR._debounceToken + 1
        local token = NR._debounceToken

        task.delay(delay or 0.1, function()
            if token ~= NR._debounceToken then return end
            if not NR.Enabled then return end
            NR_CacheWeapons()
            NR_Apply()
        end)
    end

    local function NR_OnChar(char)
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Tool") then
                NR_ScheduleRefresh(0.1)
                break
            end
        end

        table.insert(NR.Conns, char.ChildAdded:Connect(function(c)
            if c:IsA("Tool") then
                NR_ScheduleRefresh(0.1)
            end
        end))

        local hum = char:WaitForChild("Humanoid", 2)
        if hum then
            table.insert(NR.Conns, hum.Died:Connect(function()
                if NR.Enabled then
                    task.delay(1.5, function()
                        if NR.Enabled then
                            NR_CacheWeapons()
                            NR_Apply()
                        end
                    end)
                end
            end))
        end
    end

    local function NR_Enable()
        if NR.Enabled then return end
        NR.Enabled = true

        NR_CacheWeapons()
        NR_Apply()

        if NR._charConn then pcall(function() NR._charConn:Disconnect() end) end
        NR._charConn = LocalPlayer.CharacterAdded:Connect(NR_OnChar)
        if LocalPlayer.Character then NR_OnChar(LocalPlayer.Character) end
    end

    local function NR_Disable()
        if not NR.Enabled then return end
        NR.Enabled = false

        NR_Reset()

        for _, c in ipairs(NR.Conns) do
            pcall(function() c:Disconnect() end)
        end
        NR.Conns = {}

        if NR._charConn then
            pcall(function() NR._charConn:Disconnect() end)
            NR._charConn = nil
        end
    end

    RunService.Heartbeat:Connect(function()
        if not NR.Enabled then return end
        if #NR.Cache == 0 and tick() - NR._lastApplyTick > 1 then
            NR_CacheWeapons()
            NR_Apply()
        end
    end)

    local API = {
        Enable    = NR_Enable,
        Disable   = NR_Disable,
        Toggle    = function(v)
            if v == nil then v = not NR.Enabled end
            if v then NR_Enable() else NR_Disable() end
            return NR.Enabled
        end,
        IsEnabled = function() return NR.Enabled end,
        SetRecoil = function(v)
            NR.RecoilVal = math.clamp(tonumber(v) or 0, 0, 1)
            if NR.Enabled then NR_Apply() end
        end,
        GetRecoil = function() return NR.RecoilVal end,
        Reapply   = function()
            NR_CacheWeapons()
            if NR.Enabled then NR_Apply() end
        end,
    }

    return API
end)()

getgenv().NoRecoil = NoRecoil

-- ═══════════════════════════════════════════════════════════
--  Aimbot + No Recoil UI（整合在同一个 Aimbot 页面）
-- ═══════════════════════════════════════════════════════════
local AimTab  = Window:Page({Name = "Aimbot", Columns = 2, Subtabs = false})
local AimMain = AimTab:Section({Name = "Aimbot Control", Side = 1})
local AimTune = AimTab:Section({Name = "Fine Tune", Side = 2})
local AimKeys = AimTab:Section({Name = "Hotkeys", Side = 2})

-- ─── 主开关 ───
AimMain:Toggle({
    Name = "Enable Aimbot", Flag = "aim_on", Default = false,
    Callback = function(v)
        Aimbot:SetEnabled(v)
        Library:Notification("Aimbot " .. (v and "Enabled" or "Disabled"), 2,
            v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80))
    end
})

if Aimbot.IsMobile then
    AimMain:Toggle({
        Name = "Full Auto (Locked on Mobile)", Flag = "aim_auto", Default = true,
        Callback = function(v)
            if Library.SetFlags["aim_auto"] then
                Library.SetFlags["aim_auto"](true)
            end
            Aimbot:SetAutoMode(true)
            Library:Notification("Mobile: Full Auto is forced ON", 2,
                Color3.fromRGB(255, 200, 100))
        end
    })
else
    AimMain:Toggle({
        Name = "Full Auto (No Key Needed)", Flag = "aim_auto", Default = true,
        Callback = function(v) Aimbot:SetAutoMode(v) end
    })
end

AimMain:Toggle({
    Name = "Show Outer FOV Circle", Flag = "aim_show_outer", Default = true,
    Callback = function(v) Aimbot:SetShowOuterFOV(v) end
})

AimMain:Toggle({
    Name = "Show Inner FOV Circle", Flag = "aim_show_inner", Default = true,
    Callback = function(v) Aimbot:SetShowInnerFOV(v) end
})

AimMain:Toggle({
    Name = "Auto Snap (Instant)", Flag = "aim_snap", Default = false,
    Callback = function(v) Aimbot:SetAutoSnap(v) end
})

AimMain:Divider()

-- ─── 目标筛选 ───
AimMain:Toggle({
    Name = "Visual Check (Only Aim Visible Parts)", Flag = "aim_visual", Default = false,
    Callback = function(v)
        Aimbot:SetVisualCheck(v)
        Library:Notification("Visual Check: " .. (v and "ON" or "OFF"), 2,
            v and Color3.fromRGB(120, 255, 180) or Color3.fromRGB(180, 180, 180))
    end
})

AimMain:Toggle({
    Name = "Wall Check", Flag = "aim_wall", Default = false,
    Callback = function(v) Aimbot:SetWallCheck(v) end
})

AimMain:Toggle({
    Name = "Team Check", Flag = "aim_team", Default = true,
    Callback = function(v) Aimbot:SetTeamCheck(v) end
})

AimMain:Toggle({
    Name = "Death Check (Skip Dead)", Flag = "aim_death", Default = true,
    Callback = function(v)
        Aimbot:SetDeathCheck(v)
        Library:Notification("Death Check: " .. (v and "ON" or "OFF"), 2,
            v and Color3.fromRGB(255, 180, 120) or Color3.fromRGB(180, 180, 180))
    end
})

AimMain:Toggle({
    Name = "FF Check (Skip ForceField)", Flag = "aim_ff", Default = true,
    Callback = function(v)
        Aimbot:SetFFCheck(v)
        Library:Notification("FF Check: " .. (v and "ON" or "OFF"), 2,
            v and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(180, 180, 180))
    end
})

AimMain:Toggle({
    Name = "Down Check (HP < 16)", Flag = "aim_down", Default = false,
    Callback = function(v)
        Aimbot:SetDownCheck(v)
        Library:Notification("Down Check: " .. (v and "ON (HP < 16)" or "OFF"), 2,
            v and Color3.fromRGB(255, 180, 120) or Color3.fromRGB(180, 180, 180))
    end
})

AimMain:Divider()

AimMain:Toggle({
    Name = "Only Aim Blacklist (ESP List)", Flag = "aim_use_bl", Default = false,
    Callback = function(v)
        Aimbot:SetUseBlacklist(v)
        Library:Notification("Only Aim Blacklist: " .. (v and "ON" or "OFF"), 2,
            v and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(180, 180, 180))
    end
})

AimMain:Toggle({
    Name = "Ignore Whitelist (ESP List)", Flag = "aim_ignore_wl", Default = true,
    Callback = function(v)
        Aimbot:SetIgnoreWhitelist(v)
        Library:Notification("Ignore Whitelist: " .. (v and "ON" or "OFF"), 2,
            v and Color3.fromRGB(120, 255, 140) or Color3.fromRGB(180, 180, 180))
    end
})

-- ─── Fine Tune（数值）───
AimTune:Slider({
    Name = "Outer FOV (Auto-Aim Zone)", Flag = "aim_fov_outer",
    Min = 20, Max = 800, Default = 200, Decimals = 1, Suffix = " px",
    Callback = function(v) Aimbot:SetOuterFOV(v) end
})

AimTune:Slider({
    Name = "Inner FOV (Manual Zone)", Flag = "aim_fov_inner",
    Min = 0, Max = 400, Default = 50, Decimals = 1, Suffix = " px",
    Callback = function(v) Aimbot:SetInnerFOV(v) end
})

AimTune:Slider({
    Name = "Smoothness (0=Silky / 1=Hard Lock)", Flag = "aim_smooth",
    Min = 0, Max = 1, Default = 0.3, Decimals = 0.01,
    Callback = function(v) Aimbot:SetSmoothness(v) end
})

AimTune:Slider({
    Name = "Prediction", Flag = "aim_pred",
    Min = 0, Max = 0.5, Default = 0.1, Decimals = 0.02,
    Callback = function(v) Aimbot:SetPrediction(v) end
})

AimTune:Slider({
    Name = "Max Range", Flag = "aim_range",
    Min = 10, Max = 2000, Default = 300, Decimals = 1, Suffix = " m",
    Callback = function(v) Aimbot:SetMaxRange(v) end
})

AimTune:Divider()

AimTune:Button({Name = "Silky Preset (Recommended)", Callback = function()
    Aimbot:SetSmoothness(0.25)
    Aimbot:SetAutoSnap(false)
    if Library.SetFlags["aim_smooth"] then Library.SetFlags["aim_smooth"](0.25) end
    if Library.SetFlags["aim_snap"]   then Library.SetFlags["aim_snap"](false) end
    Library:Notification("Silky preset applied", 2, Color3.fromRGB(120, 200, 255))
end})

AimTune:Button({Name = "Hard Lock Preset", Callback = function()
    Aimbot:SetSmoothness(1)
    Aimbot:SetAutoSnap(true)
    if Library.SetFlags["aim_smooth"] then Library.SetFlags["aim_smooth"](1) end
    if Library.SetFlags["aim_snap"]   then Library.SetFlags["aim_snap"](true) end
    Library:Notification("Hard Lock preset applied", 2, Color3.fromRGB(0, 255, 120))
end})

-- ═══════════════════════════════════════════════════════════
--  Aimbot 快捷键（仅总开关 + 原手动触发键）
-- ═══════════════════════════════════════════════════════════
AimKeys:Label({Name = "Toggle Aimbot", Alignment = "Left"}):Keybind({
    Name = "Toggle Key", Flag = "aim_key_toggle",
    Default = Enum.KeyCode.RightControl, Mode = "Toggle",
    Callback = function(toggled)
        if not toggled then return end
        local ns = not Aimbot.Enabled
        Aimbot:SetEnabled(ns)
        if Library.SetFlags["aim_on"] then Library.SetFlags["aim_on"](ns) end
        Library:Notification("Aimbot " .. (ns and "Enabled" or "Disabled"), 2,
            ns and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80))
    end
})

if not Aimbot.IsMobile then
    AimKeys:Label({Name = "Manual Trigger (Hold)", Alignment = "Left"}):Keybind({
        Name = "Trigger Key", Flag = "aim_key",
        Default = Enum.KeyCode.E, Mode = "Hold",
        Callback = function(toggled) Aimbot:SetKeyHeld(toggled) end
    })
end

-- ═══════════════════════════════════════════════════════════
--  No Recoil UI（作为 Aimbot 页面的一部分）
-- ═══════════════════════════════════════════════════════════
local NRSec     = AimTab:Section({Name = "No Recoil",      Side = 1})
local NRTuneSec = AimTab:Section({Name = "No Recoil Tune", Side = 2})
local NRKeySec  = AimTab:Section({Name = "No Recoil Key",  Side = 2})

-- ─── No Recoil 主开关 ───
NRSec:Toggle({
    Name = "Enable No Recoil", Flag = "nr_enabled", Default = false,
    Callback = function(v)
        NoRecoil.Toggle(v)
        Library:Notification(
            "No Recoil " .. (v and "Enabled" or "Disabled"), 2,
            v and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80)
        )
    end
})

NRSec:Divider()

NRSec:Button({Name = "Reapply Now", Callback = function()
    NoRecoil.Reapply()
    Library:Notification("No Recoil reapplied", 2, Color3.fromRGB(120, 200, 255))
end})

NRSec:Button({Name = "Disable & Restore Original", Callback = function()
    NoRecoil.Disable()
    if Library.SetFlags["nr_enabled"] then
        Library.SetFlags["nr_enabled"](false)
    end
    Library:Notification("No Recoil Disabled & Weapon Reset", 2,
        Color3.fromRGB(255, 200, 100))
end})

NRSec:Divider()
NRSec:Label({Name = "chz.lol", Alignment = "Left"})

-- ─── No Recoil 强度调节 ───
NRTuneSec:Slider({
    Name    = "Recoil Intensity",
    Flag    = "nr_recoil",
    Min     = 0, Max = 1, Default = 0, Decimals = 0.01, Suffix = "",
    Callback = function(v) NoRecoil.SetRecoil(v) end
})

NRTuneSec:Divider()

NRTuneSec:Button({Name = "Full No Recoil (0.00)", Callback = function()
    NoRecoil.SetRecoil(0)
    if Library.SetFlags["nr_recoil"] then Library.SetFlags["nr_recoil"](0) end
    Library:Notification("Recoil = 0.00 (Full No Recoil)", 2,
        Color3.fromRGB(0, 255, 120))
end})

NRTuneSec:Button({Name = "Half Recoil (0.50)", Callback = function()
    NoRecoil.SetRecoil(0.5)
    if Library.SetFlags["nr_recoil"] then Library.SetFlags["nr_recoil"](0.5) end
    Library:Notification("Recoil = 0.50 (Half)", 2,
        Color3.fromRGB(255, 200, 100))
end})

NRTuneSec:Button({Name = "Original Recoil (1.00)", Callback = function()
    NoRecoil.SetRecoil(1)
    if Library.SetFlags["nr_recoil"] then Library.SetFlags["nr_recoil"](1) end
    Library:Notification("Recoil = 1.00 (Original)", 2,
        Color3.fromRGB(255, 80, 80))
end})

-- ─── No Recoil 快捷键（仅总开关）───
NRKeySec:Label({Name = "Toggle No Recoil", Alignment = "Left"}):Keybind({
    Name    = "Toggle Key", Flag = "nr_key_toggle",
    Default = Enum.KeyCode.RightBracket, Mode = "Toggle",
    Callback = function(toggled)
        if not toggled then return end
        local ns = not NoRecoil.IsEnabled()
        NoRecoil.Toggle(ns)
        if Library.SetFlags["nr_enabled"] then
            Library.SetFlags["nr_enabled"](ns)
        end
        Library:Notification(
            "No Recoil " .. (ns and "Enabled" or "Disabled"), 2,
            ns and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 80, 80)
        )
    end
})

-- ============================================================
-- == Ragebot UI
-- ============================================================
do -- Ragebot page
    local Page = Window:Page({Name = "Combat", SubPages = false})

    local s1 = Page:Section({Name = "Settings", Side = 1})
    s1:Toggle({Name = "Enable", Flag = "CAT_Enable_25", Callback = function(v) RB_State = v end}):Keybind({Flag = "CAT_Enable_25_KB", Mode = "Toggle", Callback = function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_Enable_25"] then Library.SetFlags["CAT_Enable_25"](v) end end})
    s1:Toggle({Name = "Rapid fire", Flag = "CAT_Rapid_fire_26", Callback = function(v) RF_State = v end}):Keybind({Flag = "CAT_Rapid_fire_26_KB", Mode = "Toggle", Callback = function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_Rapid_fire_26"] then Library.SetFlags["CAT_Rapid_fire_26"](v) end end})
    s1:Toggle({Name = "Down Check", Flag = "CAT_Down_Check_28", Callback = function(v) DownCheck = v end}):Keybind({Flag = "CAT_Down_Check_28_KB", Mode = "Toggle", Callback = function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_Down_Check_28"] then Library.SetFlags["CAT_Down_Check_28"](v) end end})
    s1:Slider({Name = "Max Cache",     Flag = "CAT_Max_Cache_30",     Min = 0.01, Max = 45, Default = 0.5,   Decimals = 0.01, Callback = function(v) WB.Threshold = v end})
    s1:Slider({Name = "Origin Radius", Flag = "CAT_Origin_Radius_31", Min = 0.1,  Max = 20, Default = 18.50, Decimals = 0.01, Callback = function(v) Origin_Radius = v end})
    s1:Slider({Name = "Origin Scans",  Flag = "CAT_Origin_Scans_32",  Min = 1,    Max = 50, Default = 24,                    Callback = function(v) Origin_Scans = math.floor(v) end})
    s1:Slider({Name = "Scan Rate",     Flag = "CAT_Scan_Rate",        Min = 1,    Max = 60, Default = 14,                    Callback = function(v) ScanRate = math.floor(v) end})
    s1:Slider({Name = "Hit Radius",    Flag = "CAT_Hit_Radius_33",    Min = 0.1,  Max = 25, Default = 23.50, Decimals = 0.01, Callback = function(v) Hit_Radius = v end})
    s1:Slider({Name = "Hit Scans",     Flag = "CAT_Hit_Scans_34",     Min = 1,    Max = 50, Default = 24,                    Callback = function(v) Hit_Scans = math.floor(v) end})

    local s_parts = Page:Section({Name = "Hit Parts (Multi-Select)", Side = 1})
    s_parts:Dropdown({Name = "Target Parts", Flag = "CAT_Target_Parts", Multi = true, Items = {"Head","Torso","HumanoidRootPart"}, Default = {"Head","HumanoidRootPart"}, Callback = function(v) Selected_HitParts = v end})

    local s_sound = Page:Section({Name = "Muzzle Sound", Side = 1})
    s_sound:Toggle({Name = "Fire Sound1", Flag = "CAT_Muzzle_Fire_Sound1", Default = false, Callback = function(v) CustomMuzzleSound_State = v end})

    local s_fx = Page:Section({Name = "Muzzle Effects", Side = 1})
    s_fx:Toggle({Name = "Muzzle Flash 1", Flag = "CAT_Muzzle_Flash_1", Default = false, Callback = function(v) CustomMuzzleFlash_State = v end})

    local s2 = Page:Section({Name = "Target Selection", Side = 2})

    -- ★ Target Mode：Nearby / Lock（Lock = 打 ESP 黑名单）
    s2:Dropdown({
        Name = "Target Mode",
        Flag = "CAT_Target_Mode_35",
        Items = {"Nearby", "Lock (Blacklist)"},
        Default = "Nearby",
        Callback = function(v)
            if v == "Lock (Blacklist)" then
                TargetMode = "Lock"
            else
                TargetMode = "Nearby"
            end
        end
    })

    s2:Dropdown({Name = "Hit Sound", Flag = "CAT_Hit_Sound_36", Items = {"None","Rust","CODE200","Minecraft","Neverlose","Gamesense","Bonk","Bat","Laser Beam","Fatality","Bow","koch","golda","agpa1","agpa2","Bameware","Bell","Bubble","Pick","Pop","Sans","Fart","Big","Vine","Bruh","Skeet"}, Default = "None", Callback = function(v) HitSoundSelection = v end})

    local s3 = Page:Section({Name = "Bullet Tracer", Side = 2})
    local t = s3:Toggle({Name = "Enable", Flag = "CAT_Enable_38", Callback = function(v) TR.Enabled = v end})
    t:Keybind({Flag = "CAT_Enable_38_KB", Mode = "Toggle", Callback = function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_Enable_38"] then Library.SetFlags["CAT_Enable_38"](v) end end})
    t:Colorpicker({Name = "Tracer Color", Flag = "CAT_Tracer_Color_39", Default = TR.Color, Callback = function(c, a) TR.Color = c; TR.Alpha = a end})
    s3:Dropdown({Name = "Tracer Texture", Flag = "CAT_Tracer_Texture_Style", Items = {"Obelus","Lightning","DNA","Straight","Taser","Edge","Energy"}, Default = "Taser", Callback = function(v) TR.Texture = v end})
    s3:Slider({Name = "Size", Flag = "CAT_Size_40", Min = 0.1, Max = 10, Default = 1, Decimals = 0.1, Callback = function(v) TR.Size = v end})
end

-- ============================================================
-- == Misc UI
-- ============================================================
do -- Misc page
    local Page = Window:Page({Name="Misc", SubPages=false})

    local sFarm = Page:Section({Name="Farm", Side=1})
    sFarm:Toggle({Name="Auto pick up money", Flag="CAT_MC_AutoPickup", Callback=function(v) SC.APM_Enabled=v; if v then StartAutoPickUpMoney() end end}):Keybind({Flag="CAT_MC_AutoPickup_KB", Mode="Toggle", Callback=function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_MC_AutoPickup"] then Library.SetFlags["CAT_MC_AutoPickup"](v) end end})
    sFarm:Toggle({Name="Auto unlock safe", Flag="CAT_MC_AutoUnlock", Callback=function(v) SC.AUS_Enabled=v; if v then StartAutoUnlockSafe() end end}):Keybind({Flag="CAT_MC_AutoUnlock_KB", Mode="Toggle", Callback=function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_MC_AutoUnlock"] then Library.SetFlags["CAT_MC_AutoUnlock"](v) end end})
    sFarm:Toggle({Name="Fast Pick", Flag="CAT_MC_FastPick", Callback=function(v) if v then enableBypass() else disableBypass() end end}):Keybind({Flag="CAT_MC_FastPick_KB", Mode="Toggle", Callback=function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_MC_FastPick"] then Library.SetFlags["CAT_MC_FastPick"](v) end end})
    sFarm:Toggle({Name="Auto Buy Ammo", Flag="CAT_MC_AutoBuyAmmo", Callback=function(v) MC.AutoBuyAmmo=v end}):Keybind({Flag="CAT_MC_AutoBuyAmmo_KB", Mode="Toggle", Callback=function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_MC_AutoBuyAmmo"] then Library.SetFlags["CAT_MC_AutoBuyAmmo"](v) end end})

    local sSafe = Page:Section({Name="Safe Chams", Side=1})
    sSafe:Toggle({Name="Enable Safe Chams", Flag="CAT_MC_SafeChams", Default=false, Callback=function(v) SafeChamsEnabled=v; if v then StartSafeChams() end end}):Keybind({Flag="CAT_MC_SafeChams_KB", Mode="Toggle", Callback=function(v) if Library and Library.SetFlags and Library.SetFlags["CAT_MC_SafeChams"] then Library.SetFlags["CAT_MC_SafeChams"](v) end end})
end

-- ╔═══════════════════════════════════════════════════════╗
-- ║ Keybinds                                               ║
-- ╚═══════════════════════════════════════════════════════╝
local KeyTab = Window:Page({Name = "Keybinds", Columns = 2, Subtabs = false})
local KeySec = KeyTab:Section({Name = "Hotkeys", Side = 1})

KeySec:Label({Name = "Standalone Keybind Example", Alignment = "Left"}):Keybind({
    Name = "Trigger Key", Flag = "demo_keybind",
    Default = Enum.KeyCode.F, Mode = "Toggle",
    Callback = function(toggled) print("Keybind state:", toggled) end})
KeySec:Label({Name = "Standalone Colorpicker", Alignment = "Left"}):Colorpicker({
    Name = "Pick Color", Flag = "demo_color2",
    Default = Color3.fromRGB(100, 150, 255), Alpha = true,
    Callback = function(c, a) print("Color:", c, "Alpha:", a) end})

-- ╔═══════════════════════════════════════════════════════╗
-- ║ Settings page (auto-generated)                         ║
-- ╚═══════════════════════════════════════════════════════╝
Library:CreateSettingsPage(Window, Watermark, KeybindList)

Library:Init()
