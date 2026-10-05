-- File: d3d11_composition.lua
-- Description: Sets mpv's d3d11-output-mode option to 'composition'

local function set_d3d11_composition()
    mp.set_property("d3d11-output-mode", "composition")
    mp.osd_message("d3d11-output-mode: composition")
end

-- Key binding (default: Ctrl+g)
mp.add_key_binding("Ctrl+g", "set-d3d11-composition", set_d3d11_composition)
