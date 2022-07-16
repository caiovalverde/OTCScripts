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
-- pill
 xtela,ytela = 585, 75

local widget = setupUI([[
Panel
  height: 400
  width: 900
]], g_ui.getRootWidget())

local timespell99 = g_ui.loadUIFromString([[
Label
  color: white
  background-color: black
  opacity: 1
  text-horizontal-auto-resize: true
]], widget)

macro(1, function()
 if not storage.time99.t or storage.time99.t < now then
  timespell99:setText('Pill: OK')
  timespell99:setColor('green')
 else
  timespell99:setColor('red')
  timespell99:setText("Pill CD: ".. string.format("%.0f",(storage.time99.t-now)/1000).. "s")
 end
end)


if type(storage.time99) ~= 'table' or (storage.time99.t - now) > 60000 then
 storage.time99 = {t = 0}
end

timespell99:setPosition({y = ytela+40, x =  xtela+20})

macro(50, "Pill", function(macro)
if not storage.time99.t or storage.time99.t < now then
g_game.useInventoryItem("15396")
 storage.time99.t = now + 40000
end
end)
-- 
--open doors
local wsadWalking = modules.game_walking.wsadWalking
local doorsIds = {1666,5120,5129,6264,6262,6207,6252,6249,6195,1629,11347,1648,11115,5102}

function checkForDoors(pos)
  local tile = g_map.getTile(pos)
  if tile then
    local useThing = tile:getTopUseThing()
    if useThing and table.find(doorsIds, useThing:getId()) then
      g_game.use(useThing)
    end
  end
end
