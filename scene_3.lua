local colors = require"colors"

local blockMargin = 1

local Block = {}
Block.__index = Block
Block.new = function(x, y, w, h, isPainted, colorIdx)
    return setmetatable({
        x=x,
        y=y,
        w=w,
        h=h,
        isPainted=isPainted,
        colorIdx=colorIdx}, Block)
end

local PaletteSelectorUiElement = {}
PaletteSelectorUiElement.__index = PaletteSelectorUiElement
PaletteSelectorUiElement.new = function(x, y, w, h, isPainted)
    return setmetatable({
        x=x,
        y=y,
        w=w,
        h=h}, PaletteSelectorUiElement)
end

local function isPointInRectangle(px, py, x, y, w, h)
    return px >= x and px <= x + w and
            py >= y and py <= y + h
end

local paintBlock = {
    action="none",
    x=0,
    y=0,
}

local colorSelectorUiElements = {
}

local selectedPaletteIndex = 1

local paletteColors = {{
        r = 1,
        g = 0,
        b = 0,
    }, {
        r = 0,
        g = 1,
        b = 0,
    }, {
        r = 0,
        g = 0,
        b = 1,
    },
}

local paletteSelectorMargin = 8

local blocks = {
}

local paletteColorSelector = {
    checkForSelection=false,
    x=0,
    y=0,
}

local function initScene()
    local width = 30
    local height = 30

    local x = 50
    local y = 50
    for rowIdx=1,#paletteColors do
        local paletteSelector = PaletteSelectorUiElement.new(x,
            rowIdx * height + paletteSelectorMargin * (rowIdx - 1) + y,
            width,
            height,
            rowIdx == 1)
        table.insert(colorSelectorUiElements, paletteSelector)
    end

    for columnIdx=1,20 do
        local row = {}
        for rowIdx=1,20 do
            local block = Block.new(x + columnIdx * width + blockMargin * columnIdx + width * 2,
                rowIdx * height + blockMargin * (rowIdx - 1) + y,
                width,
                height,
                false, 1)
            table.insert(row, block)
        end
        table.insert(blocks, row)
    end
end

local function drawScene()
    for idx, selector in ipairs(colorSelectorUiElements) do
        local color = paletteColors[idx]
        if idx == selectedPaletteIndex then
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", selector.x - 2, selector.y - 2, selector.w + 4, selector.h + 4)
        end
        love.graphics.setColor(color.r, color.g, color. b)
        love.graphics.rectangle("fill", selector.x, selector.y, selector.w, selector.h)
    end

    for columnIdx, column in ipairs(blocks) do
        for rowIdx, block in ipairs(column) do
            if block.isPainted then
                local color = paletteColors[block.colorIdx]
                love.graphics.setColor(color.r, color.g, color.b)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.rectangle("fill", block.x, block.y, block.w, block.h)
        end
    end
end

local function updateScene(dt)
    if paletteColorSelector.checkForSelection then
        for idx, selector in ipairs(colorSelectorUiElements) do
            if isPointInRectangle(paletteColorSelector.x, paletteColorSelector.y, selector.x, selector.y, selector.w, selector.h) then
                selectedPaletteIndex = idx
            end
        end
        paletteColorSelector.checkForSelection = false
    end

    for _, blockColumn in ipairs(blocks) do
        for _, block in ipairs(blockColumn) do
            if isPointInRectangle(paintBlock.x, paintBlock.y, block.x, block.y, block.w, block.h) then
                if paintBlock.action == "paint" then
                    block.colorIdx = selectedPaletteIndex
                    block.isPainted = true
                elseif paintBlock.action == "erase" then
                    block.isPainted = false
                end
            end
        end
    end
end

local function mousePressed(x, y, button, isTouch, presses)
    if button == 1 then
        paintBlock = {
            action="paint",
            x=x,
            y=y,
        }
    elseif button == 2 then
        paintBlock = {
            action="erase",
            x=x,
            y=y,
        }
    end
end

local function mouseReleased(x, y, button, isTouch, presses)
    if button == 1 then
        paletteColorSelector.x = x
        paletteColorSelector.y = y
        paletteColorSelector.checkForSelection = true

        paintBlock.action = "none"
    elseif button == 2 then
        paintBlock.action = "none"
    end
end

local function mouseMoved(x, y, dx, dy, isTouch)
    paintBlock.x = x
    paintBlock.y = y
end

return {
    initScene=initScene,
    drawScene=drawScene,
    updateScene=updateScene,
    mousePressed=mousePressed,
    mouseReleased=mouseReleased,
    mouseMoved=mouseMoved,
    name="Paint",
}