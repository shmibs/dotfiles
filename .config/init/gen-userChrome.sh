echo "\
@namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

@-moz-document url-prefix(about:blank) {*{background-color:${bg_normal};}}

.tabbrowser-tabs:not([drag=detach]) > .tabbrowser-tab:not([pinned])[fadein] {
	min-width: 10px !important;
	max-width: 100% !important;
}

#TabsToolbar:not(:-moz-lwtheme)::after {display: none;}
/* Remove the following line if you want the text color of unselected tabs to be black (Firefox default) */
#TabsToolbar .tabbrowser-tab:not([selected]) {color: rgba(255,255,255,0.9);}
 
#TabsToolbar {
	background: rgb(50,50,50) !important;
	margin-bottom: 0 !important;
}
 
#TabsToolbar .tabbrowser-tabs {
	min-height: ${bheight}px !important;
	margin-top: 0px !important;
	margin-bottom: 0px !important;
	text-align: center !important;
	margin-left: -15px !important;
	margin-right: -15px !important;
}
 
#tabbrowser-tabs tab .tab-close-button {
	display: none !important;
}
 
.tabbrowser-tab:not([pinned]) .tab-icon-image {
	display: none !important;
}
 
 
#TabsToolbar .tabbrowser-tab {
	-moz-border-top-colors: none !important;
	-moz-border-left-colors: none !important;
	-moz-border-right-colors: none !important;
	-moz-border-bottom-colors: none !important;
	padding-top: 1px !important;
	padding-right: 0 !important;
	border-radius: 0px !important;
	background: ${bg_normal} !important;
	background-clip: padding-box !important;
	margin-left: 0px !important;
	color: ${fg_normal} !important;
	font-family: '${bfont}' !important;
	min-height: ${bheight}px !important;
}
 
#TabsToolbar .tabs-newtab-button {
	display: none !important;
}

#TabsToolbar .tabbrowser-tab[selected] {
	color: ${fg_focus} !important;
	background: ${bg_focus} !important;
	background-clip: padding-box !important;
}
 
#TabsToolbar .tabs-newtab-button:hover,
#TabsToolbar .tabbrowser-tab:hover:not([selected]) {
	background-color: ${bg_focus} !important;
	color: ${fg_focus} !important;
}
 
#TabsToolbar .tab-background {
	margin: 0 !important;
	background: transparent !important;
}
 
#TabsToolbar .tab-background-start,
#TabsToolbar .tab-background-end {
	display: none !important;
}
 
#TabsToolbar .tab-background-middle {
	margin: -4px -2px !important;
	background: transparent !important;
}
 
#TabsToolbar .tabbrowser-tab:after,
#TabsToolbar .tabbrowser-tab:before {
	display: none !important;
}
 
#TabsToolbar .tabs-newtab-button {
	display: none !important;
}
 
.scrollbutton-up, .scrollbutton-down, #alltabs-button {
	display: none !important;
}

" > /tmp/userChrome.css

