setDefaultTab("Foi")
-- Dancinha
macro(250, "Dancinha", "Ctrl+D", function()
    turn(math.random(0, 3)) -- turn to a random direction.
 end)

UI.Separator()

-- pill
if type(storage.time99) ~= 'table' or (storage.time99.t - now) > 60000 then
 storage.time99 = {t = 0}
end

macro(50, "Pill", function(macro)
if not storage.time99.t or storage.time99.t < now then
g_game.useInventoryItem(pilula)
 storage.time99.t = now + 40000
end
end)

UI.Label("Pilula:")
addTextEdit("Pilula", storage.pilula or "Pilula", function(widget, text)
    storage.pilula = text
    pilula = tostring(text)

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
