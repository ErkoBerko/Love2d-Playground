local Block = {}
Block.__index = Block
Block.new = function(x, y, w, h, isActive, colorIdx)
    return setmetatable({
        x=x or error(),
        y=y or error(),
        w=w or error(),
        h=h or error(),
        isActive=isActive or error(),
        colorIdx=colorIdx or error()}, Block)
end

local function createShader()
    local pixelCode = [[
    uniform float angle;

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texcolor = Texel(tex, texture_coords);
        vec2 screen_coords_rot = vec2(sin(screen_coords.x / 1600), cos(screen_coords.y / 900));
        float intensity = pow(length((screen_coords_rot)), 25);
        return texcolor * color * vec4(intensity, intensity, intensity, 1);
    }
]]

    local vertexCode = [[
        uniform float angle;

        vec4 position(mat4 transform_projection, vec4 vertex_position)
        {
            return transform_projection *
                    vertex_position *
                    vec4(abs(cos(angle)), abs(sin(angle)), 1, 1);
        }
    ]]
    return love.graphics.newShader(pixelCode, vertexCode)
end

local shader = createShader()

local X = 100
local Y = 100

local W = 0
local H = 0

local MaxWidth = 1600 * 0.6
local MaxHeight = 900 * 0.6

local R = 0
local G = 0
local B = 0

local Angle = 0
local Time = 0

local function PositiveSin(x)
    return (math.sin(x) + 1) / 2
end

local function PositiveCos(x)
    return (math.cos(x) + 1) / 2
end

local function initScene()
    local width, height = love.graphics.getDimensions()
    local centerX = width / 2
    local centerY = height / 2
    X = centerX - W / 2
    Y = centerY - H / 2
end

initScene()

local function updateScene(dt)
    Angle = Angle + math.pi * dt * .15
    Time = Time + dt

    local width, height = love.graphics.getDimensions()
    local centerX = width / 2
    local centerY = height / 2
    X = centerX - W / 2
    Y = centerY - H / 2

    W = PositiveSin(Angle * 2) * MaxWidth / 2 + MaxWidth / 2
    H = PositiveSin(Angle * 2) * MaxHeight / 2 + MaxHeight / 2
    R = PositiveSin(Time * 1.3)
    G = PositiveSin(Time * 1.3 * 1.2)
    B = PositiveSin(Time * 1.3 * 1.2 * 1.2)

    shader:send("angle", Angle)
end

local function drawScene()
    local width, height = love.graphics.getDimensions()
    local centerX = width / 2
    local centerY = height / 2

    love.graphics.setShader(shader)
    love.graphics.push()
        love.graphics.setColor(R, G, B)
        love.graphics.translate(centerX, centerY)
        love.graphics.rotate(Angle)
        love.graphics.translate(-centerX, -centerY)
        love.graphics.rectangle("fill", X, Y, W, H)
    love.graphics.pop()
end

return {
    initScene=initScene,
    drawScene=drawScene,
    updateScene=updateScene,
    name="Animated Rectangle",
}