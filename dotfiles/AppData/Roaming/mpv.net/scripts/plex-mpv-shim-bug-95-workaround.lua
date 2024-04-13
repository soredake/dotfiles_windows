-- Import the mpv functions
local mp = require 'mp'

-- Function to set the 'sub-pos' property as a workaround for https://github.com/iwalton3/plex-mpv-shim/issues/95
local function set_sub_pos()
    -- Set the 'sub-pos' property to 95
    mp.set_property("sub-pos", 95)

    -- Print a debug message
    print("Set sub-pos to 95")
end

-- Register the event handler for file-loaded
mp.register_event("playback-restart", set_sub_pos)

-- Print a debug message
print("Script has started, waiting for file-loaded event...")
