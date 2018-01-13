fileSystem = {}
--D3005651F1AC3559 API Key

function fileSystem:init( )
    print("FileSystem::Inited( )")
    self._globalProjectPath = "/home/zapa/projects/Self-Brewed-Media-Application/src/"
    self._path = {}
    self._path[1] = ""..self._globalProjectPath.."/Game/fileSystem/Videos/"
    self._path[2] = ""..self._globalProjectPath.."/Game/fileSystem/Stream/"
    self._path[3] = ""..self._globalProjectPath.."/Game/fileSystem/Images/"
    self._path[4] = ""..self._globalProjectPath.."/Game/fileSystem/Music/"
    local content = self:getContentFromLibrary(1)
end

function fileSystem:getGlobalProjectPath( )
    return ""..self._globalProjectPath..""
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


function fileSystem:file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function fileSystem:GetFileName(url)
  return url:match("^.+/(.+)$")
end

function fileSystem:GetFileExtension(url)
  return url:match("^.+(%..+)$")
end