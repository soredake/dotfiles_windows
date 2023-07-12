// https://www.askvg.com/tip-disable-dark-mode-in-private-browsing-windows-in-firefox/
// TODO: report this to mozilla (add option to ui)
user_pref("browser.theme.dark-private-windows", false);

// TODO: add ui option to disable built-in extensions
// https://bugzilla.mozilla.org/show_bug.cgi?id=1230656
// https://www.neowin.net/news/microsoft-edge-will-soon-let-you-remove-some-of-its-unnecessary-features/
user_pref("extensions.pocket.enabled", false);

// PAC
user_pref(
  "network.proxy.autoconfig_url",
  "***REMOVED***"
);

// DOH
user_pref("network.trr.mode", 2);

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
user_pref("general.smoothScroll.msdPhysics.enabled", true);

// https://bugzilla.mozilla.org/show_bug.cgi?id=1725938
// https://tls-ech.dev/
user_pref("network.dns.echconfig.enabled", true);

// fonts are looking better with this
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802692
// https://bugzilla.mozilla.org/show_bug.cgi?id=1829313
user_pref("gfx.font_rendering.cleartype_params.enhanced_contrast", 0);

// old scrollbars
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802694
user_pref("widget.windows.overlay-scrollbars.enabled", false);

// https://support.mozilla.org/en-US/questions/1176544
// removes delay between allowing to save file/making "OK" button clickable
// TODO: add ui setting for this and compare with chrome behavior
user_pref("security.dialog_enable_delay", 0);

// Do not show about:config warning message
user_pref("browser.aboutConfig.showWarning", false);

// TODO: test what settings are synchronized
// TODO: sync all this settings https://bugzilla.mozilla.org/show_bug.cgi?id=1269548

///////////////////////// https://github.com/yokoffing/Betterfox/blob/main/Fastfox.js
user_pref("nglayout.initialpaint.delay_in_oopif", 0); // default=5
user_pref("content.notify.interval", 100000); // (.10s); alt=500000 (.50s)
user_pref("layout.css.grid-template-masonry-value.enabled", true);
user_pref("dom.enable_web_task_scheduling", true);
user_pref("gfx.webrender.all", true); // enables WR (GPU) + additional features
user_pref("gfx.webrender.precache-shaders", true);
user_pref("gfx.webrender.compositor", true);
user_pref("layers.gpu-process.enabled", true);
user_pref("media.hardware-video-decoding.enabled", true);
user_pref("gfx.canvas.accelerated", true); // DEFAULT on macOS and Linux v.110
user_pref("gfx.canvas.accelerated.cache-items", 32768);
user_pref("gfx.canvas.accelerated.cache-size", 4096);
user_pref("gfx.content.skia-font-cache-size", 80);
user_pref("image.cache.size", 10485760);
user_pref("image.mem.decode_bytes_at_a_time", 131072); // alt=65536; preferred=262144; chunk size for calls to the image decoders
user_pref("image.mem.shared.unmap.min_expiration_ms", 120000); // default=60000; minimum timeout to unmap shared surfaces since they have been last used
user_pref("media.memory_cache_max_size", 1048576); // alt=512000; also in Securefox (inactive there)
user_pref("media.memory_caches_combined_limit_kb", 2560000); // preferred=3145728; // default=524288
user_pref("browser.cache.memory.max_entry_size", 153600); // alt=51200; preferred=327680 ; alt= -1 -> entries bigger than than 90% of the mem-cache are never cached
user_pref("network.buffer.cache.size", 262144); // preferred=327680; default=32768
user_pref("network.buffer.cache.count", 128); // preferred=240; default=24
user_pref("network.http.max-connections", 1800); // default=900
user_pref("network.http.max-persistent-connections-per-server", 10); // default=6; download connections; anything above 10 is excessive
user_pref("network.ssl_tokens_cache_capacity", 32768); // default=2048; more TLS token caching (fast reconnects)

/////////////////////////////////////////////////// https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
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
user_pref("mousewheel.default.delta_multiplier_y", 300); // 250-400
