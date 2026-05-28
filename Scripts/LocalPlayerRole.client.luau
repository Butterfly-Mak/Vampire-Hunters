local player : Player = world:WaitChild("Players").LocalPlayer;
local player_id : integer = player.UserID;

local role_assign_event : NetworkEvent = script:GetParent()["RoleAssign"];
local role_reset_event : NetworkEvent = script:GetParent()["RoleReset"];

--Roles: 0 - Normal, 1 - Detective, 2 - Vampire, 3 - Survivor
local player_role : integer = 0;

function RoleAssignReceived(message : NetMessage)
	local vampire_id : integer = message:GetInt("VampirePlayerID");
	local detective_id : integer = message:GetInt("DetectivePlayerID");
	
	if (vampire_id ~= player_id) and (detective_id ~= player_id) then
		player_role = 3;
		print(player.Name .. " is a survivor.");
		return;
	end; 
	
	if vampire_id == player_id then
		player_role = 2;
		print(player.Name .. "is the vampire.");
		return;
		end;
	
	player_role = 1;
	print(player.Name .. "is the detective.");
end;

role_assign_event.InvokedClient:Connect(RoleAssignReceived);