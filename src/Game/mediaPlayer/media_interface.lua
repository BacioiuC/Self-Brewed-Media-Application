mUI = {}

function mUI:init( )
    print("UI Is loaded")
    local roots, widgets, groups = g:loadLayout(resources.getPath("dashboard.lua"))

    self._categoryBackground = widgets.category_background.window

    self._currentCategoryIDX = 1
    self._categoryLabelInitialOffset = 5
    self._categoryLabelInitialYOffset = 1

    self._categoryWindowYPosition = 20
    self._categoryWindowXFocusedPosition = 5
    self._categoryWindowXUnFocusedPosition = -200

    -- Unfocused = away from the screen
    self._categoryWindowUnFocusedPosition = { x =  self._categoryWindowXUnFocusedPosition, y = self._categoryWindowYPosition}

    -- Focused = on screen
    self._categoryWindowFocusedPosition = { x =  self._categoryWindowXFocusedPosition, y = self._categoryWindowYPosition}

    self:setupBackground( )
    self:setupCategoryButtons( )

    self:updateButtonColor( )
end

-- db Prefix stands for dashBoard
-- Video | Stream | Images | Music | Settings | Browse
function mUI:setupCategoryButtons( )

    self._dbCategoryButtonTable = { }
    self._dbCategoryWindowTable = { }
    self._dbCategoryStringTable = "" 



    self._categoryNameSizeMultiplier = 2

    self._dbCategoryButtonNameTable = { }
    self._dbCategoryButtonNameTable[1] = "Video"
    self._dbCategoryButtonNameTable[2] = "Stream"
    self._dbCategoryButtonNameTable[3] = "Images"
    self._dbCategoryButtonNameTable[4] = "Music"
    self._dbCategoryButtonNameTable[5] = "Settings"
    self._dbCategoryButtonNameTable[6] = "Browse"

    
    self._positionXOffset = #self._dbCategoryButtonNameTable[1] * self._categoryNameSizeMultiplier
    self._positionX = self._categoryLabelInitialOffset - self._positionXOffset

    for i = 1, #self._dbCategoryButtonNameTable do 
        self:createCategoryButtons(self._dbCategoryButtonNameTable[i])
        self:createCategoryWindow(self._dbCategoryButtonNameTable[i])
    end

    self:updateDashboardButtons( )

end

function mUI:createCategoryButtons(_buttonName)
    local temp = { }
   
    self._positionX = self._positionX + self._positionXOffset

    temp.label = element.gui:createLabel( )
    temp.label:setText("".._buttonName.."")
    temp.label:setPos(self._positionX, self._categoryLabelInitialYOffset)
    temp.label:setDim(40, 10)

    self._positionXOffset = #_buttonName * self._categoryNameSizeMultiplier + self._categoryNameSizeMultiplier
    
    table.insert(self._dbCategoryButtonTable, temp)
end

function mUI:createCategoryWindow(_categoryName)
    local temp = { }

    temp.window = element.gui:createImage( )
    temp.window:setImage(resources.getPath("../../media/ui_elements/category_window_background.png"), 1, 1, 1, 1)
    temp.window:setPos(self._categoryWindowXFocusedPosition, self._categoryWindowYPosition)
    temp.window:setDim(90, 75)
    temp.name = "".._categoryName..""

    table.insert(self._dbCategoryWindowTable, temp)

    self:_createDummyEntriesOnWindows(temp.window, _categoryName)
end

function mUI:_createDummyEntriesOnWindows(_windowName, _categoryName)
    local temp = {}
    temp.label = element.gui:createLabel( )
    temp.label:setText("".._categoryName.."")
    temp.label:setPos(40, 2)
    temp.label:setDim( 20, 20)

    _windowName:addChild(temp.label)

end

function mUI:updateFocusedWindow( )
    for i = 1, #self._dbCategoryWindowTable do
        local v = self._dbCategoryWindowTable[i]
        if i == self._currentCategoryIDX then
            v.window:tweenPos(self._categoryWindowFocusedPosition.x,  self._categoryWindowFocusedPosition.y)
        else
            v.window:setPos( self._categoryWindowUnFocusedPosition.x,  self._categoryWindowUnFocusedPosition.y)
        end
    end
end

function mUI:updateButtonColor( )
    for i = 1, #self._dbCategoryButtonTable do
        local v = self._dbCategoryButtonTable[i]
        if i == self._currentCategoryIDX then
            v.label:setText("<c:fff600>"..self._dbCategoryButtonNameTable[i].."</c>")
        else
            v.label:setText("<c:ffffff>"..self._dbCategoryButtonNameTable[i].."</c>")
        end
    end
end

function mUI:updateDashboardButtons( )
    for i,v in ipairs(self._dbCategoryButtonTable) do
        self._categoryBackground:addChild(v.label)
    end
end

function mUI:setupBackground( )
    print("Setting up the background color")
	self._colorTimer = Game.worldTimer
	self._colorChangeTimer = 1 -- seconds

	self._currentRed = 0.388
	self._currentGreen = 0.608
	self._currentBlue = 1

	self._colorTable = {}
	self._colorTable[1] = {r = 0.388, g = 0.608, b = 1}	
	self._colorTable[2] = {r = 0.133, g = 0.125, b = 0.2}	
	self._colorTable[3] = {r = 0.216, g = 0.58, b = 0.431}	--0.216, 0.58, 0.431
	self._colorTable[4] = {r = 0.196, g = 0.235, b = 0.224}	
	self._colorTable[5] = {r = 0.851, g = 0.341, b = 0.388}	-- 0.851, 0.341, 0.388
	self._colorTable[6] = {r = 0.561, g = 0.59, b = 0.29}	-- 0.561, 0.592, 0.29

	--0.133, 0.125, 0.2 0.196, 0.235, 0.224

	self._colorStep = 1
	self._lerpColor = false
	setClearColor(self._colorTable[self._colorStep].r, self._colorTable[self._colorStep].g, self._colorTable[self._colorStep].b , 1)
end


function mUI:changeBackgroundColor( )
	
	if Game.worldTimer > self._colorTimer + self._colorChangeTimer then
		self._colorStep = self._colorStep + 1
		if self._colorStep > #self._colorTable then self._colorStep = 1 end
		self._colorTimer = Game.worldTimer
	else
        self._currentRed = self._currentRed + (self._colorTable[self._colorStep].r - self._currentRed) * 0.01  
        self._currentGreen = self._currentGreen + (self._colorTable[self._colorStep].g - self._currentGreen) * 0.01  
        self._currentBlue = self._currentBlue + (self._colorTable[self._colorStep].b - self._currentBlue) * 0.01 
		setClearColor(self._currentRed, self._currentGreen, self._currentBlue , 1)
	end

end

function mUI:update( )
    self:changeBackgroundColor( )
    self:updateFocusedWindow( )
end


function mUI:input( key )
    if key == KEY_A then
        self._currentCategoryIDX = self._currentCategoryIDX - 1
    elseif key == KEY_D then
        self._currentCategoryIDX = self._currentCategoryIDX  + 1
    end

    

    if self._currentCategoryIDX < 1 then
        self._currentCategoryIDX = #self._dbCategoryButtonTable
    end

    if self._currentCategoryIDX > #self._dbCategoryButtonTable then
        self._currentCategoryIDX = 1
    end

    self:updateButtonColor( )
end