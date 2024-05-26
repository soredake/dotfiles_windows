// https://www.askvg.com/tip-disable-dark-mode-in-private-browsing-windows-in-firefox/
// TODO: Report this to mozilla (add option to ui)
user_pref("browser.theme.dark-private-windows", false);

// TODO: Add ui option to disable built-in extensions
// https://bugzilla.mozilla.org/show_bug.cgi?id=1230656
// https://www.neowin.net/news/microsoft-edge-will-soon-let-you-remove-some-of-its-unnecessary-features/
user_pref("extensions.pocket.enabled", false);

// https://www.ghacks.net/2024/02/22/how-to-enable-tab-previews-in-firefox/
user_pref("browser.tabs.cardPreview.enabled", true);

// DOH by default
user_pref("network.trr.mode", 2);

// https://bugzilla.mozilla.org/show_bug.cgi?id=1874464
user_pref("network.dns.native_https_query", true);

// https://bugzilla.mozilla.org/show_bug.cgi?id=1693007
// https://bugzilla.mozilla.org/show_bug.cgi?id=1750904
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// https://www.exploit.media/privacy/firefox-settings/
user_pref("network.dns.disablePrefetchFromHTTPS", false);
// https://bugzilla.mozilla.org/show_bug.cgi?id=1746396
// https://bugzilla.mozilla.org/show_bug.cgi?id=1783225
user_pref("network.predictor.enable-prefetch", true);

// https://www.reddit.com/r/firefox/comments/9ub5fg/rant_awful_scrolling_in_firefox/e93d5pc
// https://bugzilla.mozilla.org/show_bug.cgi?id=1720146
// user_pref("general.smoothScroll.msdPhysics.enabled", true);

// fonts are looking better with this
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802692
// https://bugzilla.mozilla.org/show_bug.cgi?id=1829313
user_pref("gfx.font_rendering.cleartype_params.enhanced_contrast", 0);

// old scrollbars
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802694
user_pref("widget.windows.overlay-scrollbars.enabled", false);

// https://support.mozilla.org/en-US/questions/1176544
// removes delay between allowing to save file/making "OK" button clickable
// user_pref("security.dialog_enable_delay", 0);

// Do not show about:config warning message
user_pref("browser.aboutConfig.showWarning", false);

// TODO: test what settings are synchronized
// TODO: sync all this settings https://bugzilla.mozilla.org/show_bug.cgi?id=1269548

///////////////////////// https://github.com/yokoffing/Betterfox/blob/main/Fastfox.js
user_pref("content.notify.interval", 100000); // (.10s); default=120000 (.12s)
user_pref("gfx.canvas.accelerated.cache-items", 4096); // default=2048; alt=8192
user_pref("gfx.canvas.accelerated.cache-size", 512); // default=256; alt=1024
user_pref("gfx.content.skia-font-cache-size", 20); // default=5; Chrome=20
user_pref("browser.cache.jsbc_compression_level", 3);
user_pref("media.memory_cache_max_size", 65536); // default=8192; AF=65536; alt=131072
user_pref("media.cache_readahead_limit", 7200); // 120 min; default=60; stop reading ahead when our buffered data is this many seconds ahead of the current playback
user_pref("media.cache_resume_threshold", 3600); // 60 min; default=30; when a network connection is suspended, don't resume it until the amount of buffered data falls below this threshold
user_pref("image.mem.decode_bytes_at_a_time", 32768); // default=16384; alt=65536; chunk size for calls to the image decoders
user_pref("network.http.max-connections", 1800); // default=900
user_pref("network.http.max-persistent-connections-per-server", 10); // default=6; download connections; anything above 10 is excessive
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5); // default=3
user_pref("network.http.pacing.requests.enabled", false);
user_pref("network.dnsCacheExpiration", 3600); // keep entries for 1 hour
user_pref("network.dns.max_high_priority_threads", 8); // default=5
user_pref("network.ssl_tokens_cache_capacity", 10240); // default=2048; more TLS token caching (fast reconnects)
user_pref("layout.css.grid-template-masonry-value.enabled", true);
user_pref("dom.enable_web_task_scheduling", true);
user_pref("layout.css.has-selector.enabled", true);
user_pref("dom.security.sanitizer.enabled", true);

/////////////////////////////////////////////////// https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
user_pref("general.smoothScroll", true); // DEFAULT
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", 2.0);
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
user_pref("general.smoothScroll.currentVelocityWeighting", 1.0);
user_pref("general.smoothScroll.stopDecelerationWeighting", 1.0);
user_pref("mousewheel.default.delta_multiplier_y", 300); // 250-400; adjust this number to your liking
