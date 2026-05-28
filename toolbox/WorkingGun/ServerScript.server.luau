local fire_event : NetworkEvent = script.Parent["FireEvent"];
local gun_sfx : Sound = script.Parent["Gunshot"];
local muzzle_flash : Light = script.Parent["MuzzleFlash"];

function CreateParticles(ray_hit : Instance, rayPos : Vector3, hit_human : boolean)
	for count = 1, 3, 1 do
    local newP = Instance.New("Part")
    newP.Size = Vector3.new(0.2, 0.2, 0.2)
    newP.Position = rayPos + Vector3.New(math.random(-5,5)/10, math.random(-5,5)/10, math.random(-5,5)/10)
		
    if hit_human then
        newP.Color = Color.new(1,0,0)
    elseif ray_hit:IsA("Part") then
        newP.Color = Color.new(ray_hit.Color.r - .1, ray_hit.Color.g - .1, ray_hit.Color.b - .1)
    end
		
    newP.Anchored = false
    newP.CanCollide = false
    newP.Parent = game["Environment"]
    newP.Velocity = Vector3.new(0, 10, 0)
  end
end;

fire_event.InvokedServer:Connect(function(player, rayMes)
	local success : boolean = rayMes:GetBool("success");
	local ray_hit : Instance = rayMes:GetInstance("rayInst");
	local rayPos : Vector3 = rayMes:GetVector3("rayPos");
	
  gun_sfx.Pitch = math.random(85,115)/100
  gun_sfx:PlayOneShot()
	
	if success then
		local hit_human = ray_hit:IsA("Player") or ray_hit:IsA("NPC");
		CreateParticles(ray_hit, rayPos, hit_human);
	end;
	
  muzzle_flash.Brightness = 10;
  wait(.05)
  muzzle_flash.Brightness = 0;
end)