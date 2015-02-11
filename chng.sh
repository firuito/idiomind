#!/bin/bash
# -*- ENCODING: UTF-8 -*-

source /usr/share/idiomind/ifs/c.conf
source $DS/ifs/trans/$lgs/topics_lists.conf

if [[ "$1" = chngi ]]; then

	nta=$(sed -n 6p $DC_s/cfg.5)
	sna=$(sed -n 7p $DC_s/cfg.5)
	cfg.1="$DC_s/cfg.5"
	indx="$DT/.$user/indx"
	[[ -z $(cat $DC_s/cfg.2) ]] && echo 8 > $DC_s/cfg.2
	bcl=$(cat $DC_s/cfg.2)
	[[ $bcl -lt 2 ]] && bcl = 2 && echo 2 > $DC_s/cfg.2
	if ([ $(echo "$nta" | grep "TRUE") ] && [ $bcl -lt 12 ]); then bcl=12; fi

	item="$(sed -n "$2"p $indx)"
	fname="$(echo -n "$item" | md5sum | rev | cut -c 4- | rev)"
	
	[[ -f "$DM_tlt/$fname.mp3" ]] && file="$DM_tlt/$fname.mp3" && t=2
	[[ -f "$DM_tlt/words/$fname.mp3" ]] && file="$DM_tlt/words/$fname.mp3" && t=1
	[[ -f "$DM_tl/Feeds/kept/words/$fname.mp3" ]] && file="$DM_tl/Feeds/kept/words/$fname.mp3" && t=1
	[[ -f "$DM_tl/Feeds/kept/$fname.mp3" ]] && file="$DM_tl/Feeds/kept/$fname.mp3" && t=2
	[[ -f "$DM_tl/Feeds/conten/$fname.mp3" ]] && file="$DM_tl/Feeds/conten/$fname.mp3" && t=2
	
	if [ -f "$file" ]; then
		
		if [ "$t" = 2 ]; then
		tgs=$(eyeD3 "$file")
		trgt=$(echo "$tgs" | \
		grep -o -P '(?<=ISI1I0I).*(?=ISI1I0I)')
		srce=$(echo "$tgs" | \
		grep -o -P '(?<=ISI2I0I).*(?=ISI2I0I)')
		
		elif [ "$t" = 1 ]; then
		tgs=$(eyeD3 "$file")
		trgt=$(echo "$tgs" | \
		grep -o -P '(?<=IWI1I0I).*(?=IWI1I0I)')
		srce=$(echo "$tgs" | \
		grep -o -P '(?<=IWI2I0I).*(?=IWI2I0I)')
		fi

		[[ -z "$trgt" ]] && trgt="$item"
		#[[ -f "$DM_tl/Feeds/kept/words/$item.mp3" ]] && osdi="$DM_tl/Feeds/kept/words/$item.mp3" || osdi=idiomind
		imgt="$DM_tlt/words/images/$fname.jpg"
		[[ -f $imgt ]] && osdi=$imgt || osdi=idiomind
		
		[[ -n $(echo "$nta" | grep "TRUE") ]] && notify-send -i "$osdi" "$trgt" "$srce" -t 10000  &
		sleep 0.7
		if [[ -n $(echo "$sna" | grep "TRUE") ]]; then
			if ps -A | pgrep -f 'tls.sh'; then
				
				while [ $(ps -A | pgrep -f tls.sh) ]; do
					sleep 0.5
				done
				
				$DS/ifs/tls.sh play "$file" &
			else
				$DS/ifs/tls.sh play "$file" &
			fi
		fi
		
		cnt=$(echo "$trgt" | wc -c)
		sleep $(($bcl+$cnt/20))
		
		[[ -f $DT/.bcle ]] && rm -f $DT/.bcle
		
	else
		echo "$item" >> $DT/.bcle
		echo "-- no file found"
		if [ $(cat $DT/.p__$use | wc -l) -gt 5 ]; then
			int="$(sed -n 16p $DS/ifs/trans/$lgs/$lgs | sed 's/|/\n/g')"
			T="$(echo "$int" | sed -n 1p)"
			D="$(echo "$int" | sed -n 2p)"
			notify-send -i idiomind "$T" "$D" -t 9000 &
			rm -f $DT/.p__$user &
			$DS/stop.sh S & exit 1
		fi
	fi

elif [ "$1" != chngi ]; then
	
	if [ ! -f $DC_s/cfg.0 ]; then
		> $DC_s/cfg.0
		fi
		wth=$(sed -n 3p $DC_s/cfg.18)
		eht=$(sed -n 4p $DC_s/cfg.18)
		if [ -n "$1" ]; then
			text="--text=<small>$1\n</small>"
			align="left"; h=1
			img="--image=info"
		else
			lgtl=$(echo "$lgtl" | awk '{print tolower($0)}')
			text="--text=<small><small><a href='http://idiomind.sourceforge.net/$lgs/$lgtl'>$find_topics</a>   </small></small>"
			align="right"
		fi
		[[ -f $DC_tl/.cfg.1 ]] && info2=$(cat $DC_tl/.cfg.1 | wc -l) || info2=""
		cd $DC_s

		VAR=$(cat $DC_s/cfg.0 | yad --name=idiomind --text-align=$align \
		--class=idiomind --center $img --image-on-top --separator="" \
		"$text" --width=$wth --height=$eht --ellipsize=END \
		--no-headers --list --window-icon=idiomind --borders=5 \
		--button="gtk-add":3 --button="$ok":0 \
		--title="$topics" --column=img:img --column=File:TEXT)
			ret=$?
			
			if [ $ret -eq 3 ]; then
			
					if [ "$h" = 1 ]; then
						$DS/add.sh new_topic & exit
						
					else
						$DS/add.sh new_topic & exit
					fi
			
			elif [ $ret -eq 0 ]; then
				
					if [[ -f $DC_tl/"$VAR"/tpc.sh ]]; then
						$DC_tl/"$VAR"/tpc.sh & exit
					else
						cp -f $DS/default/tpc.sh $DC_tl/"$VAR"/tpc.sh
						$DC_tl/"$VAR"/tpc.sh & exit
					fi
			else
				exit 0
			fi
fi
