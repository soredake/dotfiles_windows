// https://bugzilla.mozilla.org/show_bug.cgi?id=1693007
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978371
// TODO: report here https://connect.mozilla.org/t5/ideas/idb-p/ideas
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// https://www.reddit.com/r/firefox/comments/9ub5fg/rant_awful_scrolling_in_firefox/e93d5pc
// https://bugzilla.mozilla.org/show_bug.cgi?id=1720146
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978374
// user_pref("general.smoothScroll.msdPhysics.enabled", true);

// Fonts on windows are looking better with this
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802692
// https://bugzilla.mozilla.org/show_bug.cgi?id=1829313
// TODO: report to firefox https://github.com/brave/brave-browser/issues/5032
// chrome/edge have better fonts, report to bugzilla
// TODO: report here https://connect.mozilla.org/t5/ideas/idb-p/ideas
user_pref("gfx.font_rendering.cleartype_params.enhanced_contrast", 0);

// https://github.com/yokoffing/Betterfox/blob/main/Fastfox.js
// https://bugzilla.mozilla.org/show_bug.cgi?id=1959009
user_pref("gfx.webrender.layer-compositor", true);
user_pref("media.wmf.zero-copy-nv12-textures-force-enabled", true);
user_pref("gfx.content.skia-font-cache-size", 32); // 32 MB; default=5; Chrome=20
user_pref("gfx.canvas.accelerated.cache-items", 32768); // [default=8192 FF135+]; Chrome=4096
user_pref("gfx.canvas.accelerated.cache-size", 4096); // default=256; Chrome=512
user_pref("webgl.max-size", 16384); // default=1024
// user_pref("browser.cache.memory.capacity", 131072); // 128 MB RAM cache; alt=65536 (65 MB RAM cache); default=32768
user_pref("browser.cache.memory.max_entry_size", 20480); // 20 MB max entry; default=5120 (5 MB)
// user_pref("browser.sessionhistory.max_total_viewers", 4); // default=8
user_pref("browser.sessionstore.max_tabs_undo", 10); // default=25
user_pref("media.memory_cache_max_size", 262144); // 256 MB; default=8192; AF=65536
user_pref("media.memory_caches_combined_limit_kb", 1048576); // 1GB; default=524288
user_pref("media.cache_readahead_limit", 600); // 10 min; default=60; stop reading ahead when our buffered data is this many seconds ahead of the current playback
user_pref("media.cache_resume_threshold", 300); // 5 min; default=30; when a network connection is suspended, don't resume it until the amount of buffered data falls below this threshold
user_pref("image.cache.size", 10485760); // (cache images up to 10MiB in size) [DEFAULT 5242880]
user_pref("image.mem.decode_bytes_at_a_time", 65536); // default=16384; alt=32768; chunk size for calls to the image decoders
user_pref("network.http.max-connections", 1800); // default=900
// https://bugzilla.mozilla.org/show_bug.cgi?id=1954844
user_pref("network.http.max-persistent-connections-per-server", 10); // default=6; download connections; anything above 10 is excessive
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5); // default=3
user_pref("network.http.request.max-start-delay", 5); // default=10
user_pref("network.dnsCacheEntries", 10000); // default=800
user_pref("network.dnsCacheExpiration", 3600); // keep entries for 1 hour; default=60
user_pref("network.ssl_tokens_cache_capacity", 10240); // default=2048; more TLS token caching (fast reconnects)

// https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978376
// https://bugzilla.mozilla.org/show_bug.cgi?id=1920237
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
