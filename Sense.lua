local mapPanel = modules.game_interface.getMapPanel()

local spellWidget = [[
Panel
  background-color: black
  padding: 0 5
  text-auto-resize-horizontal: true
]]


Sense = {}
  
Sense.elapsed = 0
  
Sense.distance = 0
  
Sense.onScreen = setupUI(spellWidget, mapPanel)
  
Sense.actualText = function(text)
  if not text then return end
  text = text:split(', ')
  text[2] = 'E' .. Sense.revertElapsed()
  text[3] = Sense.actualDistance(Sense.Distance)
  local texto
  for _, string in ipairs(text) do
      if texto then
          texto = texto .. ', ' .. string
      else
          texto = string
      end
  end
  return texto
end
  
Sense.actualDistance = function(n)
  n = tonumber(n)
  return math.abs(n - getDistanceBetween(Sense.lastPosition, player:getPosition()))
end
    
  
macro(1, function()
  local getC = Sense.Text and getCreatureByName(Sense.Text:split(', ')[1])
  if Sense.elapsed == 0 or (getC and getDistanceBetween(getC:getPosition(), player:getPosition()) <= 7) then
    Sense.onScreen:setHeight(0)
      return Sense.onScreen:clearText()
  end
  if not Sense.Count or Sense.Count < now then
      if Sense.Count then
          Sense.elapsed = Sense.elapsed - 1
      end
      Sense.Count = now + 1000
  end
  Sense.onScreen:setText(Sense.actualText(Sense.Text))
end)
  
Sense.revertElapsed = function()
  return math.abs(Sense.elapsed - 30)
end
  
  
  
Sense.actualPosition = function(text)
  if text == 'north' then
       return {x = -50, y = -230}
  elseif text == 'south' then
      return {x = -50, y = 80}
  elseif text == 'west' then
      return {x = -220, y = -80}
  elseif text == 'east' then
      return {x = 200, y = -30}
  elseif text == 'north-east' then
      return {x = 170, y = -150}
  elseif text == 'south-east' then
      return {x = 100, y = 20}
  elseif text == 'north-west' then
      return {x = -180, y = -150}
  elseif text == 'south-west' then
      return {x = -180, y = 100}
  end
end
  
Sense.setPosition = function(position)
  position.x = math.ceil(mapPanel:getWidth() / 2) + position.x
  position.y = math.ceil(mapPanel:getHeight() / 2) + position.y
  return Sense.onScreen:setPosition(position)
end
  
Sense.setPrimary = function(texto, cor)
  if cor == 'very far' then
      Sense.onScreen:setColor('red')
  elseif cor == 'far' then
      Sense.onScreen:setColor('yellow')
  elseif cor == '' or cor == 'on a higher level' or cor == 'on a lower level' then
      Sense.onScreen:setColor('white')
  end
  Sense.elapsed = 30
  Sense.Count = nil
  Sense.setText(texto, Sense.elapsed, cor)
end
  
  
Sense.convertTodistance = function(text)
  if text == 'very far' then
      return 375
  elseif text == 'far' then
      return 190
  elseif text == 'on a higher level' then
      return {60, 'Up'}
  elseif text == 'on a lower level' then
      return {60, 'Down'}
  elseif text == '' then
      return 60
  end
end
  
Sense.setText = function(texto, tempo, distancia)
  distancia = Sense.convertTodistance(distancia)
  Sense.Distance = distancia
  if type(distancia) == 'table' then
       Sense.Distance = distancia[1]
      distancia = distancia[1] .. ', ' .. distancia[2]
  end
  Sense.Text = texto .. ', ' .. 'E' .. Sense.elapsed ..  ', ' .. distancia
end
  
  
  
onTextMessage(function(mode, text)
  if mode == 20 then
    local regex = "([a-z A-Z]*) is ([a-z -A-Z]*)to the ([a-z -A-Z]*)."
      local senseData = regexMatch(text, regex)[1]
      if senseData then
          if senseData[2] and senseData[3] and senseData[4] then
            Sense.setPosition(Sense.actualPosition(senseData[4]:trim()))
            Sense.setPrimary(senseData[2]:trim(), senseData[3]:trim())
            Sense.lastPosition = player:getPosition()
          end
      end
  end
end)
