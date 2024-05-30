-- Created as soft of workaround for https://github.com/iamkroot/trakt-scrobbler/issues/202
-- Define your custom callback function
function syncplay_switch_to_next_playlist_item()
  mp.command('print-text "<chat>/qn</chat>"')
end

-- Bind the "Ctrl+n" key to my function
mp.add_key_binding("Ctrl+n", "my_custom_key", syncplay_switch_to_next_playlist_item)
