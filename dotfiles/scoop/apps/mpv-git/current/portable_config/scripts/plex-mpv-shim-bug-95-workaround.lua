-- Import the mpv functions
local mp = require 'mp'

-- Function to set the 'sub-pos' property as a workaround for https://github.com/iwalton3/plex-mpv-shim/issues/95
local function set_sub_pos()
    -- Set the 'sub-pos' property to 95
    mp.set_property("sub-pos", 95)

    -- Print a debug message
    print("Set sub-pos to 95")
end

-- Function to set alang and slang settings after a 3-second delay
local function delayed_set_sub_pos()
    mp.add_timeout(3, set_sub_pos)
end

-- Check if the input-ipc-server property is set to plexshimsocket
local ipc_server = mp.get_property("input-ipc-server")

if ipc_server == "plexshimsocket" then
    -- Register the event handler for playback-restart
    mp.register_event("playback-restart", delayed_set_sub_pos)
    -- Print a debug message
    print("Script has started, waiting for playback-restart event...")
else
    print("input-ipc-server is not set to plexshimsocket, script will not run.")
end
