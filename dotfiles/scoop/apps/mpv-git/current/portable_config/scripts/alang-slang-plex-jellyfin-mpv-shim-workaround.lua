-- Import the mpv functions
local mp = require 'mp'

-- Function to split a comma-separated string into a table
local function split_string(inputstr, sep)
    sep = sep or ","
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

-- Split script into selecting subs or audio
-- Function to select tracks according to existing 'alang' and 'slang' properties
local function set_alang_slang_settings()
    -- Print a debug message
    print("Selecting tracks based on existing alang and slang settings")

    -- Helper function to select the best track based on language
    local function select_best_track(track_list, langs)
        for _, lang in ipairs(langs) do
            for _, track in ipairs(track_list) do
                if track.lang and track.lang:match("^" .. lang .. "$") then
                    return track.id
                end
            end
        end
        return nil
    end

    -- Get the list of available audio and subtitle tracks
    local tracks = mp.get_property_native("track-list", {})

    -- Separate audio and subtitle tracks
    local audio_tracks = {}
    local subtitle_tracks = {}
    for _, track in ipairs(tracks) do
        if track.type == "audio" then
            table.insert(audio_tracks, track)
        elseif track.type == "sub" then
            table.insert(subtitle_tracks, track)
        end
    end

    -- Get alang and slang properties from mpv
    local alang = mp.get_property("alang")
    local slang = mp.get_property("slang")

    -- Generate preferred languages list from alang and slang properties
    local preferred_audio_langs = split_string(alang)
    local preferred_subtitle_langs = split_string(slang)

    -- Select the best audio and subtitle tracks based on preferred languages
    local best_audio_track = select_best_track(audio_tracks, preferred_audio_langs)
    local best_subtitle_track = select_best_track(subtitle_tracks, preferred_subtitle_langs)

    -- Debug output of selected track IDs
    print("Best audio track ID:", best_audio_track)
    print("Best subtitle track ID:", best_subtitle_track)

    -- Set the audio and subtitle tracks if found
    if best_audio_track then
        mp.set_property_number("aid", best_audio_track)
    end
    if best_subtitle_track then
        mp.set_property_number("sid", best_subtitle_track)
    end
end

-- https://github.com/CogentRedTester/mpv-sub-select?tab=readme-ov-file#commands
function trigger_sub_select()
    mp.command("script-message select-subtitles")
  end

-- Function to set alang and slang settings after a 5-second delay
local function delayed_set_alang_slang_settings()
    mp.add_timeout(1, set_alang_slang_settings)
    mp.add_timeout(2, trigger_sub_select)
end

-- Check if the input-ipc-server property is set to plexshimsocket
local ipc_server = mp.get_property("input-ipc-server")

if ipc_server == "plexshimsocket" then
    -- Register the event handler for playback-restart
    mp.register_event("playback-restart", delayed_set_alang_slang_settings)
    -- Print a debug message
    print("Script has started, waiting for playback-restart event...")
else
    print("input-ipc-server is not set to plexshimsocket, script will not run.")
end
