fileSystem = {}
--D3005651F1AC3559 API Key

function fileSystem:init( )
    print("FileSystem::Inited( )")
    self._path = {}
    self._path[1] = "/home/zapa/projects/Self-Brewed-Media-Application/src/Game/fileSystem/Videos/"
    self._path[2] = "/home/zapa/projects/Self-Brewed-Media-Application/src/Game/fileSystem/Stream/"
    self._path[3] = "/home/zapa/projects/Self-Brewed-Media-Application/src/Game/fileSystem/Images/"
    self._path[4] = "/home/zapa/projects/Self-Brewed-Media-Application/src/Game/fileSystem/Music/"
    local content = self:getContentFromLibrary(1)
end



function fileSystem:getContentFromLibrary(_id)
    local content
    if _id < 5 then
        content = self:scandir(""..self._path[_id].."")
    end
    return content
end

function fileSystem:scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        if #filename > 2 then -- make sure to not include . / ..
           i = i + 1
           t[i] = filename
        end
    end
    pfile:close()
    return t
end
