// https://bugzilla.mozilla.org/show_bug.cgi?id=1693007
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978371
// https://connect.mozilla.org/t5/ideas/option-to-disable-auto-start-of-pinned-tabs/idi-p/94938
// https://connect.mozilla.org/t5/ideas/can-i-choose-not-to-auto-load-pinned-tabs/idi-p/101821
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// Fonts on windows are looking better with this
// https://bugzilla.mozilla.org/show_bug.cgi?id=1802692
// https://bugzilla.mozilla.org/show_bug.cgi?id=1829313
// TODO: chrome/edge have better fonts, report to bugzilla/connect https://bugzilla.mozilla.org/show_bug.cgi?id=1802692#c15 https://connect.mozilla.org/t5/ideas/idb-p/ideas https://github.com/brave/brave-browser/issues/5032
user_pref("gfx.font_rendering.cleartype_params.enhanced_contrast", 0);

// https://www.reddit.com/r/firefox/comments/9ub5fg/rant_awful_scrolling_in_firefox/e93d5pc
// https://bugzilla.mozilla.org/show_bug.cgi?id=1720146
// https://bugzilla.mozilla.org/show_bug.cgi?id=1978374
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
