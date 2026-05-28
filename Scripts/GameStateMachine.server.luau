local game_state = require(script:GetParent():WaitChild("GameState"));
local last_state : integer = game_state.State;

local entered_event : NetworkEvent = script:GetParent()["EnteredState"];
local exited_event : NetworkEvent = script:GetParent()["ExitedState"];
local test_event : NetworkEvent = script:GetParent()["Test"];

function UpdateLobby(delta : number)
end;

function UpdateGame(delta : number)
end;

function UpdateResults(delta : number)
end;

local update_function = UpdateLobby;

function EnterLobbyState()
	update_function = UpdateLobby;
end;

function EnterGameState()
	update_function = UpdateGame;
end;

function EnterResultsState()
	update_function = UpdateResults;
end;


function ExitLobbyState()
end;

function ExitGameState()
end;

function ExitResultsState()
end;

function ExitState(state : integer)
	if state == game_state.States.Lobby then
		ExitLobbyState();
	elseif state == game_state.States.Game then
		ExitGameState();
	elseif state == game_state.States.Results then
		ExitResultsState();
	end;
	
	local message : NetMessage = NetMessage:New();
	message:AddInt("State", state);
	exited_event:InvokeClients(message);
end;

function EnterState(state : integer)
	last_state = game_state.State;
	ExitState(last_state);
	
	game_state.State = state;
	
	if game_state.State == game_state.States.Lobby then
		EnterLobbyState();
	elseif game_state.State == game_state.States.Game then
		EnterGameState();
	elseif game_state.State == game_state.States.Results then
		EnterResultsState();
	end;
	
	local message : NetMessage = NetMessage:New();
	message:AddInt("State", state);
	entered_event:InvokeClients(message);
end;

function _Update(deltaTime : number)
	update_function(deltaTime);
end;
