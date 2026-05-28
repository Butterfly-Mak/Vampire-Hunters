local players : Players = world:WaitChild("Players");

local role_assign_event : NetworkEvent = script:GetParent()["RoleAssign"];
local role_reset_event : NetworkEvent = script:GetParent()["RoleReset"];

local vampire_player_index : integer = 0;
local detective_player_index : integer = 0;

function ResetRoles()
	role_reset_event:InvokeClients(nil);
end;


function GenerateRandomRoles(player_count : integer)
	if player_count == 1 then
		--For testing
		vampire_player_index = math.random(player_count);
		detective_player_index = math.random(player_count);
		return;
	end;

	if player_count == 2 then
		vampire_player_index = math.random(player_count);
		if vampire_player_index == 1 then detective_player_index = 2 else detective_player_index = 1 end;
		return;
	end;
	
	vampire_player_index   = math.random(player_count);
	detective_player_index = math.random(player_count);
	
	while (detective_player_index == vampire_player_index) do
		detective_player_index = math.random(player_count);
	end;

	assert(detective_player_index ~= vampire_player_index);
end;

function SendRandomRoleEvent()
	local message : NetMessage = NetMessage:New();
	
	message:AddInt("VampirePlayerID", players:GetPlayers()[vampire_player_index].UserID);
	message:AddInt("DetectivePlayerID", players:GetPlayers()[detective_player_index].UserID);
	
	role_assign_event:InvokeClients(message);
end;

function AssignRandomPlayerRoles()
	print("Assigning players random roles");
	
	local player_count : integer = #players:GetPlayers();
	
	--if player_count == 1 then return end;
	
	GenerateRandomRoles(player_count);
	
	SendRandomRoleEvent();
end;

role_assign_event.InvokedServer:Connect(AssignRandomPlayerRoles);