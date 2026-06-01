local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local zombiesLocal = workspace:FindFirstChild("Zombies_Local")
local gunHit = replicatedStorage:WaitForChild("GunRemotes"):WaitForChild("GunHit")
local gunFire = replicatedStorage:WaitForChild("GunRemotes"):WaitForChild("GunFire")
local Event_kill = replicatedStorage:WaitForChild("ZombieRemotes"):WaitForChild("ZombieDamage")
local TweenService = game:GetService("TweenService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local backup_cframe = humanoidRootPart.CFrame

wait(2)



local function getZombieData()
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


local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NICKISBAD/Nick-s-Modded-KAVO-Lib/main/Nick'sModdedKavoLib.lua"))()


local ScreenGui = Instance.new("ScreenGui")
local SimpleButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ตั้งค่า Button ใหม่
SimpleButton.Parent = ScreenGui
SimpleButton.Size = UDim2.new(0.10, 0, 0.06, 0) -- กว้าง 10%, สูง 6%
SimpleButton.Position = UDim2.new(0.2, 0, 0.53, 0) -- เริ่มที่ 20% จากซ้าย, 53% จากบน
SimpleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) 
SimpleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SimpleButton.Font = Enum.Font.SourceSansSemibold
SimpleButton.TextSize = 20
SimpleButton.Text = "เปิด/ปิด"
SimpleButton.AutoButtonColor = true
SimpleButton.BorderSizePixel = 0
SimpleButton.Active = true 
SimpleButton.Draggable = true 

-- ฟังก์ชันเมื่อปุ่มถูกกด


local Window = Library.CreateLib(" TAR122 HUB | Survive Zombie Arena", "BloodTheme")

SimpleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)


local Tab = Window:NewTab("เมนูหลัก")


local Main = Tab:NewSection("เมนูหลัก")

local currentTask = nil

Main:NewToggle("ออโต้ฆ่าซอมบี้ [ถือปืน]", "ถือปืนด้วย", function(state) 

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
end)


---------------------------------------------------------------------------------------------------------------------------


local currentTask_kill = nil

Main:NewToggle("ออโต้ฆ่าซอมบี้ [ไม่ถือปืน]", "ถือปืนด้วย", function(state) 

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
end)


local auto_collect = nil

Main:NewToggle("ออโต้เก็บคริสตอลอีเว้น", "เปิด", function(state)

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
end)



local ch_safe_1 = nil

Main:NewToggle("ออโต้เซฟโซน", "เปิด", function(state)  

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

end)





local ch_tptask = nil

Main:NewToggle("AFK ยืนเวฟ", "เปิด", function(state)  

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

end)



Main:NewButton("BOOT_FPS", "เปิด", function()  

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



end)


--------------------------------------------------------------------------------------------------------------------


local Tab_2 = Window:NewTab("เมนูซื้อของ")

local BUY = Tab_2:NewSection("ซื้อออโต้")

local hp_task = nil

BUY:NewToggle("อัพเลือดอัตโนมัติ", "กดเปิด", function(state)  
    
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
        task.wait(1) 
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
end)

----------------------------------------------------------------------------------------------------------------------------------------

local wp_task = nil

BUY:NewToggle("อัพปืนอัตโนมัติ", "กดเปิด", function(state)  
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
end)


--------------------------------------------------------------------UI-----------------------------------------------------------------------------------------------------
