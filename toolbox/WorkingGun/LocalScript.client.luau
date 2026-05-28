script.Parent.Parent.Activated:Connect(function ()
    local ray = nil
    local camRay = Input:ScreenPointToRay(Input.MousePosition)
    local dir = camRay.Position - script.Parent["Barrel"].Position
    local worldRay = game["Environment"]:Raycast(script.Parent["Barrel"].Position, (camRay.Position - script.Parent["Barrel"].Position).normalized, infinite, {script.Parent["MuzzleFlash"]})
    if (camRay and worldRay) and camRay.Instance == worldRay.Instance then
        ray = camRay
    else
        ray = worldRay
    end
    --local ray = Input:ScreenPointToRay(Input.MousePosition)
    --print("works")
    if ray then
        --print("works2")
        local netMesg = NetMessage.new()
        netMesg.AddInstance("rayInst", ray.Instance)
        netMesg.AddVector3("rayPos", ray.Position)
        
        script.Parent["FireEvent"]:InvokeServer(netMesg)
    end
end)

Input.KeyDown:Connect(function(key)
    if key == "R" then
        local netMesg = NetMessage.new()
        netMesg.AddInstance("model", script.Parent)
        netMesg.AddNumber("time", script.Parent["Reload"].Length)
        script.Parent["ReloadEvent"]:InvokeServer(netMesg)
    end
end)

game.Rendered:Connect(function ()
    game["PlayerGUI"]["PistolGUI"]["Crosshair"].Visible = game["Environment"]["Camera"].IsFirstPerson and Input.CursorLocked
end)