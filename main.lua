require("strict")
local colors = require"colors"
local love = _G.love -- suppress some warnings

local lume = require"dependencies.lume.lume"

local Font

local SceneIdx = 1

local Scenes = {
    require"scene_1",
}

local function isPointInRectangle(px, py, x, y, w, h)
    return px >= x and px <= x + w and
            py >= y and py <= y + h
end

function love.load()
    Font = love.graphics.newFont("comic shanns.otf", 26)
    love.graphics.setFont(Font)
    for sceneIdx=1,#Scenes do
        if Scenes[sceneIdx].initScene then
            Scenes[sceneIdx].initScene()
        end
    end
end

function love.update(dt)
    if SceneIdx > #Scenes then
        return
    end

    if Scenes[SceneIdx].updateScene then
        Scenes[SceneIdx].updateScene(dt)
    end
end

function love.draw()
    love.graphics.clear(colors.colors[1].r, colors.colors[1].g, colors.colors[1].b)

    -- TODO: specific render for non-existent scene
    if #Scenes >= SceneIdx then
        Scenes[SceneIdx].drawScene()
    end

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1)

    local sceneName
    if SceneIdx > #Scenes then
        sceneName = "(scene not yet added)"
    else
        sceneName = Scenes[SceneIdx].name or "Untitled"
    end

    love.graphics.print("Scene " .. SceneIdx .. " - " .. sceneName, 20, 20)
end

function love.keypressed(key, scanCode, isRepeat)
	if key == "r" then
        -- TODO: make this correctly retain the pre-hotswap scene index

        local oldSceneIdx = SceneIdx
        for sceneIdx=1,#Scenes do
            assert(lume.hotswap("scene_" .. sceneIdx))
        end
        assert(lume.hotswap("main"))
        for sceneIdx=1,#Scenes do
            Scenes[sceneIdx] = require("scene_" .. sceneIdx)
        end
        SceneIdx = oldSceneIdx
        love.load()
    elseif key == "1" then
        SceneIdx = 1
    elseif key == "2" then
        SceneIdx = 2
    elseif key == "3" then
        SceneIdx = 3
    elseif key == "4" then
        SceneIdx = 4
    elseif key == "5" then
        SceneIdx = 5
    elseif key == "6" then
        SceneIdx = 6
    elseif key == "7" then
        SceneIdx = 7
    elseif key == "8" then
        SceneIdx = 8
    elseif key == "9" then
        SceneIdx = 9
    elseif key == "0" then
        SceneIdx = 10
    end
end