#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  

source /usr/share/idiomind/ifs/c.conf
DSP="$DS/practice"
wth=500
eht=450
easys="$2"
learning="$3"
[[ "$4" -lt 0 ]] && hards=0 || hards="$4"
"$DS/stop.sh" &
[ ! -d "$DC_tlt/practice" ] \
&& mkdir "$DC_tlt/practice"
cd "$DC_tlt/practice"

[ ! -f .iconf ] && echo '1' > .iconf
[ ! -f .iconmc ] && echo '1' > .iconmc
[ ! -f .iconlw ] && echo '1' > .iconlw
[ ! -f .iconls ] && echo '1' > .iconls
[ ! -f .iconi ] && echo '1' > .iconi

if [[ -n "$1" ]]; then

    if [ "$1" = 1 ]; then
        info1="* "; info6="<b>$(gettext "Test completed!")</b>"
        echo 21 > .iconf
    elif [ "$1" = 2 ]; then
        info2="* "; info7="<b>$(gettext "Test completed!")</b>"
        echo 21 > .iconmc
    elif [ "$1" = 3 ]; then
        info3="* "; info8="<b>$(gettext "Test completed!")</b>"
        echo 21 > .iconlw
    elif [ "$1" = 4 ]; then
        info4="* "; info9="<b>$(gettext "Test completed!")</b>"
        echo 21 > .iconls
    elif [ "$1" = 5 ]; then
        info5="* "; info10="<b>$(gettext "Test completed!")</b>"
        echo 21 > .iconi
    elif [ "$1" = 6 ]; then
        learned=$(cat l_f)
        num=$(cat .iconf)
        info1="* "
        info="  <b><big>$learned </big></b><small>$(gettext "Learned")</small>   <span color='#3AB451'><b><big>$easys </big></b></span><small>$(gettext "Easy")</small>   <span color='#E78C1E'><b><big>$learning </big></b></span><small>$(gettext "Learning")</small>   <span color='#D11B5D'><b><big>$hards </big></b></span><small>$(gettext "Difficult")</small>  \\n"
    elif [ $1 = 7 ]; then
        learned=$(cat l_m)
        num=$(cat .iconmc)
        info2="* "
        info="  <b><big>$learned </big></b><small>$(gettext "Learned")</small>   <span color='#3AB451'><b><big>$easys </big></b></span><small>$(gettext "Easy")</small>   <span color='#E78C1E'><b><big>$learning </big></b></span><small>$(gettext "Learning")</small>   <span color='#D11B5D'><b><big>$hards </big></b></span><small>$(gettext "Difficult")</small>  \\n"
    elif [ $1 = 8 ]; then
        learned=$(cat l_w)
        num=$(cat .iconlw)
        info3="* "
        info="  <b><big>$learned </big></b><small>$(gettext "Learned")</small>   <span color='#3AB451'><b><big>$easys </big></b></span><small>$(gettext "Easy")</small>   <span color='#E78C1E'><b><big>$learning </big></b></span><small>$(gettext "Learning")</small>   <span color='#D11B5D'><b><big>$hards </big></b></span><small>$(gettext "Difficult")</small>  \\n"
    elif [ $1 = 9 ]; then
        learned=$(cat l_s)
        num=$(cat .iconls)
        info4="* "
        info="  <b><big>$learned </big></b><small>$(gettext "Learned")</small>   <span color='#3AB451'><b><big>$easys </big></b></span><small>$(gettext "Easy")</small>   <span color='#E78C1E'><b><big>$learning </big></b></span><small>$(gettext "Learning")</small>   <span color='#D11B5D'><b><big>$hards </big></b></span><small>$(gettext "Difficult")</small>  \\n"
    elif [ $1 = 10 ]; then
        learned=$(cat l_i)
        num=$(cat .iconi)
        info5="* "
        info="  <b><big>$learned </big></b><small>$(gettext "Learned")</small>   <span color='#3AB451'><b><big>$easys </big></b></span><small>$(gettext "Easy")</small>   <span color='#E78C1E'><b><big>$learning </big></b></span><small>$(gettext "Learning")</small>   <span color='#D11B5D'><b><big>$hards </big></b></span><small>$(gettext "Difficult")</small>  \\n"
    fi
fi

img1="$DSP/icons_st/$(cat .iconf).png"
img2="$DSP/icons_st/$(cat .iconmc).png"
img3="$DSP/icons_st/$(cat .iconlw).png"
img4="$DSP/icons_st/$(cat .iconls).png"
img5="$DSP/icons_st/$(cat .iconi).png"

VAR="$(yad --list --title="$(gettext "Practice") - $tpc" \
$img --text="$info" \
--class=Idiomind --name=Idiomind \
--print-column=1 \
--window-icon="$DS/images/icon.png" \
--buttons-layout=edge --image-on-top --center --on-top --text-align=center \
--ellipsize=NONE --no-headers --expand-column=2 --hide-column=1 \
--width=$wth --height=$eht --borders=10 \
--column="Action" --column="Pick":IMG --column="Label" \
Fcards $img1 "    $info1 $info6   $(gettext "Flashcards")" \
MChoise $img2 "    $info2 $info7   $(gettext "Multiple Choice")" \
LWords $img3 "    $info3 $info8   $(gettext "Listening Words")" \
LSntncs $img4 "    $info4 $info9   $(gettext "Listening Sentences")" \
WImages $img5 "    $info5 $info10   $(gettext "With Images")" \
--button="$(gettext "Restart")":3 \
--button="$(gettext "Start")":0)"
ret=$?

if [[ $ret -eq 0 ]]; then

    printf "prct.shc.$tpc.prct.shc\n" >> "$DC_s/8.cfg" &
    if echo "$VAR" | grep "Fcards"; then
        "$DSP/prct.sh" f & exit 1
    elif echo "$VAR" | grep "MChoise"; then
        "$DSP/prct.sh" m & exit 1
    elif echo "$VAR" | grep "LWords"; then
        "$DSP/prct.sh" w & exit 1
    elif echo "$VAR" | grep "LSntncs"; then
        "$DSP/prct.sh" s & exit 1
    elif echo "$VAR" | grep "WImages"; then
        "$DSP/prct.sh" i & exit 1
    else
        source "$DS/ifs/mods/cmns.sh"
        msg " $(gettext "You must choose a practice.")\n" info
        "$DSP/strt.sh" & exit 1
    fi
elif [[ $ret -eq 3 ]]; then
    if [ -d "$DC_tlt/practice" ]; then
    cd "$DC_tlt/practice"
    rm .*; rm *; fi
    "$DS/practice/strt.sh" & exit
else
    cd "$DC_tlt/practice"
    [ -f fin1 ] && rm fin1; [ -f fin2 ] && rm fin2;
    [ -f mcin1 ] && rm mcin1; [ -f mcin2 ] && rm mcin2;
    [ -f lwin1 ] && rm lwin1; [ -f lwin2 ] && rm lwin2;
    [ -f lsin1 ] && rm lsin1
    [ -f wiin1 ] && rm wiin1; [ -f wiin2 ] && rm wiin2;
    kill -9 $(pgrep -f "yad --form ")
    exit
fi
