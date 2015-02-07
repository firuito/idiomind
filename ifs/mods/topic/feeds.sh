#!/bin/bash
# -*- ENCODING: UTF-8 -*-

function feedmode() {
	
		DMF="$DM_tl/Feeds"
		DCF="$DC/addons/Learning with news"
		DSF="$DS/addons/Learning with news"
		FEED=$(cat "$DCF/$lgtl/.rss")
		ICON="$DSF/images/rss.png"
		c=$(echo $(($RANDOM%100000)))
		STT="$(cat $DT/.uptf)"
		KEY=$c
		if echo "$STT" | grep "updating..."; then
			info=$(echo "<i>"$updating"...</i>")
			FEED=$(cat "$DT/.rss")
		else
			info=$(cat $DC_tl/Feeds/.dt)
		fi
		if [[ ! -f "$DC_tl/Feeds/cfg.1" ]]; then
		cd "$DMF/conten"
		ls -t *.mp3 > "$DC_tl/Feeds/cfg.1"
		sed -i 's/.mp3//g' "$DC_tl/Feeds/cfg.1"
		fi
		cd "$DSF"
		cat "$DC_tl/Feeds/cfg.1" | yad \
		--no-headers --list --listen --plug=$KEY --tabnum=1 \
		--text=" <small>$info</small>" \
		--expand-column=1 --ellipsize=END --print-all \
		--column=Name:TEXT --dclick-action='./vwr.sh V1' &
		cat "$DC_tl/Feeds/cfg.0" | awk '{print $0""}' \
		| yad --no-headers --list --listen --plug=$KEY --tabnum=2 \
		--expand-column=1 --ellipsize=END --print-all \
		--column=Name:TEXT --dclick-action='./vwr.sh V2' &
		yad --notebook --name=Idiomind --center \
		--class=Idiomind --align=right --key=$KEY \
		--text=" <big><big>$title_rss </big></big>\\n <small>$FEED</small>\n\n" \
		--image="$ICON" --image-on-top  \
		--tab-borders=0 --center --title="$FEED" \
		--tab="  $news  " \
		--tab=" $saved_conten " \
		--ellipsize=END --image-on-top \
		--window-icon=$DS/images/idiomind.png \
		--width="$wth" --height="$eht" --borders=0 \
		--button="Play":/usr/share/idiomind/play.sh \
		--button="$update":2 \
		--button="$edit":3
		ret=$?
			
			if [ $ret -eq 0 ]; then
				rm -f $DT/*.x
				"$DSF/cnfg.sh" & killall topic.sh & exit
			
			elif [ $ret -eq 3 ]; then
				rm -f $DT/*.x
				"$DSF/cnfg.sh" edit & exit
			
			elif [ $ret -eq 2 ]; then
				rm -f $DT/*.x
				"$DSF/strt.sh" & exit
			fi
}


if echo "$mde" | grep "fd"; then
	feedmode
fi