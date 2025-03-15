-- Define the desired options
local desired_options = "ignore-no-formats-error=,mark-watched=,cookies-from-browser=firefox,sub-langs=\"en,en-en,uk,uk-uk\",write-auto-subs="

-- Function to update ytdl-raw-options and reload the video
function update_and_reload()
    -- Update the ytdl-raw-options property
    mp.set_property("ytdl-raw-options", desired_options)
    
    -- Log the updated options to the console
    mp.msg.info("ytdl-raw-options set to: " .. desired_options)

    -- Get the current URL
    local current_url = mp.get_property("path")

    -- Reloading video
    mp.commandv("script-message", "reload_resume")
end

-- Bind the function to the Ctrl+j key
mp.add_key_binding("Ctrl+j", "update_and_reload", update_and_reload)
