#!/bin/bash

source /usr/share/idiomind/ifs/c.conf
source $DS/ifs/mods/cmns.sh

if [ "$1" = play ]; then
    
    killall play
    DCF="$DC/addons/Podcasts"
    [ -f "$DCF/.cnf" ] && st3=$(sed -n 2p "$DCF/.cnf") || st3=FALSE
    [ $st3 = FALSE ] && fs="" || fs='-fs'
    
    # mp3
    if [ -f "$DM_tl/Podcasts/content/$2.mp3" ]; then
        play "$DM_tl/Podcasts/content/$2.mp3" & exit
    
    elif [ -f "$DM_tl/Podcasts/kept/$2.mp3" ]; then
        play "$DM_tl/Podcasts/kept/$2.mp3" & exit
    # ogg
    elif [ -f "$DM_tl/Podcasts/content/$2.ogg" ]; then
        play "$DM_tl/Podcasts/content/$2.ogg" & exit
    
    elif [ -f "$DM_tl/Podcasts/kept/$2.ogg" ]; then
        play "$DM_tl/Podcasts/kept/$2.ogg" & exit
    # mp4
    elif [ -f "$DM_tl/Podcasts/content/$2.mp4" ]; then
        mplayer "$fs" "$DM_tl/Podcasts/content/$2.mp4" \
        >/dev/null 2>&1 & exit
    
    elif [ -f "$DM_tl/Podcasts/kept/$2.mp4" ]; then
       mplayer "$fs" "$DM_tl/Podcasts/kept/$2.mp4" \
       >/dev/null 2>&1 & exit
    # m4v
    elif [ -f "$DM_tl/Podcasts/content/$2.m4v" ]; then
        mplayer "$fs" "$DM_tl/Podcasts/content/$2.m4v" \
        >/dev/null 2>&1 & exit
    
    elif [ -f "$DM_tl/Podcasts/kept/$2.m4v" ]; then
       mplayer "$fs" "$DM_tl/Podcasts/kept/$2.m4v" \
       >/dev/null 2>&1 & exit
    
    # avi
    elif [ -f "$DM_tl/Podcasts/content/$2.avi" ]; then
        mplayer "$fs" "$DM_tl/Podcasts/content/$2.avi" \
        >/dev/null 2>&1 & exit
    
    elif [ -f "$DM_tl/Podcasts/kept/$2.avi" ]; then
       mplayer "$fs" "$DM_tl/Podcasts/kept/$2.avi" \
       >/dev/null 2>&1 & exit
    fi
    
    
elif [ "$1" = dclk ]; then

    audio="$DM_tl/Podcasts/kept/.audio"
    contn="$DM_tl/Podcasts/content"
    echo "$3" > $DT/word.x
    var="$2"
    if [ -f "$audio/${3,,}.mp3" ]; then 
        play "$audio/${3,,}.mp3"
    else
        play "$contn/$var/${3,,}.mp3"
    fi

elif [ "$1" = check ]; then

    source $DS/ifs/mods/cmns.sh
    DCF="$DC/addons/Podcasts"
    DSF="$DS/addons/Podcasts"

    internet
