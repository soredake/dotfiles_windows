// https://bugzilla.mozilla.org/show_bug.cgi?id=1693007
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978371
// https://connect.mozilla.org/t5/ideas/option-to-disable-auto-start-of-pinned-tabs/idi-p/94938
// https://connect.mozilla.org/t5/ideas/can-i-choose-not-to-auto-load-pinned-tabs/idi-p/101821
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// Fonts on windows are looking better with this
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802692
// https://bugzilla.mozilla.org/show_bug.cgi?id=1829313
// https://github.com/yokoffing/Betterfox/wiki/Common-Overrides#font-improvement
// https://github.com/yokoffing/Betterfox/blob/152.0/Peskyfox.js#L169-L179
user_pref("gfx.font_rendering.cleartype_params.enhanced_contrast", 0);

// https://www.reddit.com/r/firefox/comments/9ub5fg/rant_awful_scrolling_in_firefox/e93d5pc
// https://bugzilla.mozilla.org/show_bug.cgi?id=1720146
// user_pref("general.smoothScroll.msdPhysics.enabled", true);

// https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978376
// https://bugzilla.mozilla.org/show_bug.cgi?id=1920237
// https://bugzilla.mozilla.org/show_bug.cgi?id=1999441
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

// https://github.com/yokoffing/Betterfox/blob/main/Fastfox.js
user_pref("gfx.content.skia-font-cache-size", 20); // 20 MB; default=5; Chrome=20
user_pref("content.notify.interval", 100000); // (.10s); default=120000 (.12s)
user_pref("gfx.canvas.accelerated.cache-size", 512); // default=256; Chrome=512; max=2048 [4]
user_pref("media.cache_readahead_limit", 3600); // 60 min; default=60 sec; stop reading ahead when our buffered data is this many seconds ahead of the current playback
user_pref("media.cache_resume_threshold", 1800); // 30 min; default=30 sec; when a network connection is suspended, don't resume it until the amount of buffered data falls below this threshold
user_pref("image.mem.decode_bytes_at_a_time", 32768); // default=16384; chunk size for calls to the image decoders
user_pref("network.buffer.cache.size", 65535); // default=32768 (32 kb); 262144 too large
user_pref("network.buffer.cache.count", 48); // default=24; 128 too large
user_pref("network.http.max-connections", 1800); // default=900
user_pref("network.http.max-persistent-connections-per-server", 10); // default=6; download connections; anything above 10 is excessive
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5); // default=3
user_pref("network.http.request.max-start-delay", 5); // default=10
user_pref("network.dnsCacheExpiration", 3600); // keep entries for 1 hour; default=60
