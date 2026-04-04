local function initScene()
end

local function updateScene(dt)
end


local function drawScene()
    local count = 10
    local width = 80
    local height = 80
    for column=1,count do
        for row=1,count do
            local red = column / count
            local green = row / count
            local blue = 0
            love.graphics.setColor(red, green, blue)

            local xCoordinate = column * width
            local yCoordinate = row * height
            love.graphics.rectangle("fill", xCoordinate, yCoordinate, width, height)
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("text on row 1", 100, 110)
    love.graphics.print("text on row 5", 100, 110 + height * 4)
    love.graphics.print("text on row 10", 100, 110 + height * 9)
end

return {
    initScene=initScene,
    drawScene=drawScene,
    updateScene=updateScene,
    name="Simple Scene",
}