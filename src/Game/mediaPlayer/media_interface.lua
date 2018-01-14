mUI = {}

function mUI:init( )
    print("UI Is loaded")
    mHierarchy:init( )
    fileSystem:init( )
    tvDB:init( )

    local roots, widgets, groups = g:loadLayout(resources.getPath("dashboard.lua"))

    self._backgroundImage = widgets.backGround.window
    self._categoryBackground = widgets.category_background.window



    self._currentCategoryIDX = 1
    self._currentFocusedUIHierarchy = {}

    self._currentWindowContentIDX = 1


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
    self:setupMediaDataBase( )

    self:_getContentFromMediaDB( )

    self:updateButtonColor( )

    
end

function mUI:setupMediaDataBase( )
    self._mediaDB = { }
    for i = 1, #self._dbCategoryButtonNameTable do
        self._mediaDB[i] = {}
    end


    local catToFill = 1 -- Video category
    for j = 1, #self._dbCategoryButtonNameTable do
        local contentList = fileSystem:getContentFromLibrary(j)
        if contentList ~= nil then
            for i = 1, #contentList do
                self._mediaDB[j][i] = { }
                self._mediaDB[j][i].content = ""..contentList[i]..""
                local name = self._mediaDB[j][i].content:match("(.+)%..+")
                print(">_____________________________________")
                print("NAME: "..name.."")
                self._mediaDB[j][i].name = name
                local fileExists = fileSystem:file_exists(""..fileSystem:getGlobalProjectPath( ).."Game/fileSystem/db".."/"..name..".jpg")
                if fileExists == false then
                    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                    local image = tvDB:_getSeries(name)
                else
                    print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
                end
            end
        end
    end
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


    self._windowContentTable = { }
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
    temp.content = {}
    table.insert(self._dbCategoryWindowTable, temp)

    --self._windowContentTable[#self._windowContentTable] = { }
    self:_createDummyEntriesOnWindows(temp, _categoryName)
end

function mUI:_createDummyEntriesOnWindows(_windowName, _categoryName)
    local temp = {}
    temp.label = element.gui:createLabel( )
    temp.label:setText("".._categoryName.."")
    temp.label:setPos(40, 2)
    temp.label:setDim( 20, 20)

    table.insert(_windowName.content, temp)
    _windowName.window:addChild(temp.label)
end






function mUI:_getContentFromMediaDB( )
    for i = 1, #self._mediaDB do
        self:_addContentToWindow(self._mediaDB[i], i)
    end
end

function mUI:_addContentToWindow(_contentTable, _categoryID)
    for i = 1, #_contentTable do
        local temp = {}
        temp.image = element.gui:createImage( )
        local newPath = resources.getPath("../../Game/fileSystem/db".."/".._contentTable[i].name..".jpg")
        if newPath == nil then
            newPath = ""..fileSystem:getGlobalProjectPath( ).."/media/ui_elements/default_cover_art.png"
        end
        temp.image:setImage(newPath, 1, 1, 1, 1)
        temp.image:setDim(15, 20)
        temp.image:setPos(1+i*17-17, 1)
        temp.imagePath = "../../Game/fileSystem/db".."/".._contentTable[i].name..".jpg" --"../../media/ui_elements/default_cover_art.png"

        self._dbCategoryWindowTable[_categoryID].window:addChild(temp.image)
        table.insert(self._dbCategoryWindowTable[_categoryID].content, temp)
    end
end

function mUI:_highlightCurrentSelectedContent( )
    local currentCategory = self._currentCategoryIDX
    local currentContentIDX = self._currentWindowContentIDX


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
    if self._dbCategoryButtonTable ~= nil then
        for i = 1, #self._dbCategoryButtonTable do
            local v = self._dbCategoryButtonTable[i]
            if i == self._currentCategoryIDX then
                v.label:setText("<c:fff600>"..self._dbCategoryButtonNameTable[i].."</c>")
            else
                v.label:setText("<c:ffffff>"..self._dbCategoryButtonNameTable[i].."</c>")
            end
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

    local currentHierachy = mHierarchy:getCurrentDepth( )
    if key == KEY_W then
        currentHierachy = currentHierachy - 1
        --self._currentWindowContentIDX = 1
    elseif key == KEY_S then
        currentHierachy = currentHierachy + 1
        --self._currentWindowContentIDX = 1
    end
    
  
    self:handleHierachies(key)
    
    if currentHierachy ~= nil then
        if currentHierachy < 1 then currentHierachy = 1 end
        if currentHierachy > mHierarchy:getMaxDepth( ) then currentHierachy = mHierarchy:getMaxDepth( ) end
        mHierarchy:setDepth(currentHierachy)
    end

    self:updateButtonColor( )
end

function mUI:handleHierachies(key)
    local currentHierachy = mHierarchy:getCurrentDepth( )

    if currentHierachy == 1 then
        self:handleDashboardCategoryNavigation(key)
    elseif currentHierachy == 2 then
        self:handleWindowContentNavigation(key)
        --self_currentWindowContentIDX = 1
        
    end


    
end

function mUI:handleDashboardCategoryNavigation(key)
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
end

function mUI:handleWindowContentNavigation(key)
    if key == KEY_A then
        self._currentWindowContentIDX = self._currentWindowContentIDX - 1
    elseif key == KEY_D then
        self._currentWindowContentIDX = self._currentWindowContentIDX + 1
    end

    if self._currentWindowContentIDX < 2 then self._currentWindowContentIDX = 2 end
    if self._currentWindowContentIDX > #self._dbCategoryWindowTable[self._currentCategoryIDX].content then self._currentWindowContentIDX = #self._dbCategoryWindowTable[self._currentCategoryIDX].content end
    self:_updateContentHighlight( self._currentCategoryIDX)
end


function mUI:_updateContentHighlight(_categoryID)
    -- get window for that category
    if  self._dbCategoryWindowTable[_categoryID] ~= nil then
        local v = self._dbCategoryWindowTable[_categoryID]

        for i = 1, #self._dbCategoryWindowTable[_categoryID].content do
            local j = self._dbCategoryWindowTable[_categoryID].content[i]
            local bg = self._dbCategoryWindowTable[_categoryID].content[self._currentWindowContentIDX]
            if j.image ~= nil then
                local newPath = resources.getPath(self._dbCategoryWindowTable[_categoryID].content[i].imagePath)
                local newBgPath = resources.getPath(bg.imagePath)
                local transparency = 0.4
                if newPath == nil then
                    newPath = ""..fileSystem:getGlobalProjectPath( ).."/media/ui_elements/default_cover_art.png"
                    transparency = 0
                    newBgPath = ""..fileSystem:getGlobalProjectPath( ).."/media/ui_elements/default_cover_art.png"
                end
                self._backgroundImage:setImage(newBgPath, 1, 1, 1, transparency)
                if i == self._currentWindowContentIDX then
                    j.image:setImage(newPath, 1, 1, 1, 0.2)
                    j.image:setDim(16, 21)
                else
                    j.image:setImage(newPath, 1, 1, 1, 1)
                    j.image:setDim(15, 20)
                end
            end    
        end
    end

end
