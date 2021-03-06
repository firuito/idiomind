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
#  2015/02/27

[ -z "$DM" ] && source /usr/share/idiomind/ifs/c.conf
if [ -z "$tpc" ]; then source "$DS/ifs/mods/cmns.sh"
msg "$(gettext "No topic is active")\n" info & exit 1; fi

[ -n "$(< "$DC_s/1.cfg")" ] && cfg=1 || > "$DC_s/1.cfg"

lbls=('Words' 'Sentences' 'Marked items' \
'Difficult words' 'New episodes' 'Saved episodes')
sets=('grammar' 'list' 'tasks' 'trans' 'trd_trgt' 'text' 'audio' \
'repeat' 'videos' 'loop' 't_lang' 's_lang' 'synth' \
'words' 'sentences' 'marks' 'practice' 'news' 'saved')
in=('in1' 'in2' 'in3' 'in4' 'in5' 'in6')

cfg1="$DC_tlt/1.cfg"
cfg3="$DC_tlt/3.cfg"
cfg4="$DC_tlt/4.cfg"
if [ "$(wc -l < "$cfg4")" -gt 0 ]; then
in1="$(grep -Fxvf "$cfg4" "$cfg1")"; else
in1="$(< "$cfg1")"; fi
if [ "$(wc -l < "$cfg3")" -gt 0 ]; then
in2="$(grep -Fxvf "$cfg3" "$cfg1")"; else
in2="$(< "$cfg1")"; fi
in3="$(< "$DC_tlt/6.cfg")"
[ -f "$DC_tlt/practice/log3" ] && \
in4="$(sed '/^$/d' < "$DC_tlt/practice/log3" | sort | uniq | head -n 20)" || in4=""
[ -f "$DM_tl/Podcasts/.conf/1.cfg" ] && \
in5="$(tac "$DM_tl/Podcasts/.conf/1.cfg" | sed '/^$/d')" || in5=""
[ -f "$DM_tl/Podcasts/.conf/2.cfg" ] && \
in6="$(tac "$DM_tl/Podcasts/.conf/2.cfg" | sed '/^$/d')" || in6=""
[ ! -d "$DT" ] && mkdir "$DT"; cd "$DT"

if [ "$cfg" = 1 ]; then

    n=13
    while [[ $n -lt 19 ]]; do
        get="${sets[$n]}"
        val=$(sed -n $((n+1))p < "$DC_s/1.cfg" \
        | grep -o "$get"=\"[^\"]* | grep -o '[^"]*$')
        declare ${sets[$n]}="$val"
        ((n=n+1))
    done
    
else
    n=0; > "$DC_s/1.cfg"
    while [[ $n -lt 19 ]]; do
    echo -e "${sets[$n]}=\"\"" >> "$DC_s/1.cfg"
    ((n=n+1))
    done
fi

function setting_1() {
    n=0; 
    while [[ $n -le 5 ]]; do
            arr="in$((n+1))"
            [[ -z ${!arr} ]] && echo "$DS/images/addi.png" \
            || echo "$DS/images/add.png"
        echo "  <span font_desc='Arial 11'>$(gettext "${lbls[$n]}")</span>"
        echo "${!sets[$((n+13))]}"
        let n++
    done
}

title="$tpc"
if [ ! -f "$DT/.p_" ]; then
btn2=""$(gettext "Cancel")":1"
if grep -E 'vivid|wily' <<<"`lsb_release -a`">/dev/null 2>&1; then
btn1="gtk-media-play:0"; else
btn1="$(gettext "Play"):0"; fi
else
tpp="$(sed -n 2p "$DT/.p_")"
btn2="gtk-media-stop:2"
btn1="$(gettext "Pause"):3"
if grep TRUE <<<"$words$sentences$marks$practice"; then
if [ "$tpp" != "$tpc" ]; then
title="$(gettext "Playing:") \"$tpp\"</sup>"; fi
fi
fi

slct=$(mktemp "$DT"/slct.XXXX)
setting_1 | yad --list --title="$title" \
--print-all --always-print-result --separator="|" \
--class=Idiomind --name=Idiomind \
--window-icon="$DS/images/icon.png" \
--skip-taskbar --align=right --center --on-top \
--expand-column=2 --no-headers \
--width=400 --height=300 --borders=5 \
--column=IMG:IMG --column=TXT:TXT --column=CHK:CHK \
--button="$btn1" --button="$btn2" > "$slct"
ret=$?

if [[ $ret -eq 0 ]]; then

    cd "$DT"; > ./index.m3u; n=13
    while [[ $n -lt 19 ]]; do
        val=$(sed -n $((n-12))p "$slct" | cut -d "|" -f3)
        [[ -n "$val" ]] && sed -i "s/${sets[$n]}=.*/${sets[$n]}=\"$val\"/g" "$DC_s/1.cfg"
        if sed -n 1,2p "$slct" | grep FALSE; then
            if [ "$val" = TRUE ]; then
            [ -n "${!in[$((n-13))]}" ] && \
            echo "${!in[$((n-13))]}" >> ./index.m3u; fi
        else
            [[ $n = 15 ]] && cat "$cfg1" >> ./index.m3u
            if [ "$val" = TRUE ]; then
            [[ -n "${!in[$((n-11))]}" ]] && \
            echo "${!in[$((n-11))]}" >> ./index.m3u; fi
        fi
        ((n=n+1))
    done
    
    rm -f "$slct";
    "$DS/stop.sh" 3
    if [ -d "$DM_tlt" ] && [ -n "$tpc" ]; then
    echo "$DM_tlt" > "$DT/.p_"
    echo "$tpc" >> "$DT/.p_"
    else "$DS/stop.sh" 2 && exit 1; fi
    
    if [ -z "$(< "$DT/index.m3u")" ]; then
    notify-send "$(gettext "Exiting")" \
    "$(gettext "Nothing to play")" -i idiomind -t 3000 &&
    sleep 4
    "$DS/stop.sh" 2 & exit 1; fi
    
    printf "plyrt.$tpc.plyrt\n" >> "$DC_s/8.cfg" &
    sleep 1
    "$DS/bcle.sh" & exit 0

elif [[ $ret -eq 2 ]]; then

    [ -f "$DT/.p_" ] && rm -f "$DT/.p_"
    [ -f "$DT/index.m3u" ] && rm -f "$DT/index.m3u"
    "$DS/stop.sh" 2
    
elif [[ $ret -eq 3 ]]; then

    [ -f "$DT/.p_" ] && rm -f "$DT/.p_"
    [ -n "$(ps -A | pgrep -f "play")" ] && killall play &
    [ -n "$(ps -A | pgrep -f "mplayer")" ] && killall mplayer &
    > "$DT/.p"
fi

rm -f "$slct" & exit
