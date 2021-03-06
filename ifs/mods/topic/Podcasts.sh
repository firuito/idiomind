#!/bin/bash
# -*- ENCODING: UTF-8 -*-

[ -z "$DM" ] && source /usr/share/idiomind/ifs/c.conf
source "$DS/ifs/mods/cmns.sh"
tpa="$(sed -n 1p "$DC_a/4.cfg")"
if [ "$tpa" != 'Podcasts' ]; then
[ ! -f "$DM_tl/Podcasts/.conf/8.cfg" ] \
&& echo "11" > "$DM_tl/Podcasts/.conf/8.cfg"
echo "Podcasts" > "$DC_a/4.cfg"; fi
if [ "$1" = 2 ]; then
echo "Podcasts" > "$DC_s/7.cfg"
echo 2 > "$DC_s/5.cfg"; fi

function list_1() {
    while read list1; do
        if [ -f "$DMP/cache/$(nmfile "$list1").png" ]; then
        echo "$DMP/cache/$(nmfile "$list1").png"
        else echo "$DS_a/Podcasts/images/audio.png"; fi
        echo "$list1"
    done < "$DCP/1.cfg"
}

function list_2() {
    while read list2; do
        if [ -f "$DMP/cache/$(nmfile "$list2").png" ]; then
        echo "$DMP/cache/$(nmfile "$list2").png"
        else echo "$DS_a/Podcasts/images/audio.png"; fi
        echo "$list2"
    done < "$DCP/2.cfg"
}

function feedmode() {

    DMP="$DM_tl/Podcasts"
    DCP="$DM_tl/Podcasts/.conf"
    DSP="$DS/addons/Podcasts"
    nt="$DCP/10.cfg"
    fdit=$(mktemp "$DT/fdit.XXXX")
    c=$(echo $(($RANDOM%100000))); KEY=$c
    [ -f "$DT/.uptp" ] && info="$(gettext "Updating Podcasts")" || info="$(gettext "Podcasts")"
    infolabel="$(< "$DMP"/*.updt)"
    
    list_1 | yad --list --tabnum=1 \
    --plug=$KEY --print-all --dclick-action="$DSP/vwr.sh" \
    --no-headers --expand-column=2 --ellipsize=END \
    --column=Name:IMG \
    --column=Name:TXT &
    list_2 | yad --list --tabnum=2 \
    --plug=$KEY --print-all --dclick-action="$DSP/vwr.sh" \
    --no-headers --expand-column=2 --ellipsize=END \
    --column=Name:IMG \
    --column=Name:TXT &
    yad --text-info --tabnum=3 \
    --text="<small>$infolabel</small>" \
    --plug=$KEY --filename="$nt" \
    --wrap --editable --fore='gray30' \
    --show-uri --margins=14 --fontname='vendana 11' > "$fdit" &
    yad --notebook --title="Idiomind - $info" \
    --name=Idiomind --class=Idiomind --key=$KEY \
    --always-print-result \
    --window-icon="$DS/images/icon.png" --image-on-top \
    --ellipsize=END --align=right --center --fixed \
    --width=640 --height=560 --borders=2 --tab-borders=5 \
    --tab=" $(gettext "Episodes") " \
    --tab=" $(gettext "Saved episodes") " \
    --tab=" $(gettext "Notes") " \
    --button="$(gettext "Lists")":"$DS/play.sh" \
    --button="$(gettext "Update")":2 \
    --button="$(gettext "Close")":1
    ret=$?
        
    if [[ $ret -eq 2 ]]; then
    "$DSP/strt.sh"; fi
    
    note_mod="$(< $fdit)"
    if [ "$note_mod" != "$(< $nt)" ]; then
    mv -f "$fdit" "$nt"; fi
    
    [ -f "$fdit" ] && rm -f "$fdit"
}

feedmode & exit
