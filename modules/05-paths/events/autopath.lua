--[[
  @Authors: Ben Dol (BeniS)
  @Details: Auto pathing event logic
]]
local positions = {}

PathsModule.AutoPath = {}
AutoPath = PathsModule.AutoPath

local startCheckEvent
local stopCheckEvent

local currentDestinationIndex

local checkTicks = 500

-- Variables

-- Methods
function canAutoWalk()
  local player = g_game.getLocalPlayer()
  if g_game.isAttacking() then
    return false
  end

  if AutoLoot.isLooting() then
    return false
  end

  if not player:canWalk() then
    return false
  end

  if player:isAutoWalking() or player:isServerWalking() then
    return false
  end

  return true
end

function followRoutes()
  if not currentDestinationIndex then
    currentDestinationIndex = 1
  end

  if currentDestinationIndex > 1 and not positions[currentDestinationIndex] then
    currentDestinationIndex = 1
  end

  local player = g_game.getLocalPlayer()
  local pos = positions[currentDestinationIndex]
  local playerPos = player:getPosition()
  if pos and Position.equals(pos, playerPos) then
    currentDestinationIndex = currentDestinationIndex + 1
    pos = positions[currentDestinationIndex]
  end

  if pos then
    player:autoWalk(pos)
  end
end

function AutoPath.init()
end

function AutoPath.terminate()
  --
end

function AutoPath.addPath(pos)
  table.insert(positions, pos)
  PathsModule.updatePathsList(positions)
end

function AutoPath.clear()
  positions = {}
  PathsModule.updatePathsList(positions)
end

function AutoPath.onStopped()
  --
end

function AutoPath.Event(event)
  if canAutoWalk() then
    followRoutes()
  end
  return Helper.safeDelay(600, 1400)
end