mHierarchy =  {}

-- handles the cursor position in the window hierarchy.
-- Top most hierarchy is the category bar that you can navigate with <LEFT>/<RIGHT> controls
-- Second hierachy is the window content for the selected category
function mHierarchy:init( )
    self._hDepth = 1 -- top of the screen, in the category window
    self._hMaxDepth = 3
    print("Hierachies are a go-go")
end

function mHierarchy:getCurrentDepth( )
    return self._hDepth
end

function mHierarchy:setDepth(_depth)
    self._hDepth = _depth
end

function mHierarchy:getMaxDepth( )
    return self._hMaxDepth 
end