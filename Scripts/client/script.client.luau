local button : UIButton = script:GetParent();
local event : NetworkEvent = world:WaitChild("ScriptService")["PlayerRoles"]["RoleAssign"]

function test()
	event:InvokeServer(nil);
end;

button.Clicked:Connect(test);