local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local backup_cframe = humanoidRootPart.CFrame


local function getZombieData()

local zombiesLocal = workspace:WaitForChild("Zombies_Local")

    local data = {}
    local zombiesLocal = workspace:FindFirstChild("Zombies_Local")
    
    if not zombiesLocal then return data end
    
    for _, zombie in ipairs(zombiesLocal:GetChildren()) do
        local id = tonumber(zombie.Name:match("%d+"))
        local rootPart = zombie:FindFirstChild("HumanoidRootPart")
        
        if id and rootPart then
            table.insert(data, {
                id = id,
                pos = rootPart.Position,
            })
        end
    end
    
    return data
end


task.spawn(function()
game:GetService("Players").LocalPlayer.Idled:connect(function()
game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
task.wait(1)
game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
	
end)

--------------------------------------------------------------------UI-----------------------------------------------------------------------------------------------------


local _version = "1.6.64-fix"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))() 


WindUI:AddTheme({
    Name = "Dark", -- theme name
    
    Accent = Color3.fromHex("#18181b"),
    Background = Color3.fromHex("#101010"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
})

WindUI:Notify({
    Title = "เปิดเมนู",
    Content = "สคริปกำลังเริ่มต้น",
    Duration = 3
})


local Window = WindUI:CreateWindow({
    Title = "ขอต้อนรับสู่สคริปของ TAR122", -- window title
    Icon = "atom", -- lucide icon or "rbxassetid://" or URL. optional
    Author = "แมพ Servive Zombies Arena", -- window subtitle. optional
	Folder = "ftgshub",
    HideSearchBar = true, 
	--Icon = "solar:folder-2-bold-duotone",
	--Theme = "Mellowsi",
	--IconSize = 22*2,
	NewElements = true,
	--Size = UDim2.fromOffset(700,700),

	HideSearchBar = false,

	OpenButton = {
		Title = "เปิด/ปิด", -- can be changed
		CornerRadius = UDim.new(1, 0), -- fully rounded
		StrokeThickness = 3, -- removing outline
		Enabled = true, -- enable or disable openbutton
		Draggable = true,
		OnlyMobile = false,
		Scale = 0.7,

		Color = ColorSequence.new( -- gradient
			Color3.fromHex("#30FF6A"),
			Color3.fromHex("#e7ff2f")
		),
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac", -- Default or Mac
	}
})

	Window:Tag({
		Title = "github.com/@noobtar",
		Icon = "github",
		Color = Color3.fromHex("#1c1c1c"),
		Border = true,
	})

local Tab = Window:Tab({
    Title = "เมนูหลัก",
    Icon = "shield", -- optional
})


Tab:Paragraph({
    Title = "เมนูหลัก",
    Desc = "สคริปกากๆกรุณาใช้อย่างระมัดระวัง เพราะพังแล้วกูแก้ไม่ได้ !!"
})


local currentTask_kill = nil

local Toggle = Tab:Toggle({
    Title = "ออโต้ฆ่าซอมบี้ [ไม่ถือปืน]",
    Callback = function(state)

local Event_kill = replicatedStorage:WaitForChild("ZombieRemotes"):WaitForChild("ZombieDamage")

_G.FRAM_KILL = state

    if state then
        -- หยุด task เก่าถ้ามี
        if currentTask_kill then
            task.cancel(currentTask_kill)
            currentTask_kill = nil
        end
        -----------------------------------

        -- สร้าง task ใหม่
        currentTask_kill = task.spawn(function()
            
-----------------------------------------------

while _G.FRAM_KILL do

    local zombiesLocal = workspace:FindFirstChild("Zombies_Local")
    
    if zombiesLocal then
        local children = zombiesLocal:GetChildren()
        
        for i = 1, #children do
            local zombie = children[i]
            local id = tonumber(zombie.Name:match("%d+"))
            if id then
                pcall(function()
                    Event_kill:FireServer(id, math.huge)
                end)
            end
        end
    end
    
    task.wait(0.1) 
end
---------------------------------------------------------------------------------------------------------------------------
      end)
		--------------------------------------
    else
        -- หยุด task เมื่อปิด Toggle
        if currentTask_kill then
            task.cancel(currentTask_kill)
            currentTask_kill = nil
        end
		-----------------------------------
    end
    end
})

-----------------------------------------------------------------------------------------------------------------------------

local currentTask = nil

local Toggle = Tab:Toggle({
    Title = "ออโต้ฆ่าซอมบี้ [ถือปืน]",
    Callback = function(state)

local gunHit = replicatedStorage:WaitForChild("GunRemotes"):WaitForChild("GunHit")
local gunFire = replicatedStorage:WaitForChild("GunRemotes"):WaitForChild("GunFire")  
   
_G.FRAM = state

    if state then
        -- หยุด task เก่าถ้ามี
        if currentTask then
            task.cancel(currentTask)
            currentTask = nil
        end
        -----------------------------------

        -- สร้าง task ใหม่
        currentTask = task.spawn(function()
            
			while _G.FRAM do  -- ตรวจสอบเงื่อนไขในลูป
              
			for _, tool in ipairs(character:GetChildren()) do

			   if tool:IsA("Tool") then

                local weaponName = tool.Name
                local targets = getZombieData()
                
                for _, target in ipairs(targets) do
				  task.spawn(function()
                    pcall(function()
					    gunFire:FireServer(weaponName,target.pos)
                        gunHit:FireServer(weaponName, target.id, target.pos)
                    end)
					end)
              	end

					end
				end

                task.wait(0.5)  
            end
        end)
		--------------------------------------
    else
        -- หยุด task เมื่อปิด Toggle
        if currentTask then
            task.cancel(currentTask)
            currentTask = nil
        end
		-----------------------------------
    end
    end
})

-----------------------------------------------------------------------------------------------------------------------------

local auto_collect = nil

local Toggle = Tab:Toggle({
    Title = "ออโต้เก็บคริสตอลอีเว้น",
    Callback = function(state)

_G.COLLECT = state

    if state then
        -- หยุด task เก่าถ้ามี
        if auto_collect then
            task.cancel(auto_collect)
            auto_collect = nil
        end
        -----------------------------------

        -- สร้าง task ใหม่
        auto_collect = task.spawn(function()
            while _G.COLLECT do  -- ตรวจสอบเงื่อนไขในลูป
            local voidshards = workspace.VoidShards
          
		    if voidshards then		
                for _, target in ipairs(voidshards:GetChildren()) do
					target.CanCollide = false
                    target.CFrame = humanoidRootPart.CFrame + Vector3.new(0,7,0)
                end
			end
                task.wait()  
            end
        end)
		--------------------------------------

    else
        -- หยุด task เมื่อปิด Toggle
        if auto_collect then
            task.cancel(auto_collect)
            auto_collect = nil
        end
		-----------------------------------
    end
    end
})

-----------------------------------------------------------------------------------------------------------------------------

local ch_safe_1 = nil

local Toggle = Tab:Toggle({
    Title = "ออโต้เซฟโซน",
    Callback = function(state)
	
_G.SAFE_1 = state

    if state then
        -- หยุด task เก่าถ้ามี
        if ch_safe_1 then
            task.cancel(ch_safe_1)
            ch_safe_1 = nil
        end
        -----------------------------------

    ch_safe_1 = task.spawn(function()

    local new_cframe = backup_cframe + Vector3.new(0, 20, 0)

    while _G.SAFE_1 do
        if character and character.Parent and humanoidRootPart then
           
			humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
			humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
            humanoidRootPart.CFrame = new_cframe
       
        end
        task.wait()
    end
end)

		--------------------------------------
    else

        if ch_safe_1 then
            task.cancel(ch_safe_1)
            ch_safe_1 = nil
        end
		-----------------------------------
    end
    end
})

-----------------------------------------------------------------------------------------------------------------------------

local ch_tptask = nil

local Toggle = Tab:Toggle({
    Title = "AFK ยืนเวฟ",
    Callback = function(state)
	
_G.SAFE = state

    if state then
        -- หยุด task เก่าถ้ามี
        if ch_tptask then
            task.cancel(ch_tptask)
            ch_tptask = nil
        end
        -----------------------------------

     ch_tptask = task.spawn(function()
   		while _G.SAFE do
       if character and character.Parent and humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(-221.61351, 41.3945541, -283.593719, 0.998308182, -0.000439744443, 0.0581427775, 8.71979555e-09, 0.99997139, 0.00756281661, -0.0581444427, -0.00755002117, 0.998279631)
	    end
         task.wait() 
   		 end

	end)
		--------------------------------------
    else
        -- หยุด task เมื่อปิด Toggle
		  humanoidRootPart.CFrame = backup_cframe

        if ch_tptask then
            task.cancel(ch_tptask)
            ch_tptask = nil
        end
		-----------------------------------
    end
    end
})

-----------------------------------------------------------------------------------------------------------------------------

local Button = Tab:Button({
    Title = "BOOT_FPS",
    Callback = function()

-- ========== FPS BOOSTER SIMPLE ==========
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- ตั้งค่าแสง
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.Brightness = 1.5
Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
Lighting.ClockTime = 14

-- ตั้งค่าน้ำ
local Terrain = workspace:FindFirstChildWhichIsA("Terrain")
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

-- ลบของไม่จำเป็น
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("BasePart") then
        v.CastShadow = false
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
        v:Destroy()
    elseif v:IsA("Decal") then
        v.Transparency = 1
    elseif v:IsA("PostEffect") or v:IsA("Bloom") or v:IsA("Blur") or v:IsA("SunRays") then
        v.Enabled = false
        v:Destroy()
    end
end

-- ลบของที่เกิดใหม่
workspace.DescendantAdded:Connect(function(child)
    task.wait(0.1)
    if child:IsA("ParticleEmitter") or child:IsA("Trail") or child:IsA("Smoke") or 
       child:IsA("Fire") or child:IsA("Sparkles") or child:IsA("Beam") then
        child:Destroy()
    elseif child:IsA("BasePart") then
        child.CastShadow = false
    end
end)

    end
})

--------------------------------------------------------------------TAB2---------------------------------------------------------

local Tab = Window:Tab({
    Title = "เมนูซื้อของ",
    Icon = "banknote", -- optional
})


Tab:Paragraph({
    Title = "เมนูซื้อของ",
    Desc = "ซื้อของกันเด๊ะ"
})

local hp_task = nil

local Toggle = Tab:Toggle({
    Title = "อัพเลือดอัตโนมัติ",
    Callback = function(state)
	
_G.HP = state

    if state then
        -- หยุด task เก่าถ้ามี
        if hp_task then
            task.cancel(hp_task)
            hp_task = nil
        end
        -----------------------------------

     hp_task = task.spawn(function()
   		while _G.HP do
	    game:GetService("ReplicatedStorage"):WaitForChild("UpgradeRemotes"):WaitForChild("PurchaseHealthUpgrade"):FireServer()
        task.wait(0.5) 
   		 end
	end)
		--------------------------------------
    else
     
        if hp_task then
            task.cancel(hp_task)
            hp_task = nil
        end
		-----------------------------------
    end
    end
})

-----------------------------------------------------------------------------------------------------------------------------

local wp_task = nil

local Toggle = Tab:Toggle({
    Title = "อัพปืนอัตโนมัติ",
    Callback = function(state)
	
_G.WP = state

    if state then
        -- หยุด task เก่าถ้ามี
        if wp_task then
            task.cancel(wp_task)
            wp_task = nil
        end
        -----------------------------------

     wp_task = task.spawn(function()
   		while _G.WP do
	    game:GetService("ReplicatedStorage"):WaitForChild("UpgradeRemotes"):WaitForChild("PurchaseWeaponUpgrade"):FireServer()
        task.wait(1) 
   		 end
	end)
		--------------------------------------
    else
     
        if wp_task then
            task.cancel(wp_task)
            wp_task = nil
        end
		-----------------------------------
    end
    end
})
