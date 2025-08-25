local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local function fling(targetPart)
    if targetPart and targetPart.Parent and targetPart.Parent:FindFirstChild("Humanoid") and targetPart.Parent ~= character then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = (targetPart.Position - rootPart.Position).unit * 1000
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.P = 1e5
        bodyVelocity.Parent = targetPart
        game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
    end
end

player:GetMouse().Button1Down:Connect(function()
    local target = player:GetMouse().Target
    fling(target)
end)

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        local touchPos = input.Position
        local ray = workspace.CurrentCamera:ScreenPointToRay(touchPos.X, touchPos.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
        if raycastResult and raycastResult.Instance then
            fling(raycastResult.Instance)
        end
    end
end)
