tvDB = { }

function tvDB:init( )
    self._apiKey = "D3005651F1AC3559"
    self._tvDBurl = "http://thetvdb.com/"

    --[[
xmlmirrors, bannermirrors, and zipmirrors        
    ]]
    self._xmlMirrors = { }
    self._bannerMirrors = { }
    self._zipMirrors = { }

    print("tvDataBase::Inited( )")


    self:getListOfMirrors( )
    self:_getSeries("DragonBall")
end

function tvDB:getListOfMirrors( )
    -- check if file mirrors.xml exists
    local path = fileSystem:getGlobalProjectPath( )
    local bool = false
    if fileSystem:file_exists(""..path.."mirrors.xml") == true then
        bool = true
    end

    if bool == false then
        local urlForMirrorXML = self._tvDBurl.."api/"..self._apiKey.."/mirrors.xml"
        local popen = io.popen("wget "..urlForMirrorXML.."")
        popen:close( )
        print("File has been downloaded... Refresh everything")
    else
        print("Mirrors XML exists")
    end
end

function tvDB:getListOfLanguages( )

end

function tvDB:_getSeries(_name)
-- http://thetvdb.com/api/GetSeries.php?seriesname=
    local url = "http://thetvdb.com/api/GetSeries.php?seriesname=".._name..""
    print("FULL URL: "..url.."")
    local popen = io.popen("wget "..url.." -q -O -")
    local output = popen:read('*all')
    popen:close( )

    if output ~= nil then
        local seriesIDFirstLocation = string.find(output, "<seriesid>")
        if seriesIDFirstLocation ~= nil then
            local seriesIDEndLocation = string.find(output, "</seriesid>")
            local seriesID = string.sub(output, seriesIDFirstLocation+10, seriesIDEndLocation-1)
            if seriesID ~= nil then
                print("SERIES: "..seriesID.."")

                -- get banners 
                -- http://thetvdb.com/api/D3005651F1AC3559/series/

                print("BANNER URL ================================================================================")
                local bannerUrl = "http://thetvdb.com/api/"..self._apiKey.."/series/"..seriesID.."/banners.xml"
                print("Bannerl url: "..bannerUrl.."")
                local popen = io.popen("wget "..bannerUrl.." -q -O -")
                local output = popen:read('*all')
                popen:close( )

                local bannerPathFirstLocation = string.find(output, "<BannerPath>")
                local bannerPathEndLocation = string.find(output, "</BannerPath>")
                local bannerPath = string.sub(output, bannerPathFirstLocation+12, bannerPathEndLocation-1)

                local fullBannerUrl = "https://www.thetvdb.com/banners/"..bannerPath..""
                print("Full banner url: ".."https://www.thetvdb.com/banners/"..bannerPath.."")

                print("Downloading banner")

                --/home/zapa/projects/Self-Brewed-Media-Application/src/Game/fileSystem

                local downloadPath = ""..fileSystem:getGlobalProjectPath( ).."Game/fileSystem/db"..""
                print(""..downloadPath.."")
                local downloadBannerPopen = io.popen("wget -P "..downloadPath.." -A jpeg,jpg  "..fullBannerUrl.." -O '".._name..".jpg' ")
                downloadBannerPopen:close( )

                local mvFileToDb = io.popen("mv ".._name..".jpg "..downloadPath.."")
                mvFileToDb:close( )
                --" https://www.thetvdb.com/banners/fanart/original/76666-2.jpg
                --print(output)
            end
        end
    else
        print("Cannot get series information")
    end
end

