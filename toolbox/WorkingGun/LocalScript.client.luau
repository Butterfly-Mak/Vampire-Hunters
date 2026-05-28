local MAX_COOLDOWN = 1.0;
local cooldown = 0.0;

local tool : Tool = script.Parent.Parent;
local gun_barrel : Part = script.Parent["Barrel"];
local fire_event : NetworkEvent = script.Parent["FireEvent"];

tool.Activated:Connect(function ()
	if cooldown > 0.0 then return end;

  local mouse_world_pos : Vector3 = Input:GetMouseWorldPosition();
	
  local dir : Vector3 = (mouse_world_pos - gun_barrel.Position);
	
  local ray : RayResult = Environment:Raycast(gun_barrel.Position, dir.Normalized, 9999999, {gun_barrel, Players.LocalPlayer});
	
  local netMesg : NetMessage = NetMessage.new();
	
	netMesg:AddBool("success", ray ~= nil);
	
	if ray == nil then
    netMesg.AddVector3("rayPos", mouse_world_pos);
	else
    netMesg.AddInstance("rayInst", ray.Instance);
    netMesg.AddVector3("rayPos", ray.Position);
  end
	
  fire_event:InvokeServer(netMesg);
	
	cooldown = MAX_COOLDOWN;
end)

function update_cooldown(delta : number)
	if cooldown <= 0.0 then return end;
	
	cooldown -= delta;
	print(cooldown);
end;

world.Rendered:Connect(update_cooldown);