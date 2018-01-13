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

state = {}
_bGuiLoaded = false

function initStates( )
	state[1] = "Intro"
	state[2] = "MainApp"
	--currentState = 2
	currentState = 2

	_bGuiLoaded = false
	_bGameLoaded = false
end

function handleStates( )

	local _st = state[currentState]
	--print("CURRENT STATE: ".._st.."")

	if _st == "Intro" then
		introLoop( )
	elseif _st == "MainApp" then
		mainApp( )
	else
		print("STATE OUT OF BOUNDS")
	end
end



function mainApp( )
	if _bGameLoaded == false then
		_bGameLoaded = true
	else
	

	end

	if _bGuiLoaded == false then
		mUI:init( )
		_bGuiLoaded = true

	else
		mUI:update( )
	end
end




function introLoop( )
	if _bGameLoaded == false then
		_bGameLoaded = true
	
	else
	

	end

	if _bGuiLoaded == false then
		--camera:init( )
		
		interface:_setupLoadScreen( )
		_bGuiLoaded = true

	else
		interface:_switchTo_introText( )
	end
	
end

function drop( )
	_bGuiLoaded = false
end