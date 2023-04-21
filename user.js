// https://www.askvg.com/tip-disable-dark-mode-in-private-browsing-windows-in-firefox/
// TODO: report this to mozilla (add option to ui)
user_pref("browser.theme.dark-private-windows", false);

// TODO: report this
// https://bugzilla.mozilla.org/show_bug.cgi?id=1230656
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
// TODO: report this
user_pref("gfx.font_rendering.cleartype_params.enhanced_contrast", 0);

// old scrollbars
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802694
user_pref("widget.windows.overlay-scrollbars.enabled", false);

// https://kb.mozillazine.org/Browser.link.open_newwindow
// spotify "open in desktop app" feature annoyingly opens new tab (which is not the case with store version)
// user_pref("browser.link.open_newwindow", 1);

// https://support.mozilla.org/en-US/questions/1176544
// removes delay between allowing to save file/making "OK" button clickable
user_pref("security.dialog_enable_delay", 0);
