local canFire = true
local cooldown = 0.1
local damage = 50
local maxAmmo = 7
local ammo = 7
local reloading = false

--local function reload(player, mesg)
    
--end

script.Parent["ReloadEvent"].InvokedServer:Connect(function(player, mesg)
    local model = mesg.GetInstance("model")
    local time = mesg.GetNumber("time")
    if not reloading and ammo < maxAmmo then
        reloading = true
        canFire = false
        model["Reload"]:Play()
        model.LocalRotation = Vector3.new(0,0,315)
        wait(time)
        model.LocalRotation = Vector3.new(0)
        ammo = maxAmmo
        canFire = true
        reloading = false
    end
end)

script.Parent["FireEvent"].InvokedServer:Connect(function(player, rayMes)
    local ray = rayMes.GetInstance("rayInst")
    local rayPos = rayMes.GetVector3("rayPos")
    --print("heard invoke")
    local human = ray:IsA("Player") or ray:IsA("NPC")
    print(ray)

    if ammo < 1 then
        canFire = false
        script.Parent["DryFire"]:PlayOneShot()
    end

    if canFire then
        canFire = false

        script.Parent["Gunshot"].Pitch = math.random(85,115)/100
        script.Parent["Gunshot"]:PlayOneShot()

        ammo = ammo - 1

        if human and ray ~= player then
            ray.Health = ray.Health - damage
        end

        script.Parent["MuzzleFlash"].Brightness = 10
        wait(.05)
        script.Parent["MuzzleFlash"].Brightness = 0

        for count = 1, 3, 1 do
            local newP = Instance.New("Part")
            newP.Size = Vector3.new(0.2, 0.2, 0.2)
            newP.Position = rayPos + Vector3.new(math.random(-5,5)/10, math.random(-5,5)/10, math.random(-5,5)/10)
            if human then
                newP.Color = Color.new(1,0,0)
            elseif ray:IsA("Part") then
                newP.Color = Color.new(ray.Color.r - .1, ray.Color.g - .1, ray.Color.b - .1)
            end
            newP.Anchored = false
            newP.CanCollide = false
            newP.Parent = game["Environment"]
            newP.Velocity = Vector3.new(0, 10, 0)
        end

        -- local particle = script.Parent["Particle"]:Clone()
        -- if ray:IsA("Part") then
        --     particle.Color = ColorRange.new(Color.new(ray.Color.r - .1, ray.Color.g - .1, ray.Color.b - .1), Color.new(ray.Color.r - .3, ray.Color.g - .3, ray.Color.b - .3))
        -- end
        
        -- particle.Parent = game["Environment"]
        -- particle.Position = rayPos
        -- particle:Play()

        wait(cooldown)

        canFire = true
    end
    
end)