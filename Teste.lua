setDefaultTab("Foi")
-- Dancinha
macro(250, "Dancinha", "Ctrl+D", function()
    turn(math.random(0, 3)) -- turn to a random direction.
 end)


-- ABRIR PORTAS
if not storage.doorIds then
    storage.doorIds = { 5129, 5102, 5111, 5120, 11246, 1629 }
end

local moveTime = 100     -- Wait time between Move, 2000 milliseconds = 2 seconds
local moveDist = 1        -- How far to Walk
local useTime = 100     -- Wait time between Use, 2000 milliseconds = 2 seconds
local useDistance = 1     -- How far to Use

local function properTable(t)
    local r = {}
    for _, entry in pairs(t) do
        table.insert(r, entry.id)
    end
    return r
end

UI.Separator()
UI.Label("Portas IDs")

local doorContainer = UI.Container(function(widget, items)
    storage.doorIds = items
    doorId = properTable(storage.doorIds)
end, true)

doorContainer:setHeight(35)
doorContainer:setItems(storage.doorIds)
doorId = properTable(storage.doorIds)

clickDoor = macro(100, "Abrir Portas", function()
    for i, tile in ipairs(g_map.getTiles(posz())) do
        local item = tile:getTopUseThing()
        if item and table.find(doorId, item:getId()) then
            local tPos = tile:getPosition()
            local distance = getDistanceBetween(pos(), tPos)
            if (distance <= useDistance) then
                use(item)
                return delay(useTime)
            end

            if (distance <= moveDist and distance > useDistance) then
                if findPath(pos(), tPos, moveDist, { ignoreNonPathable = true, precision = 1 }) then
                    autoWalk(tPos, moveTime, { ignoreNonPathable = true, precision = 1 })
                    return delay(waitTime)
                end
            end
        end
    end
end)
UI.Separator()
