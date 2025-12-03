return function(CONFIG)
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")

    -- Create ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "LunaExecutorGUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success = pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)
    if not success then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Position storage
    local lastMainPos = UDim2.new(0.5, 0, 0.5, 0)
    local lastLogoPos = UDim2.new(1, -60, 0, 20)

    -- Draggable function
    local function MakeDraggable(frame, saveCallback)
        local dragging = false
        local dragInput
        local dragStart
        local startPos

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if saveCallback then 
                            pcall(function() 
                                saveCallback(frame.Position) 
                            end)
                        end
                    end
                end)
            end
        end)

        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- Main Executor Frame
    local execFrame = Instance.new("Frame")
    execFrame.Name = "ExecutorFrame"
    execFrame.Size = UDim2.new(0, 410, 0, 280)
    execFrame.Position = lastMainPos
    execFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    execFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    execFrame.BorderSizePixel = 0
    execFrame.Parent = gui

    local execCorner = Instance.new("UICorner")
    execCorner.CornerRadius = UDim.new(0, 15)
    execCorner.Parent = execFrame

    local execStroke = Instance.new("UIStroke")
    execStroke.Color = CONFIG.MainColor or Color3.fromRGB(0, 255, 255)
    execStroke.Thickness = 2
    execStroke.Parent = execFrame

    MakeDraggable(execFrame, function(p) lastMainPos = p end)

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = CONFIG.LoaderName or "LUNA HUB SCRIPT LOADER"
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = execFrame

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, CONFIG.MainColor or Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, CONFIG.MainColor or Color3.fromRGB(0, 255, 255))
    }
    gradient.Parent = title

    -- Animate gradient
    task.spawn(function()
        while title and title.Parent do
            for i = 0, 360, 3 do
                if not title or not title.Parent then break end
                gradient.Rotation = i
                task.wait(0.02)
            end
        end
    end)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = execFrame

    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(1, 0)
    closeBtnCorner.Parent = closeBtn

    -- Hide Button
    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0, 25, 0, 25)
    hideBtn.Position = UDim2.new(1, -60, 0, 6)
    hideBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    hideBtn.Text = "-"
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextSize = 18
    hideBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    hideBtn.BorderSizePixel = 0
    hideBtn.Parent = execFrame

    local hideBtnCorner = Instance.new("UICorner")
    hideBtnCorner.CornerRadius = UDim.new(1, 0)
    hideBtnCorner.Parent = hideBtn

    -- Logo Button
    local logo = Instance.new("ImageButton")
    logo.Name = "LunaLogo"
    logo.Size = UDim2.new(0, 47, 0, 47)
    logo.Position = lastLogoPos
    logo.AnchorPoint = Vector2.new(0, 0)
    logo.BackgroundTransparency = 1
    logo.Image = CONFIG.LogoUrl or "rbxassetid://107371206137546"
    logo.BorderSizePixel = 0
    logo.Visible = false
    logo.Parent = gui

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = logo

    local logoStroke = Instance.new("UIStroke")
    logoStroke.Color = CONFIG.MainColor or Color3.fromRGB(0, 255, 255)
    logoStroke.Thickness = 2
    logoStroke.Parent = logo

    MakeDraggable(logo, function(p) lastLogoPos = p end)

    -- Button connections
    hideBtn.MouseButton1Click:Connect(function()
        execFrame.Visible = false
        logo.Visible = true
    end)

    logo.MouseButton1Click:Connect(function()
        logo.Visible = false
        execFrame.Visible = true
    end)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Executing overlay
    local function ShowExecuting(parent, text, callback)
        local overlay = Instance.new("Frame")
        overlay.Size = UDim2.new(0.9, 0, 0.18, 0)
        overlay.Position = UDim2.new(0.5, 0, 0.5, 0)
        overlay.AnchorPoint = Vector2.new(0.5, 0.5)
        overlay.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 10
        overlay.Parent = parent

        local overlayCorner = Instance.new("UICorner")
        overlayCorner.CornerRadius = UDim.new(0, 8)
        overlayCorner.Parent = overlay

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 0)
        stroke.Thickness = 1.5
        stroke.Parent = overlay

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.4, 0)
        label.Position = UDim2.new(0, 0, 0.1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BorderSizePixel = 0
        label.Parent = overlay

        local progressBg = Instance.new("Frame")
        progressBg.Size = UDim2.new(0.95, 0, 0.35, 0)
        progressBg.Position = UDim2.new(0.025, 0, 0.55, 0)
        progressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        progressBg.BorderSizePixel = 0
        progressBg.Parent = overlay

        local progressBgCorner = Instance.new("UICorner")
        progressBgCorner.CornerRadius = UDim.new(0, 6)
        progressBgCorner.Parent = progressBg

        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(0, 0, 1, 0)
        progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        progressBar.BorderSizePixel = 0
        progressBar.Parent = progressBg

        local progressBarCorner = Instance.new("UICorner")
        progressBarCorner.CornerRadius = UDim.new(0, 6)
        progressBarCorner.Parent = progressBar

        task.spawn(function()
            local pct = 0
            while pct < 1 do
                pct = math.clamp(pct + 0.015, 0, 1)
                progressBar.Size = UDim2.new(pct, 0, 1, 0)
                task.wait(0.03)
            end
            task.wait(0.3)
            overlay:Destroy()
            if callback then
                callback()
            end
        end)
    end

    -- Error overlay
    local function ShowError(parent, errorText)
        local errorOverlay = Instance.new("Frame")
        errorOverlay.Size = UDim2.new(0.9, 0, 0.35, 0)
        errorOverlay.Position = UDim2.new(0.5, 0, 0.5, 0)
        errorOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
        errorOverlay.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        errorOverlay.BorderSizePixel = 0
        errorOverlay.ZIndex = 10
        errorOverlay.Parent = parent

        local errorCorner = Instance.new("UICorner")
        errorCorner.CornerRadius = UDim.new(0, 8)
        errorCorner.Parent = errorOverlay

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 0, 0)
        stroke.Thickness = 2
        stroke.Parent = errorOverlay

        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(0.9, 0, 0.55, 0)
        errorLabel.Position = UDim2.new(0.05, 0, 0.08, 0)
        errorLabel.BackgroundTransparency = 1
        errorLabel.Text = errorText
        errorLabel.Font = Enum.Font.GothamBold
        errorLabel.TextSize = 14
        errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        errorLabel.TextWrapped = true
        errorLabel.BorderSizePixel = 0
        errorLabel.Parent = errorOverlay

        local okBtn = Instance.new("TextButton")
        okBtn.Size = UDim2.new(0.4, 0, 0.25, 0)
        okBtn.Position = UDim2.new(0.3, 0, 0.7, 0)
        okBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        okBtn.Text = "OK"
        okBtn.Font = Enum.Font.GothamBold
        okBtn.TextSize = 16
        okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        okBtn.BorderSizePixel = 0
        okBtn.Parent = errorOverlay

        local okBtnCorner = Instance.new("UICorner")
        okBtnCorner.CornerRadius = UDim.new(0, 6)
        okBtnCorner.Parent = okBtn

        okBtn.MouseButton1Click:Connect(function()
            errorOverlay:Destroy()
        end)
    end

    -- List Container
    local listContainer = Instance.new("Frame")
    listContainer.Size = UDim2.new(0.92, 0, 0.72, 0)
    listContainer.Position = UDim2.new(0.5, 0, 0.23, 0)
    listContainer.AnchorPoint = Vector2.new(0.5, 0)
    listContainer.BackgroundTransparency = 1
    listContainer.BorderSizePixel = 0
    listContainer.Parent = execFrame

    local dragHandle = Instance.new("TextLabel")
    dragHandle.Size = UDim2.new(1, 0, 0, 28)
    dragHandle.BackgroundTransparency = 0.95
    dragHandle.Text = "Script List"
    dragHandle.TextSize = 14
    dragHandle.Font = Enum.Font.GothamSemibold
    dragHandle.TextColor3 = Color3.fromRGB(200, 200, 200)
    dragHandle.BorderSizePixel = 0
    dragHandle.Parent = listContainer

    local buttonHolder = Instance.new("ScrollingFrame")
    buttonHolder.Size = UDim2.new(1, 0, 1, -32)
    buttonHolder.Position = UDim2.new(0, 0, 0, 32)
    buttonHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    buttonHolder.ScrollBarThickness = 6
    buttonHolder.BackgroundTransparency = 1
    buttonHolder.BorderSizePixel = 0
    buttonHolder.ScrollBarImageColor3 = CONFIG.MainColor or Color3.fromRGB(0, 255, 255)
    buttonHolder.Parent = listContainer

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = buttonHolder

    -- Auto-update canvas size
    task.spawn(function()
        while buttonHolder and buttonHolder.Parent do
            buttonHolder.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
            task.wait(0.1)
        end
    end)

    -- Rainbow outline function
    local function ApplyRainbowOutline(obj)
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = obj

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, CONFIG.MainColor or Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, CONFIG.MainColor or Color3.fromRGB(0, 255, 255))
        }
        grad.Parent = stroke

        task.spawn(function()
            while obj and obj.Parent do
                for i = 0, 360, 3 do
                    if not obj or not obj.Parent then break end
                    grad.Rotation = i
                    task.wait(0.02)
                end
            end
        end)
    end

    -- Confirm popup
    local currentPopup = nil
    local function ConfirmPopup(scriptName, callback)
        if currentPopup then
            currentPopup:Destroy()
            currentPopup = nil
        end

        local popup = Instance.new("Frame")
        popup.Size = UDim2.new(0, 260, 0, 140)
        popup.Position = UDim2.new(0.5, 0, 0.5, 0)
        popup.AnchorPoint = Vector2.new(0.5, 0.5)
        popup.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        popup.BorderSizePixel = 0
        popup.ZIndex = 10
        popup.Parent = execFrame

        local popupCorner = Instance.new("UICorner")
        popupCorner.CornerRadius = UDim.new(0, 10)
        popupCorner.Parent = popup

        currentPopup = popup

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 50)
        label.Position = UDim2.new(0, 10, 0, 10)
        label.BackgroundTransparency = 1
        label.Text = "Execute " .. scriptName .. " Script?"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 15
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextWrapped = true
        label.BorderSizePixel = 0
        label.Parent = popup

        local yesBtn = Instance.new("TextButton")
        yesBtn.Size = UDim2.new(0.4, 0, 0, 35)
        yesBtn.Position = UDim2.new(0.05, 0, 0.63, 0)
        yesBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        yesBtn.Text = "Yes"
        yesBtn.Font = Enum.Font.GothamBold
        yesBtn.TextSize = 16
        yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        yesBtn.BorderSizePixel = 0
        yesBtn.Parent = popup

        local yesBtnCorner = Instance.new("UICorner")
        yesBtnCorner.CornerRadius = UDim.new(0, 6)
        yesBtnCorner.Parent = yesBtn

        local noBtn = Instance.new("TextButton")
        noBtn.Size = UDim2.new(0.4, 0, 0, 35)
        noBtn.Position = UDim2.new(0.55, 0, 0.63, 0)
        noBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        noBtn.Text = "No"
        noBtn.Font = Enum.Font.GothamBold
        noBtn.TextSize = 16
        noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        noBtn.BorderSizePixel = 0
        noBtn.Parent = popup

        local noBtnCorner = Instance.new("UICorner")
        noBtnCorner.CornerRadius = UDim.new(0, 6)
        noBtnCorner.Parent = noBtn

        yesBtn.MouseButton1Click:Connect(function()
            popup:Destroy()
            currentPopup = nil
            callback()
        end)

        noBtn.MouseButton1Click:Connect(function()
            popup:Destroy()
            currentPopup = nil
        end)
    end

    -- Create script buttons
    for _, script in ipairs(CONFIG.Scripts or {}) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.Text = script.LoaderName or script.Name or "Unknown Script"
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.TextColor3 = Color3.fromRGB(230, 230, 255)
        btn.BorderSizePixel = 0
        btn.Parent = buttonHolder

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        ApplyRainbowOutline(btn)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            ConfirmPopup(script.LoaderName or script.Name, function()
                local currentGameId = game.PlaceId
                
                if script.GameId and currentGameId ~= script.GameId then
                    local success, gameName = pcall(function()
                        return game:GetService("MarketplaceService"):GetProductInfo(currentGameId).Name
                    end)
                    local displayName = success and gameName or "this game"
                    ShowError(execFrame, "This script is not supported in " .. displayName)
                    return
                end

                local scriptUrl = script.LoaderUrl or script.Url
                if scriptUrl and scriptUrl ~= "" then
                    ShowExecuting(execFrame, "Executing Please Wait", function()
                        local success, err = pcall(function()
                            loadstring(game:HttpGet(scriptUrl))()
                        end)
                        
                        if not success then
                            ShowError(execFrame, "Execution Error: " .. tostring(err))
                        end
                        
                        task.wait(1)
                        if gui and gui.Parent then 
                            gui:Destroy() 
                        end
                    end)
                else
                    ShowError(execFrame, "Script URL not configured!")
                end
            end)
        end)
    end
end
