{

echo "\
set font                    \"$mfont $mfont_size\"

set highlight-color         \"$bg_normal\"
set highlight-active-color  \"$bg_focus\"

set scroll-page-aware       true
set window-title-basename   true
set selection-clipboard     clipboard
set selection-notification  false
set statusbar-home-tilde    true
"

normal=(completion default index inputbar statusbar notification-warning)
focus=(completion-highlight index-active notification-error)

for i in ${normal[@]}; do
	echo "set $i-fg \"$fg_normal\""
	echo "set $i-bg \"$bg_normal\""
done

for i in ${focus[@]}; do
	echo "set $i-fg \"$fg_focus\""
	echo "set $i-bg \"$bg_focus\""
done

} > /tmp/zathurarc
