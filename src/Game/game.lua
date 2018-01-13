--[[
* The MIT License
* Copyright (C) 2014 Bacioiu "Zapa" Ciprian (bacioiu.ciprian@gmail.com).  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom th be Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]
Game = {} -- MAIN CLASS

Game.modInUse = "" --



local Grid = require ("Game.lib.jumper.grid")
-- Calls the pathfinder class
local Pathfinder = require ("Game.lib.jumper.pathfinder")



-------------------------------------------
--------- GAME FILES ----------------------
--------------------------------------------
-- needed to allow images and animations to be loaded from /mods
-- doing this to avoid having to mantain two separate versions of my /Chaurus framework from /core
require "Game.wrapper.wImage"
require "Game.wrapper.wAnim"
require "Game.wrapper.wEffect"

require "Game.include_list"

--- WOOOHOO works!
for i,v in ipairs(includeList) do
	if v ~= "" then
		local prePath = "mods."..Game.modInUse.."."

		if isModuleAvailable(""..prePath..""..v.."") == false then
			prePath = "Game."
			local string = ""..prePath..""..v..""
			require("Game."..v.."")
		else
			--print("GOING FOR MODS")

			local string = ""..prePath..""..v..""
			require(""..prePath..""..v.."")	
		end
	end

end

require "core.StateMachine"
--------------------------------------
---- PATHFINDER INCLUDES -------------
---------------------------------------

require "gui/support/class"

zKey = false


function Game:exportOptions(_music, _audio, _perma, _scanLine, _infinite_mode)

end

function Game:importOptions( )

end



function Game:exportSaveInfo(_portalX, _portalY)

end

function Game:deleteSave( )
	if Game.optionSettings.permaDeath == 1 then
		os.remove("saves/current_run.lua")
	end
end

function Game:importSaveInfo( )

	
end

function Game:importDungeonLevel( )

end

function performWithDelay (delay, func, repeats, ...)
	local t = MOAITimer.new()
	t:setSpan( delay/100 )
	t:setListener( MOAITimer.EVENT_TIMER_LOOP,
	   function ()
	     t:stop()
	     t = nil
	     func( unpack( arg ) )
	        if repeats then
	            if repeats > 1 then
	                performWithDelay( delay, func, repeats - 1, unpack( arg ) )
	            elseif repeats == 0 then
	               performWithDelay( delay, func, 0, unpack( arg ) )
	            end
	        end
	   end
	 )
	t:start()
 end
--Game.freeCam = false
function Game:initGui( )
	
	g:addToResourcePath(filesystem.pathJoin("resources", "fonts"))
	g:addToResourcePath(filesystem.pathJoin("resources", "gui"))
	g:addToResourcePath(filesystem.pathJoin("resources", "media"))
	g:addToResourcePath(filesystem.pathJoin("resources", "themes"))
	g:addToResourcePath(filesystem.pathJoin("resources", "layouts"))

	layermgr.addLayer("gui", 99999, g:layer())
	g:setTheme(THEME_NAME)
	g:setCurrTextStyle("default")

	--- Background STATIC IMAGE

	--self.bg_l3_grid = mGrid:new(50, 50, 32, "Game/media/MGL_Clouds02.png", 1, "BLABLA", g_BackgroundLayer)
end

function Game:handleTurns(_turn)

end

function Game:prepareAllSounds( )
	--[[
	Game.optionSettings.musicLevel = 50
	Game.optionSettings.audioLevel = 25

	]]
	--sound:new(SOUND_MAIN_MENU, "Game/media/audio/bgmusic/grace_song_1_menus.ogg", Game.masterVolume, true, false)
	--[[Game.mainMenuSound = sound:new(1, "sounds/global_resonance_menu.ogg", Game.optionSettings.musicLevel/100, true, false)
	Game.inGameSound = sound:new(2, "sounds/dungeon002_0.ogg", Game.optionSettings.musicLevel/100, true, false)
	Game.uiSwitch = sound:new(3, "sounds/interface1.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.attack = sound:new(4, "sounds/sword-unsheathe4.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.walk = sound:new(5, "sounds/walk.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.dropItem = sound:new(5, "sounds/drop_item.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.potionSound = sound:new(5, "sounds/potion_use.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.pickupSound = sound:new(5, "sounds/pickup_sound.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.gun = sound:new(5, "sounds/gun.ogg", Game.optionSettings.audioLevel/100, false, false)
	Game.meteor = sound:new(5, "sounds/spell_earth.ogg", Game.optionSettings.audioLevel/100, false, false)
	MOAIUntzSystem:setVolume(Game.masterVolume)--]]


end

function Game:init( )


	Game:importOptions( )
	image:init()
	mGrid:init( )
	anim:init(0.01)
	mAnim:init(0.01)
	font:init( )
	effect:init( )
	Game:initGui( )
	interface:init(g, resources)
	initStates( )
	Game:loadOptionsState( )
	--self:prepareAllSounds( )
	
	
end

function Game:update( )


	Game.worldTimer = MOAISim.getElapsedTime( )
	--mGrid:_debugAnim(self.bg_l3_grid, 1, 5)
	Game:loopPersistantKeyPressed( )
	anim:update(Game.worldTimer)
	mAnim:update( )
	handleStates( )
	Game:cameraUpdate( )
end


function Game:draw( )


end

function Game:touchRight( )

end

function Game:revealAll( )
	map:revealAll( )
	items:revealAll( )
	sound:play(sound.revealEffect)
end

function Game:keypressed( key )
	
	--print("KEY IS: "..key.."")
	Game.persistantKey = true
	Game.key = key
	Game.keyTimer = Game.worldTimer
	local _st = state[currentState]
	mUI:input( key )


end

function Game:loopPersistantKeyPressed( )
	if Game.persistantKey == true then
		if Game.keyTimer ~= nil then
			if Game.worldTimer > Game.keyTimer + 0.5 then
				if _st == "GlobalGameJam" then
					local key = Game.key
					player:keypressed( key )
				elseif _st == "EDITOR" then
					editor:handleInput( key )
				end
			end
		end

	end
end

function Game:keyreleased( key )
	local _st = state[currentState]
	Game.persistantKey = false
	if _st == "ActionPhase" or _st == "MultiplayerPhase" then
		

	end
end

function Game:touchPressed (_idx)
	if Game.disableInteraction == false then
		_gTouchPressed = true
		local _st = state[currentState]

	end
end

function Game:touchLeftReleased ( )
	if Game.disableInteraction == false then
		local _st = state[currentState]

		_gTouchPressed = false
	end
end

function Game:dropUI(_gui, _resources)
	if (nil ~= _gui) then
		if (nil ~= widgets) then
        	unregisterScreenWidgets(widgets)
       	end
        _gui:layer():clear()
	end
end

function Game:touchReleased ( )
	if Game.disableInteraction == false then
		local _st = state[currentState]
		if _st == "Levels" then
			MouseDown = false
			camera:setJoystickHidden( )	
		elseif _st == "LevelEditor" then

		end
	end
	
end

function Game.touchLocation( x, y )
	
	Game.mouseX, Game.mouseY = core:returnLayerTable( )[1].layer:wndToWorld(x, y)
	Game.msX, Game.msY = x, y

	
	

end

function Game:cameraUpdate( )
	if Game.disableInteraction == false then 
		local _st = state[currentState]
		if _st == "ActionPhase"  or _st == "MultiplayerPhase" then
			unit:touchlocation(Game.mouseX, Game.mouseY)
		elseif _st == "Levels" then
			worldMap:touchlocation(Game.mouseX, Game.mouseY)
		elseif _st == "LevelEditor" then
			if _gTouchPressed == true then
				lEditor:touchpressed( )
			end
		end
	end
end

function Game:ViewportScale(_ammX, _ammY)
	core:returnViewPort( )[1].viewPort:setScale(core:returnVPWidth()/_ammX, -core:returnVPHeight()/_ammY)
end
--MOAIInputMgr.device.pointer:setCallback(Game.touchLocation)


function Game:initPathfinding(__grid)
	--grid = Grid(_grid) 
	
	--pather = Jumper(_grid, walkable, false)
	grid = Grid(__grid, false)
	_grid = Grid(__grid, false)
	pather = Pathfinder(grid, 'ASTAR', walkable)
	pather:setMode("ORTHOGONAL")
	
end

function Game:updatePathfinding()
	--grid = Grid(_grid) 
	--grid = Grid(_grid)
	--_grid = Grid(Game.grid)
	--pather = Pathfinder(_grid, 'JPS', walkable)
	--pather = Jumper(Game.grid, walkable, false)
	grid = Grid(Game.grid, false)
	--_grid = Grid(__grid, false)
	pather = Pathfinder(grid, 'ASTAR', walkable)
	pather:setMode("ORTHOGONAL")
end

function Game:setCollisionAt(_x, _y, _state)
	if _state == true then
		Game.grid[_x][_y] = walkable+200
	else
		Game.grid[_x][_y] = walkable
	end
	----print("GRID WIDTH: "..#Game.grid.." AND HEGHT: "..#Game.grid[#Game.grid].."")
	self:updatePathfinding( )
	Game:updatePathfinding()
end

function Game:loop( )
	Game:update( )
	Game:draw( )
end

function Game:drop( )
	
end

function onMouseLeftEvent(down)
  if (down) then
    g:injectMouseButtonDown(inputconstants.LEFT_MOUSE_BUTTON)
  else
    g:injectMouseButtonUp(inputconstants.LEFT_MOUSE_BUTTON)
  end
end

function Game:saveOptionsState( )
	local saveFile = "config.sv"
	--table.save(tb, "map/".._name..".col")
	local result = MOAIFileSystem.checkPathExists(pathToWrite.."config/")
	if result == false then
		MOAIFileSystem.affirmPath(pathToWrite.."config/")
	end
	table.save(Game.optionControls, ""..pathToWrite.."config/"..saveFile.."" )
	--print("SAVED INFO FROM OPTIONS MENU")
end

function Game:loadOptionsState( )

end

function Game:RESET( )
		

end