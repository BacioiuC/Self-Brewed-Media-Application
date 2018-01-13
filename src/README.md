# Self-Brewed-Media-Application
A small media application to organize and view/browse your media library! It's a portfolio project for myself

**Features:**
- Browse media in a media folder and automagically sort if it's a video, image or audio file
- Play the media(video) that it detects using an external player 
- Display other media (non-video) using built-in functions 

### TO DO:
#### UI:
    Actual media will be featured on 3D Meshes
    Media data (or files) will be featured on 2D ui elements
    
- **Home screen with categories**
 -- Video | Stream | Images | Music | Settings | Browse
 -- Access each category interact with the contents
 -- Return to the home screen

    - **Video Category**

        -- List of all videos found
            -- Video has a preview
            -- Video has a description (dummy)
                -- Description pulled down from IMDB or content databases available online
            -- Video Meta Data 
                -- Length 
                -- Format

        -- **Streams**
            -- List of content that can be streamed from online sources
                -- Youtube (hook up playlist URL) 
                    -- List of videos in that playlist 
                        -- Relay to VLC individually 
                -- Sound cloud

        -- **Images**
            -- Display the image content on a 3D Quad
            -- Display images over background audio 
            -- Share/copy/move the images around

        -- **Settings**
            -- Control over Volume
            -- Fullscreen/Minimized
            -- Enable on startup 
            -- Separate option for a webservice to control the player from outside the computer 
                -- (Luvit and Lua) via post functions 

        -- **Browse**
            -- Local file browser 
                -- that allows you to execute media files in their propper category
                    -- if I select a video -> take us to the video category 
                        --> launch the video
            -- Ability to move / cut / copy all files on the root folder

#### BackEnd:
- **Relay information to VLC**

    -- Automagically setup parameters passed to the VLC app to know if it's on Windows or Linux (or any other OS)
- **Parse URL determine stream source**

    -- Best way to handle the stream 
- **Handle error reporting and crashes**
- **Detect media type / media source**
- **Allow skining (live or without the need to setup a new build)**


