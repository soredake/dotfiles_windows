// I use translation addon
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978368
user_pref("browser.translations.enable", false);

// https://bugzilla.mozilla.org/show_bug.cgi?id=1693007
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978371
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// https://bugzilla.mozilla.org/show_bug.cgi?id=1746396
// https://bugzilla.mozilla.org/show_bug.cgi?id=1783225
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978372
user_pref("network.predictor.enable-prefetch", true);

// https://www.reddit.com/r/firefox/comments/9ub5fg/rant_awful_scrolling_in_firefox/e93d5pc
// https://bugzilla.mozilla.org/show_bug.cgi?id=1720146
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978374
// user_pref("general.smoothScroll.msdPhysics.enabled", true);

// Fonts on windows are looking better with this
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802692
// https://bugzilla.mozilla.org/show_bug.cgi?id=1829313
user_pref("gfx.font_rendering.cleartype_params.enhanced_contrast", 0);

// https://github.com/yokoffing/Betterfox/blob/main/Fastfox.js
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978502
// user_pref("content.notify.interval", 100000); // (.10s); default=120000 (.12s)
user_pref("gfx.canvas.accelerated.cache-size", 512); // default=256; Chrome=512
user_pref("gfx.content.skia-font-cache-size", 20); // default=5; Chrome=20
user_pref("media.memory_cache_max_size", 65536); // default=8192; AF=65536; alt=131072
user_pref("media.cache_readahead_limit", 7200); // 120 min; default=60; stop reading ahead when our buffered data is this many seconds ahead of the current playback
user_pref("media.cache_resume_threshold", 3600); // 60 min; default=30; when a network connection is suspended, don't resume it until the amount of buffered data falls below this threshold
user_pref("image.mem.decode_bytes_at_a_time", 32768); // default=16384; alt=65536; chunk size for calls to the image decoders
user_pref("network.http.max-connections", 1800); // default=900
user_pref("network.http.max-persistent-connections-per-server", 10); // default=6; download connections; anything above 10 is excessive
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5); // default=3
// user_pref("network.dnsCacheExpiration", 3600); // keep entries for 1 hour
user_pref("network.ssl_tokens_cache_capacity", 10240); // default=2048; more TLS token caching (fast reconnects)
// user_pref("browser.cache.memory.capacity", 131072); // (128 MB)
user_pref("browser.cache.memory.max_entry_size", 20480); // (20 MB); default=5120 (5 MB)
// user_pref("browser.sessionhistory.max_total_viewers", 4);

// https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978376
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", "2");
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
user_pref("general.smoothScroll.currentVelocityWeighting", "1");
user_pref("general.smoothScroll.stopDecelerationWeighting", "1");
user_pref("mousewheel.default.delta_multiplier_y", 300); // 250-400; adjust this number to your liking
