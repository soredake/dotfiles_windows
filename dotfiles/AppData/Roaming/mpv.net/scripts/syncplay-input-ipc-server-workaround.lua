-- Import the mpv functions
local mp = require 'mp'

-- Function to check the property and set the ipc server
local function check_property_and_set_ipc_server()
    -- Get the value of the 'osd-align-y' property
    local osd_align_y = mp.get_property("osd-align-y")

    -- Print a debug message
    print("osd-align-y is: " .. osd_align_y)

    -- Check if the property is not 'bottom'
    if osd_align_y ~= "bottom" then
        -- Set the 'input-ipc-server' property
        -- mp.set_property("input-ipc-server", "\\\\.\\pipe\\mpvsocket")

        -- Print a debug message
        print("Set input-ipc-server to \\\\.\\pipe\\mpvsocket")
    else
        -- Print a debug message
        print("osd-align-y is 'bottom', so input-ipc-server was not set")
    end
end

-- Wait for 5 seconds after player start, then call the function
mp.add_timeout(5, check_property_and_set_ipc_server)

-- Print a debug message
print("Script has started, waiting for 10 seconds...")