XSLT_STYLESHEET="<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:itunes='http://www.itunes.com/dtds/podcast-1.0.dtd'
  xmlns:media='http://search.yahoo.com/mrss/'
  xmlns:atom='http://www.w3.org/2005/Atom'>
  <xsl:output method='text'/>
  <xsl:template match='/'>
    <xsl:for-each select='/rss/channel/item'>
      <xsl:value-of select='enclosure/@url'/><xsl:text>][</xsl:text>
      <xsl:value-of select='media:contentt[@type=\"audio/mpeg\"]/@url'/><xsl:text>][</xsl:text>
      <xsl:value-of select='title'/><xsl:text>][</xsl:text>
      <xsl:value-of select='media:contentt[@type=\"audio/mpeg\"]/@duration'/><xsl:text>][</xsl:text>
      <xsl:value-of select='itunes:summary'/><xsl:text>][</xsl:text>
      <xsl:value-of select='description'/><xsl:text>EOL</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>"

    tpl="Enclosure\n ----\nTitle\n ----\nSummary\n ----\n ----\n ----"
    mn=" ----!Enclosure!Title!Summary"
    lnk=$(sed -n "$2"p $DCF/$lgtl/link)
    [ -z "$lnk" ] && exit 1
    [ ! -f "$DCF/$lgtl/$2.xml" ] && printf "$tpl" > "$DCF/$lgtl/$2.xml"
    podcast_items="$(xsltproc - "$lnk" <<< "$XSLT_STYLESHEET" 2> /dev/null)"
    podcast_items="$(echo "$podcast_items" | tr '\n' ' ' | tr -s [:space:] | sed 's/EOL/\n/g' | head -n 2)"
    item="$(echo "$podcast_items" | sed -n 1p)"
    [ -z "$(echo $item | sed 's/^ *//; s/ *$//; /^$/d')" ] && msg "$(gettext "Couldn't download the specified URL\n")" info && exit 1
    field="$(echo "$item" | sed 's/\]\[/\n/g')"

    yad --scroll --columns=2 --skip-taskbar --separator='\n' \
    --width=800 --height=650 --form --on-top --window-icon=idiomind \
    --text="<small> $(gettext "\tIn this table you can define fields according to their content,  most of the time the default configuration is right. ")</small>" \
    --button=gtk-apply:0 --borders=5 --title="$ttl" --always-print-result \
    --field="":CB "$(sed -n 1p $DCF/$lgtl/$2.xml)!$mn" \
    --field="":CB "$(sed -n 2p $DCF/$lgtl/$2.xml)!$mn" \
    --field="":CB "$(sed -n 3p $DCF/$lgtl/$2.xml)!$mn" \
    --field="":CB "$(sed -n 4p $DCF/$lgtl/$2.xml)!$mn" \
    --field="":CB "$(sed -n 5p $DCF/$lgtl/$2.xml)!$mn" \
    --field="":CB "$(sed -n 6p $DCF/$lgtl/$2.xml)!$mn" \
    --field="":CB "$(sed -n 7p $DCF/$lgtl/$2.xml)!$mn" \
    --field="":TXT "$(echo "$field" | sed -n 1p)" \
    --field="":TXT "$(echo "$field" | sed -n 2p)" \
    --field="":TXT "$(echo "$field" | sed -n 3p | sed 's/\://g')" \
    --field="":TXT "$(echo "$field" | sed -n 4p | sed 's/\://g')" \
    --field="":TXT "$(echo "$field" | sed -n 5p)" \
    --field="\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t":TXT "$(echo "$field" | sed -n 6p)" \
    --field="":TXT "$(echo "$field" | sed -n 7p)" | head -n 7 > $DT/f.tmp
    mv -f $DT/f.tmp "$DCF/$lgtl/$2.xml" & exit


elif [ "$1" = syndlg ]; then

    DCF="$DC/addons/Podcasts"
    SYNCDIR="$(sed -n 1p $DCF/cfg.5)"

    cd $HOME
    DIR="$(yad --center --form --on-top --window-icon=idiomind \
    --borders=10 --separator="" --title=" " --always-print-result \
    --text="$(gettext "Mountpoint or path where new episodes should be synced.")" \
    --print-all --button="gtk-apply":0 \
    --width=460 --height=200 --field="":CDIR "$SYNCDIR")"

    echo "$DIR" > $DT/s.tmp
    mv -f $DT/s.tmp $DCF/cfg.5
    exit


elif [ "$1" = syncronize ]; then

    DCF="$DC/addons/Podcasts"
    SYNCDIR="$(sed -n 1p $DCF/cfg.5)"

    if [ ! -d "$SYNCDIR" ]; then
            cd $HOME
            DIR="$(yad --center --form --on-top --window-icon=idiomind \
            --borders=10 --separator="" --title=" " --always-print-result \
            --text="$(gettext "Set mountpoint or path where new episodes should be synced.")" \
            --print-all --button="$(gettext "Syncronize")":0 \
            --width=460 --height=200 --field="":CDIR "$SYNCDIR")"
            echo "$DIR" > $DT/s.tmp
            mv -f $DT/s.tmp $DCF/cfg.5
            [ ! -d "$DIR" ] && exit 1
    fi

    touch $DT/l_sync
    rsync -az --delete --exclude="*.txt" --exclude="*.png" \
    --exclude="*.i" --ignore-errors $DM_tl/Podcasts/content/ "$SYNCDIR"

    exit=$?
    if [ $exit = 0 ] ; then
        log="$(cd "$SYNCDIR"; ls *.mp3 | wc -l)"
        notify-send -i idiomind "$(gettext "synchronization was completed")" "$log $(gettext "synchronized episodes(s)")" -t 8000
    else
        notify-send -i dialog-warning "$(gettext "Error while syncing")" " " -t 8000
    fi
    rm -f $DT/l_sync
fi
