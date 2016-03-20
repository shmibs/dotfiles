echo "\
@namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

/* Get rid of the bottom border */
#TabsToolbar:after {
    border-bottom: 0px !important;
}

/* Hide the new curved tab edges */
.tab-background {
    visibility: hidden !important;
}

/* Hide the little graphic seperators between inactive tabs */
.tabbrowser-tab:before,
.tabbrowser-tab:after { 
    visibility: hidden !important;
}

#TabsToolbar {
    -moz-appearance: none !important;
    background: ${bg_normal} !important; 
}

.tabbrowser-tab {
    background: ${bg_normal} !important;
    color: ${fg_normal} !important;
	font-family: \"${mfont}\" !important;
	font-size: ${mfont_size}pt !important;
}

.tabbrowser-tab[selected] {
    background: ${bg_focus} !important;
    color: ${fg_focus} !important;
	font-family: \"${mfont}\" !important;
	font-size: ${mfont_size}pt !important;
}
" > /tmp/userChrome.css

