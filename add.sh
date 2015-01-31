#!/bin/bash
# -*- ENCODING: UTF-8 -*-

source /usr/share/idiomind/ifs/c.conf
source $DS/ifs/trans/$lgs/add.conf
source $DS/ifs/fuctions/add.sh
source $DS/ifs/yad/add.sh

if [ $1 = new_topic ]; then

	info2=$(cat $DC_tl/.cfg.1 | wc -l)
	c=$(echo $(($RANDOM%100)))
	
	if [ "$3" = 2 ]; then
		nmt="$tpc"
		tle="$tpc"
		if [ -n "$nmt" ];then
			nmt="$nmt"
		else
			tle=$(echo "$new_topic")
			nmt=""
		fi
		
		jlbi=$(dlg_form_0 "$rename" "$nmt")
		ret=$(echo "$?")
		jlb="$(clean_2 "$jlbi")"
		snm=$(cat $DC_tl/.cfg.1 | grep -Fxo "$jlb" | wc -l)
		
		if [ $snm -ge 1 ]; then
		
			jlb=$(echo ""$jlb" $snm")
			dlg_msg_6 " <b>$name_eq   </b>\\n $name_eq2  <b>$jlb</b>   \\n"
			ret=$(echo "$?")

				if [ "$ret" -eq 1 ]; then
					exit 1
				fi
		else
			jlb=$(echo "$jlb")
		fi
		
		if [ -z "$jlb" ]; then
			exit 1
		else
			mkdir $DM_tl/"$jlb"
			mkdir $DM_tl/"$jlb"/words
			mkdir $DM_tl/"$jlb"/words/images
			mkdir $DC_tl/"$jlb"
			mkdir $DC_tl/"$jlb"/practice
			
			cd "$DM_tl/$tpc"
			cp -fr ./* "$DM_tl/$jlb"

			cd "$DC_tl/$tpc"
			cp -fr ./.* "$DC_tl/$jlb"/
			
			echo "$jlb" >> $DC_tl/.cfg.2
			grep -v -x -F "$tpc" $DC_tl/.cfg.2 > $DC_tl/.cfg.2_
			sed '/^$/d' $DC_tl/.cfg.2_ > $DC_tl/.cfg.2
			grep -v -x -F "$tpc" $DC_tl/.cfg.1 > $DC_tl/.cfg.1_
			sed '/^$/d' $DC_tl/.cfg.1_ > $DC_tl/.cfg.1
			grep -v -x -F "$tpc" $DC_tl/.cfg.3 > $DC_tl/.cfg.3_
			sed '/^$/d' $DC_tl/.cfg.3_ > $DC_tl/.cfg.3

			[[ -d "$DC_tl/$tpc" ]] && rm -r "$DC_tl/$tpc"
			[[ -d "$DM_tl/$tpc" ]] && rm -r "$DM_tl/$tpc"
			
			$DS/mngr.sh mkmn
			"$DC_tl/$jlb/tpc.sh" & exit 1
		fi
		
		[ "$ret" -eq 1 ] && exit
	else
		
		[[ -z "$2" ]] && nmt="" || nmt="$2"
		
		if [ $info2 -ge 50 ]; then
			rm "$DM_tl/.rn"
			msg "$topics_max" info &&
			killall add.sh & exit 1
		fi
		jlbi=$(dlg_form_0 "$new_topic" "$nmt")
		ret=$(echo "$?")

			jlb="$(clean_2 "$jlbi")"
			snme=$(cat $DC_tl/.cfg.1 | grep -Fxo "$jlb" | wc -l)
			
			if [ "$snme" -ge 1 ]; then
			
				jlb="$jlb $snme"
				dlg_msg_6 " <b>$name_eq   </b>\\n $name_eq2  <b>$jlb</b>   \\n"
				ret=$(echo "$?")
				
				[[ "$ret" -eq 1 ]] && rm "$DM_tl"/.rn && exit 1
				
			else
				jlb="$jlb"
			fi
			
			if [[ -z "$jlb" ]]; then
				rm "$DM_tl/.rn" && exit 1
				
			else
				mkdir "$DC_tl/$jlb"
				cp -f "$DS/default/tpc.sh" "$DC_tl/$jlb/tpc.sh"
				chmod +x "$DC_tl/$jlb/tpc.sh"
				[[ -f $DT/ntpc ]] && rm -f $DT/ntpc
				
				echo "$jlb" >> $DC_tl/.cfg.2
				"$DC_tl/$jlb/tpc.sh"
				$DS/mngr.sh mkmn
			fi
	fi
	
elif [ $1 = new_items ]; then

	[[ ! -f $DC/addons/dict/.dicts ]] && touch $DC/addons/dict/.dicts
	if  [ -z "$(cat $DC/addons/dict/.dicts)" ]; then
		source $DS/ifs/trans/$lgs/topics_lists.conf
		$DS/addons/Dics/cnfg.sh "" f "$no_dictionary"
		[[ -z "$(cat $DC/addons/dict/.dicts)" ]] && exit 1
	fi
	c=$(echo $(($RANDOM%1000)))
	txt="$4"; [[ -z "$txt" ]] && txt="$(xclip -selection primary -o)"

	if [ "$3" = 2 ]; then
		DT_r="$2"
		cd $DT_r
		[[ ! $(sed -n 1p $DC_s/cfg.3 | grep TRUE) ]] && srce="$5"
	else
		DT_r=$(mktemp -d $DT/XXXXXX)
		cd $DT_r
	fi
	
	[[ -f $DT_r/ico.jpg ]] && img="--image=$DT_r/ico.jpg" \
	|| img="--image=$DS/images/nw.png"
	
	
	if [ "$(cat $DC_tl/.cfg.1 | grep -v 'Feeds' | wc -l)" -lt 1 ]; then
		[[ -d $DT_r ]] && rm -fr $DT_r
		source $DS/ifs/trans/$lgs/topics_lists.conf
		$DS/chng.sh "$no_topic" & exit 1
	fi
	
	if [[ -z "$tpe" ]]; then
	tpcs=$(cat "$DC_tl/.cfg.2" | cut -c 1-40 \
	| tr "\\n" '!' | sed 's/\!*$//g')
	else
	tpcs=$(cat "$DC_tl/.cfg.2" | egrep -v "$tpe" | cut -c 1-40 \
	| tr "\\n" '!' | sed 's/\!*$//g')
	fi
	[ -n "$tpcs" ] && e='!'
	ttle="${tpe:0:50}"
	[[ "$tpe" != "$tpc" ]] && topic="$topic <b>*</b>" || topic="$topic"
	
	[[ ! -f $DC_s/cfg.3 ]] && echo 'FALSE' > $DC_s/cfg.3
	if sed -n 1p $DC_s/cfg.3 | grep 'TRUE'; then
	lzgpr="$(dlg_form_1)"
	elif sed -n 1p $DC_s/cfg.3 | grep 'FALSE'; then
	lzgpr="$(dlg_form_2)"
	fi
	ret=$(echo "$?")

	trgt=$(echo "$lzgpr" | head -n -1 | sed -n 1p | awk '{print tolower($0)}' | sed 's/^\s*./\U&\E/g')
	srce=$(echo "$lzgpr" | sed -n 2p | awk '{print tolower($0)}' | sed 's/^\s*./\U&\E/g')
	chk=$(echo "$lzgpr" | tail -1)
	tpe=$(cat "$DC_tl/.cfg.1" | grep "$chk")
		
		if [[ $ret -eq 3 ]]; then
		
			cd $DT_r
			scrot_1
			
			$DS/add.sh new_items $DT_r 2 "$trgt" "$srce" && exit 1
		
		elif [[ $ret -eq 2 ]]; then
		
			$DS/ifs/tls.sh add_audio $DT_r
			$DS/add.sh new_items $DT_r 2 "$trgt" "$srce" && exit 1
		
		elif [[ $ret -eq 0 ]]; then
		
			if [ -z "$trgt" ]; then
				[[ -d $DT_r ]] && rm -fr $DT_r
				exit
			fi

			if [ $(echo "$tpe" | wc -l) -ge 2 ]; then
				
				if [[ $(echo "$tpe" | sed -n 1p | wc -w) \
				= $(echo "$chk" | wc -w) ]]; then
					slt=$(echo "$tpe" | sed -n 1p)
					tpe="$slt"
				elif [[ $(echo "$tpe" | sed -n 2p | wc -w) \
				= $(echo "$chk" | wc -w) ]]; then
					slt=$(echo "$tpe" | sed -n 2p)
					tpe="$slt"
				else
					slt=`dlg_radiolist_1 "$tpe"`
					
					if [ -z "$(echo "$slt" | sed -n 2p)" ]; then
						killall add.sh & exit
					fi
					tpe=$(echo "$slt" | sed -n 2p)
				fi
			fi
			if [[ "$chk" = "$new *" ]]; then
				$DS/add.sh new_topic
			else
				echo "$tpe" > $DC_s/cfg.7
				echo "$tpe" > $DC_s/cfg.6
			fi
			
			if [ "$(echo "$trgt" | sed -n 1p | awk '{print tolower($0)}')" = i ]; then
				$DS/add.sh other_ways image $DT_r & exit 1
			elif [ "$(echo "$trgt" | sed -n 1p | awk '{print tolower($0)}')" = a ]; then
				$DS/add.sh other_ways audio $DT_r & exit 1
			elif [[ "$(echo ${trgt:0:4})" = 'Http' ]]; then
				$DS/add.sh other_ways "$trgt" $DT_r & exit 1
			elif [ $(echo "$trgt" | wc -c) -gt 150 ]; then
				$DS/add.sh other_ways "$trgt" $DT_r & exit 1
			elif ([ $lgt = ja ] || [ $lgt = 'zh-cn' ] || [ $lgt = ru ]); then
				if sed -n 1p $DC_s/cfg.3 | grep FALSE; then
					if [ -z "$4" ]; then
						[[ -d $DT_r ]] && rm -fr $DT_r
						msg "$no_text$lgsl." info & exit
					elif [ -z "$2" ]; then
						[[ -d $DT_r ]] && rm -fr $DT_r
						msg "$no_text$lgtl." info & exit
					fi
				fi

				srce=$(translate "$trgt" auto $lgs)
				
				if [ $(echo "$srce" | wc -w) = 1 ]; then
					$DS/add.sh new_word "$trgt" $DT_r "$srce" & exit
				elif [ $(echo "$srce" | wc -w) -ge 1 -a $(echo "$srce" | wc -c) -le 150 ]; then
					$DS/add.sh new_sentence "$trgt" $DT_r "$srce" & exit
				fi
			elif ([ $lgt != ja ] || [ $lgt != 'zh-cn' ] || [ $lgt != ru ]); then
				if [ $(echo "$trgt" | wc -w) = 1 ]; then
					$DS/add.sh new_word "$trgt" $DT_r "$srce" & exit
				elif [ $(echo "$trgt" | wc -w) -ge 1 -a $(echo "$trgt" | wc -c) -le 150 ]; then
					$DS/add.sh new_sentence "$trgt" $DT_r "$srce" & exit
				fi
			fi
		else
			[[ -d $DT_r ]] && rm -fr $DT_r
			exit
		fi
		
elif [ $1 = new_sentence ]; then

	if [ -z "$tpe" ]; then
		[[ -d $DT_r ]] && rm -fr $DT_r
		msg "$no_topic_msg." info & exit
	fi
		
	DT_r="$3"
	source $DS/default/dicts/$lgt
	DM_tlt="$DM_tl/$tpe"
	DC_tlt="$DC_tl/$tpe"
	icnn=idiomind
	
	dct=$DS/addons/Dics/cnfg.sh
			
	if [ $(cat "$DC_tlt/cfg.4" | wc -l) -ge 50 ]; then
		[[ -d $DT_r ]] && rm -fr $DT_r
		msg "$tpe  \\n$sentences_max" info & exit
	fi
	
	if sed -n 1p $DC_s/cfg.3 | grep TRUE; then
	
		internet
	
		cd $DT_r
		txt="$(clean_1 "$2")"
		translate "$txt" auto $lgt > ./.en
		sed -i ':a;N;$!ba;s/\n/ /g' ./.en
		sed -i 's/  / /g' ./.en
		sed -i 's/  / /g' ./.en
		trgt=$(cat ./.en | awk '{print tolower($0)}' | sed 's/^\s*./\U&\E/g')
		nme="$(nmfile "$trgt")"
		translate "$trgt" $lgt $lgs > ./.es
		sed -i ':a;N;$!ba;s/\n/ /g' ./.es
		srce=$(cat ./.es)
		sed -i 's/,/ /g' .en
		sed -i "s/'/ /g" .en
		sed -i 's/’/ /g' .en
		
		if [ ! -f $DT_r/audtm.mp3 ]; then
		
			tts .en $lgt $DT_r "$nme"
		else
			cp -f $DT_r/audtm.mp3 "$DM_tlt/$nme.mp3"
		fi
		
		if [[ ! -f "$DM_tlt/$nme.mp3" ]]; then
		    msg "$error1" dialog-advert & exit 1
		elif [[ -z "$trgt" ]]; then
		    msg "$error1" dialog-advert & exit 1
		elif [[ -z "$srce" ]]; then
		    msg "$error1" dialog-advert & exit 1
		fi
		
		tags_1 S "$trgt" "$srce" "$DM_tlt/$nme.mp3"

		if [ -f img.jpg ]; then
		
			scrot_2 "$DM_tlt/$nme.mp3"
			icnn=img.jpg
		fi
		
		cd $DT_r
		> swrd
		> twrd
		if ([ "$lgt" = ja ] || [ "$lgt" = "zh-cn" ] || [ "$lgt" = ru ]); then
			vrbl="$srce"; lg=$lgt; aw=$DT/swrd; bw=$DT/twrd
		else
			vrbl="$trgt"; lg=$lgs; aw=$DT/twrd; bw=$DT/swrd
		fi
		clean_3 "$vrbl" > $aw
		twrd=$(cat $aw | sed '/^$/d')
		src=$(translate "$twrd" auto $lg)
		echo "$src" | sed 's/,//g' | sed 's/\?//g' | sed 's/\¿//g' | sed 's/;//g' > $bw
		sed -i 's/\. /\n/g' $bw
		sed -i 's/\. /\n/g' $aw
		snmk=$(echo "$trgt"  | sed 's/ /\n/g')
		grammar_1 "$snmk" $DT_r
		list_words $aw $bw $DT_r
		grmrk=$(cat g_ | sed ':a;N;$!ba;s/\n/ /g')
		lwrds=$(cat A_)
		pwrds=$(cat B_ | tr '\n' '_')
		if ([ -z "$grmrk" ] || [ -z "$lwrds" ] || [ -z "$pwrds" ]); then
		    rm "$DM_tlt/$nme.mp3"
		    msg "$error1" dialog-warning & exit 1
		fi
		tags_3 W "$lwrds" "$pwrds" "$grmrk" "$DM_tlt/$nme.mp3"
		notify-send -i "$icnn" "$trgt" "$srce\\n($tpe)" -t 10000
		$DS/mngr.sh inx S "$trgt" "$tpe"
		
		(
		if [ $(sed -n 4p $DC_s/cfg.1) = TRUE ]; then
		$DS/add.sh selecting_words "$nme" "$tpe"
		fi
		) &

		get_words $aw $bw
		
		[[ -d $DT_r ]] && rm -fr $DT_r
		rm -f $DT/twrd $DT/swrd &
		echo "aitm.1.aitm" >> \
		$DC/addons/stats/.log
		exit 1
		
	else
		if [ -z "$4" ]; then
			[[ -d $DT_r ]] && rm -fr $DT_r
			msg "$no_text$lgsl." info & exit
		elif [ -z "$2" ]; then
			[[ -d $DT_r ]] && rm -fr $DT_r
			msg "$no_text$lgtl." info & exit
		fi
		
		cd $DT_r
		echo "$2" | sed ':a;N;$!ba;s/\n/ /g' \
		| sed 's/  / /g' | sed 's/   / /g' \
		| sed 's/"//g' | sed 's/^[ \t]*//;s/[ \t]*$//' > trgt
		
		trgt="$(cat trgt)"
		nme="$(nmfile "$(cat ./trgt)")"
		srce="$4"
		> swrd
		> twrd
		if ([ "$lgt" = ja ] || [ "$lgt" = "zh-cn" ] || [ "$lgt" = ru ]); then
			vrbl="$srce"; lg=$lgt; aw=$DT/swrd; bw=$DT/twrd
		else
			vrbl="$trgt"; lg=$lgs; aw=$DT/twrd; bw=$DT/swrd
		fi
		clean_3 "$vrbl" > $aw
		twrd=$(cat $aw | sed '/^$/d')
		src=$(translate "$twrd" auto $lg)
		echo "$src" | sed 's/,//g' | sed 's/\?//g' | sed 's/\¿//g' | sed 's/;//g' > $bw
		sed -i 's/\. /\n/g' $bw
		sed -i 's/\. /\n/g' $aw
		snmk=$(echo "$trgt"  | sed 's/ /\n/g')
		grammar_1 "$snmk" $DT_r
		list_words $aw $bw $DT_r
		grmrk=$(cat g_ | sed ':a;N;$!ba;s/\n/ /g')
		lwrds=$(cat A_)
		pwrds=$(cat B_ | tr '\n' '_')
		
		if [ -f $DT_r/audtm.mp3 ]; then
		
			mv -f $DT_r/audtm.mp3 "$DM_tlt/$nme.mp3"

				if [ -f img.jpg ]; then
					scrot_2 "$DM_tlt/$nme.mp3"
					icnn=img.jpg
				fi
				
		else
			voice "$trgt" "$DM_tlt/$nme.mp3"
			
				if [ -f img.jpg ]; then
					scrot_2 "$DM_tlt/$nme.mp3"
					icnn=img.jpg
				fi
		fi
		if [[ ! -f "$DM_tlt/$nme.mp3" ]]; then
		    msg "$error1" dialog-advert & exit 1
		elif [[ -z "$trgt" ]]; then
		    msg "$error1" dialog-advert & exit 1
		elif [[ -z "$srce" ]]; then
		    msg "$error1" dialog-advert & exit 1
		fi
		if ([ -z "$grmrk" ] || [ -z "$lwrds" ] || [ -z "$pwrds" ]); then
		    rm "$DM_tlt/$nme.mp3"
		    msg "$error1" dialog-warning & exit 1
		fi
		tags_4 S "$trgt" "$srce" "$lwrds" "$pwrds" "$grmrk" "$DM_tlt/$nme.mp3"
		notify-send -i "$icnn" "$trgt" "$srce\\n($tpe)" -t 10000
		$DS/mngr.sh inx S "$trgt" "$tpe"
		get_words $aw $bw
		
		echo "aitm.1.aitm" >> \
		$DC/addons/stats/.log
		[[ -d $DT_r ]] && rm -fr $DT_r
		rm -f $DT/twrd $DT/swrd & exit 1
	fi

elif [ $1 = new_word ]; then

	trgt="$2"
	srce="$4"
	dct="$DS/addons/Dics/cnfg.sh"
	source $DS/default/dicts/$lgt
	icnn=idiomind
	tpcs=$(cat "$DC_tl/.cfg.2" | cut -c 1-30 | egrep -v "$tpe" \
	| tr "\\n" '!' | sed 's/!\+$//g')
	ttle="${tpe:0:30}"
	DT_r="$3"
	cd $DT_r
	DM_tlt="$DM_tl/$tpe"
	DC_tlt="$DC_tl/$tpe"
	
	if [ $(cat "$DC_tlt/cfg.3" | wc -l) -ge 50 ]; then
		[[ -d $DT_r ]] && rm -fr $DT_r
		msg "$tpe    \\n$words_max" info & exit 1
	fi
	
	internet
	
	if sed -n 1p $DC_s/cfg.3 | grep TRUE; then

		trgt="$(translate "$trgt" auto $lgt)"
		srce="$(translate "$trgt" $lgt $lgs)"
		$dct "$trgt" $DT_r swrd

		nme=$(echo "$trgt" | sed "s/'//g")
		
		if [ -f "$DT_r/$trgt.mp3" ]; then

			cp -f "$DT_r/$trgt.mp3" "$DM_tlt/words/$nme.mp3"
			
			if [[ ! -f "$DM_tlt/words/$nme.mp3" ]]; then
			    msg "$error1" dialog-advert & exit 1
			elif [[ -z "$trgt" ]]; then
			    msg "$error1" dialog-advert & exit 1
			elif [[ -z "$srce" ]]; then
			    msg "$error1" dialog-advert & exit 1
			fi
			
			tags_1 W "$trgt" "$srce" "$DM_tlt/words/$nme.mp3"
			
			nt="$(echo "_$(grammar_2 $trgt)" | tr '\n' '_')"
			eyeD3 --set-encoding=utf8 -A IWI3I0I"$nt"IWI3I0I "$DM_tlt/words/$nme.mp3"
			
		else exit 1; fi
		
		if [ -f img.jpg ]; then
			scrot_3 "$DM_tlt/words/$nme.mp3" "$DM_tlt/words/images/$nme.jpg"
			icnn=img.jpg
		fi

		notify-send -i "$icnn" "$trgt" "$srce\\n($tpe)" -t 5000
		$DS/mngr.sh inx W "$nme" "$tpe"
		
		echo "aitm.1.aitm" >> \
		$DC/addons/stats/.log
		[[ -d $DT_r ]] && rm -fr $DT_r
		rm -f *.jpg
		
	else
		if [ -z "$4" ]; then
			[[ -d $DT_r ]] && rm -fr $DT_r
			msg "$no_text$lgsl." info & exit
		elif [ -z "$2" ]; then
			[[ -d $DT_r ]] && rm -fr $DT_r
			msg "$no_text$lgtl." info & exit 1
		fi
		
		if [ -f audtm.mp3 ]; then
		
			mv -f audtm.mp3 "$DM_tlt/words/$trgt.mp3"
			tags_1 W "$trgt" "$srce" "$DM_tlt/words/$trgt.mp3"

			if [ -f img.jpg ]; then
				scrot_3 "$DM_tlt/words/$trgt.mp3" "$DM_tlt/words/images/$trgt.jpg"
			fi
			
		else
			cd $DT_r
			$dct "$trgt" $DT_r swrd
			
			if [ -f "$DT_r/$trgt.mp3" ]; then
			
				mv -f "$DT_r/$trgt.mp3" "$DM_tlt/words/$trgt.mp3"

				if [ -f img.jpg ]; then
					scrot_3 "$DM_tlt/words/$trgt.mp3" "$DM_tlt/words/images/$trgt.jpg"
				fi
				
			else
				voice "$trgt" "$DM_tlt/words/$trgt.mp3"
				
				if [ -f img.jpg ]; then
					scrot_3 "$DM_tlt/words/$trgt.mp3" "$DM_tlt/words/images/$trgt.jpg"
				fi
			fi
		fi
		
		if [[ ! -f "$DM_tlt/words/$trgt.mp3" ]]; then
		    msg "$error1" dialog-advert & exit 1
		elif [[ -z "$trgt" ]]; then
		    msg "$error1" dialog-advert & exit 1
		elif [[ -z "$srce" ]]; then
		    msg "$error1" dialog-advert & exit 1
		fi
		
		tags_1 W "$trgt" "$srce" "$DM_tlt/words/$trgt.mp3"
		
		nt="$(echo "_$(grammar_2 $trgt)" | tr '\n' '_')"
		eyeD3 --set-encoding=utf8 -A IWI3I0I"$nt"IWI3I0I "$DM_tlt/words/$trgt.mp3"
			
		icnn="$DM_tlt/words/images/$trgt.jpg"
		notify-send -i "$icnn" "$trgt" "$srce\\n($tpe)" -t 3000
		$DS/mngr.sh inx W "$trgt" "$tpe"
		
		echo "aitm.1.aitm" >> \
		$DC/addons/stats/.log
		[[ -d $DT_r ]] && rm -fr $DT_r
		exit
	fi
	
elif [ $1 = selecting_words_edit ]; then

	c="$4"
	DIC=$DS/addons/Dics/cnfg.sh

	if [ "$3" = "F" ]; then

		tpe="$tpc"
		if [ $(cat "$DC_tlt/cfg.3" | wc -l) -ge 50 ]; then
			[[ -d $DT_r ]] && rm -fr $DT_r
			msg "$tpe    \\n$words_max" info & exit
		fi
		
		nw=$(cat "$DC_tlt/cfg.3" | wc -l)
		left=$((50 - $nw))
		info=$(echo " $remain"$left"$words")
		if [ $nw -ge 45 ]; then
			info=$(echo " $remain"$left"$words")
		elif [ $nw -ge 49 ]; then
			info=$(echo " $remain"$left"$word")
		fi

		mkdir $DT/$c; DT_r=$DT/$c; cd $DT_r

		list_words_2 "$DM_tlt/$2.mp3"
		slt=$(mktemp $DT/slt.XXXX.x)
		dlg_checklist_1 ./idlst "$info" "$slt"
		ret=$(echo "$?")

			if [ $ret -eq 0 ]; then
				list=$(cat "$slt" | sed 's/|//g')
				n=1
				while [ $n -le "$(cat "$slt" | head -50 | wc -l)" ]; do
					chkst=$(echo "$list" |sed -n "$n"p)
					echo "$chkst" | sed 's/TRUE//g' >> ./slts
					let n++
				done
				rm -f "$slt"
			fi
		
	elif [ "$3" = "S" ]; then
	
		nme="$2"
		DT_r="$DT/$c"
		cd $DT_r
		
		n=1
		while [ $n -le "$(cat ./slts | head -50 | wc -l)" ]; do

				trgt=$(sed -n "$n"p ./slts | awk '{print tolower($0)}' | sed 's/^\s*./\U&\E/g')
			if [ $(cat "$DC_tlt/cfg.3" | wc -l) -ge 50 ]; then
				echo "$trgt
" > logw
				
			else
				translate "$trgt" auto $lgs > tr."$c"
				UNI=$(cat tr."$c")
				$DIC "$trgt" $DT_r swrd
				
				if [ -f "$trgt.mp3" ]; then
				
					mv -f $DT_r/"$trgt.mp3" "$DM_tlt/words/$trgt.mp3"
				else
				
					voice "$trgt" "$DM_tlt/words/$trgt.mp3"
				fi
				
				tags_2 W "$trgt" "$UNI" "$5" "$DM_tlt/words/$trgt.mp3" >/dev/null 2>&1
				$DS/mngr.sh inx W "$trgt" "$tpc" "$nme"
			fi
			
			let n++
		done

		echo "aitm.$lns.aitm" >> \
		$DC/addons/stats/.log &

			if [ -f $DT_r/logw ]; then
				dlg_info_1 "$items_rest"
			fi
			[[ -d $DT_r ]] && rm -fr $DT_r
			rm -f logw $DT/*.$c & exit 1
	fi
	
elif [ $1 = selecting_words_dclik ]; then

	DM_tlt="$DM_tl/$tpe"
	DC_tlt="$DC_tl/$tpe"
	DT_r=$(cat $DT/.n_s_pr)
	cd $DT_r
	echo "$3" > ./lstws
	
	if [ -z "$tpe" ]; then
		[[ -d $DT_r ]] && rm -fr $DT_r
		source $DS/ifs/trans/$lgs/topics_lists.conf
		$DS/chng.sh "$no_edit" & exit 1
	fi
	
	nw=$(cat "$DC_tlt/cfg.3" | wc -l)
	
	if [ $(cat "$DC_tlt/cfg.3" | wc -l) -ge 50 ]; then
		[[ -d $DT_r ]] && rm -fr $DT_r
		msg "$tpe    \\n$words_max" info & exit
	fi

	left=$((50 - $nw))
	info=$(echo " $remain"$left"$words")
	if [ $nw -ge 45 ]; then
		info=$(echo " $remain"$left"$words")
	elif [ $nw -ge 49 ]; then
		info=$(echo " $remain"$left"$word ")
	fi

	list_words_3 ./lstws
	nme="$(nmfile "$(cat lstws)")"

	n=1
	while [ $n -le $(cat lst | wc -l) ]; do
	
	    ws$n=$(sed -n "$n"p lst)
	    echo ws$n
	    let n++
	done
	
	slt=$(mktemp $DT/slt.XXXX.x)
	dlg_checklist_1 ./lst info "$slt"
	ret=$(echo "$?")
	
	if [ $? -eq 0 ]; then
		list=$(cat "$slt" | sed 's/|//g')
		n=1
		    while [ $n -le $(cat "$slt" | head -50 | wc -l) ]; do
			chkst=$(echo "$list" |sed -n "$n"p)
			echo "$chkst" | sed 's/TRUE//g' >> ./wrds
			echo "$nme" >> wrdsls
			let n++
		    done
		    rm -f "$slt"
	    elif [ "$ret" -eq 1 ]; then
		rm -f $DT/*."$c"
		[[ -d $DT_r ]] && rm -fr $DT_r
		exit
	    fi
		
	$? >/dev/null 2>&1
	exit 1

elif [ $1 = selecting_words ]; then

	DM_tlt="$DM_tl/$tpe"
	DC_tlt="$DC_tl/$tpe"
	DIC=$DS/addons/Dics/cnfg.sh
	c=$(echo $(($RANDOM%100)))
	DT_r=$(mktemp -d $DT/XXXXXX)
	cd $DT_r
	if [ -z "$tpe" ]; then
		[[ -d $DT_r ]] && rm -fr $DT_r
		source $DS/ifs/trans/$lgs/topics_lists.conf
		$DS/chng.sh "$no_edit" & exit 1
	fi
	nw=$(cat "$DC_tlt/words/cfg.3" | wc -l)
	left=$((50 - $nw))
	if [ "$left" = 0 ]; then
		exit 1
		info=$(echo " $remain"$left"$words")
	elif [ $nw -ge 45 ]; then
		info=$(echo " $remain"$left"$words")
	elif [ $nw -ge 49 ]; then
		info=$(echo " $remain"$left"$word)")
	fi

	list_words_2 "$DM_tl/$3/$2.mp3"

	slt=$(mktemp $DT/slt.XXXX.x)
	dlg_checklist_1 ./idlst "$info" "$slt"
	ret=$(echo "$?")
		
		if [ $ret -eq 0 ]; then
			list=$(cat "$slt" | sed 's/|//g')
			n=1
			while [ $n -le $(cat "$slt" | head -50 | wc -l) ]; do
				chkst=$(echo "$list" |sed -n "$n"p)
				echo "$chkst" | sed 's/TRUE//g' >> ./slts
				let n++
			done
			rm -f "$slt"
		elif [ "$ret" -eq 1 ]; then
			rm -f $DT/*."$c"
			[[ -d $DT_r ]] && rm -fr $DT_r
			exit
		fi

	n=1
	while [ $n -le $(cat ./slts | head -50 | wc -l) ]; do
		trgt=$(sed -n "$n"p ./slts | awk '{print tolower($0)}' | sed 's/^\s*./\U&\E/g')
		if [ $(cat "$DC_tlt/cfg.3" | wc -l) -ge 50 ]; then
			echo "$trgt" >> logw
		else
			translate "$trgt" auto $lgs > tr."$c"
			UNI=$(cat ./tr."$c")
			$DIC "$trgt" $DT_r swrd
			
			if [ -f "$trgt.mp3" ]; then
			
				mv -f "$DT_r/$trgt.mp3" "$DM_tlt/words/$trgt.mp3"
				
			else
				voice "$trgt" "$DM_tlt/words/$trgt.mp3"
			fi
			
			if ( [ -f "$DM_tlt/words/$trgt.mp3" ] && [ -n "$trgt" ] && [ -n "$srce" ] ); then
			    tags_2 W "$trgt" "$UNI" "$2" "$DM_tlt/words/$trgt.mp3" >/dev/null 2>&1
			    $DS/mngr.sh inx W "$trgt" "$3"
			fi
		fi
		let n++
	done

	echo "aitm.$lns.aitm" >> \
	$DC/addons/stats/.log &

	if [ -f $DT_r/logw ]; then
		dlg_text_info_2 "$items_rest"
	fi
	
	rm -f $DT/*."$c" 
	[[ -d $DT_r ]] && rm -fr $DT_r
	exit
	
elif [ $1 = other_ways ]; then

	source $DS/ifs/trans/$lgs/add.conf
	wth=$(sed -n 3p $DC_s/cfg.18)
	eht=$(sed -n 4p $DC_s/cfg.18)
	ns=$(cat "$DC_tlt"/cfg.4 | wc -l)
	source $DS/default/dicts/$lgt
	nspr='/usr/share/idiomind/add.sh other_ways'
	LNK='http://www.chromium.org/developers/how-tos/api-keys'
	dct=$DS/addons/Dics/cnfg.sh
	lckpr=$DT/.n_s_pr
	DM_tlt="$DM_tl/$tpe"
	DC_tlt="$DC_tl/$tpe"
	DT_r="$3"
	cd "$DT_r"

	if [ -z "$tpe" ]; then
		[[ -d $DT_r ]] && rm -fr $DT_r
		source $DS/ifs/trans/$lgs/topics_lists.conf
		$DS/chng.sh "$no_edit" & exit 1
	fi

	if [ $ns -ge 50 ]; then
		msg "$tpe    \\n$sentences_max" info
		[[ -d $DT_r ]] && rm -fr $DT_r
		rm -f ls $lckpr & exit
	fi

	if [ -f $lckpr ]; then
	
		dlg_msg_3
		ret=$(echo "$?")

			if [ $ret -eq "3" ]; then
				rm=$(cat $lckpr)
				rm fr $rm $lckpr
				$DS/mngr.sh inx R && killall add.sh
				exit 1
			else
				exit 1
			fi
	fi
	
	if [ -n "$2" ]; then
		echo $DT_r > $DT/.n_s_pr
		lckpr=$DT/.n_s_pr
		prdt="$2"
	fi

	if [ "$(echo "$prdt")" = "audio" ]; then

		left=$((50 - $(cat "$DC_tlt/cfg.4" | wc -l)))
		key=$(sed -n 2p $DC_s/cfg.3)
		
		if [ -z "$key" ]; then
			
			msg "$no_key <a href='$LNK'>Web</a>\n" dialog-warning
			[[ -d $DT_r ]] && rm -fr $DT_r
			rm -f ls $lckpr & exit 1
		fi
		
		cd $HOME

		FL="$(dlg_file_1)"
		
		if [ -z "$FL" ];then
			[[ -d $DT_r ]] && rm -fr $DT_r
			rm -f $lckpr & exit 1
			
		else
			if [ -z "$tpe" ]; then
				[[ -d $DT_r ]] && rm -fr $DT_r
				source $DS/ifs/trans/$lgs/topics_lists.conf
				$DS/chng.sh "$no_edit" & exit 1
			fi
			cd $DT_r
			
			(
			echo "2"
			echo "# $file_pros" ; sleep 1
			cp -f "$FL" $DT_r/rv.mp3
			cd $DT_r
			eyeD3 -P itunes-podcast --remove "$DT_r"/rv.mp3
			eyeD3 --remove-all "$DT_r"/rv.mp3
			sox "$DT_r"/rv.mp3 "$DT_r"/c_rv.mp3 remix - highpass 100 norm \
			compand 0.05,0.2 6:-54,-90,-36,-36,-24,-24,0,-12 0 -90 0.1 \
			vad -T 0.6 -p 0.2 -t 5 fade 0.1 reverse \
			vad -T 0.6 -p 0.2 -t 5 fade 0.1 reverse norm -0.5
			rm -f "$DT_r"/rv.mp3
			mp3splt -s -o @n *.mp3
			rename 's/^0*//' *.mp3
			rm -f "$DT_r"/c_rv.mp3
			ls *.mp3 > lst
			lns=$(cat ./lst | head -50 | wc -l)
			
			internet
			 
			echo "3"
			echo "# $check_key... " ; sleep 1
			data="$(audio_recognize "$DS/addons/Google translation service/test.flac" $lgt $lgt $key)"
			if [ -z "$data" ]; then
				key=$(sed -n 3p $DC_s/cfg.3)
				data="$(audio_recognize "$DS/addons/Google translation service/test.flac" $lgt $lgt $key)"
			fi
			if [ -z "$data" ]; then
				key=$(sed -n 4p $DC_s/cfg.3)
				data="$(audio_recognize "$DS/addons/Google translation service/test.flac" $lgt $lgt $key)"
			fi
			if [ -z "$data" ]; then
			    msg "$key_err <a href='$LNK'>Google. </a>" error
				[[ -d $DT_r ]] && rm -fr $DT_r
				rm -f ls $lckpr & exit 1
			fi
			
			echo "# $file_pros" ; sleep 0.2
			#----------------------
			n=1
			while [ $n -le "$lns" ]; do

				sox "$n".mp3 info.flac rate 16k
				data="$(audio_recognize info.flac $lgt $lgt $key)"
				if [ -z "$data" ]; then
				
					msg "$key_err <a href='$LNK'>Google</a>" error
					[[ -d $DT_r ]] && rm -fr $DT_r
					rm -f ls $lckpr & break & exit 1
				fi

				trgt="$(echo "$data" | sed '1d' | sed 's/.*transcript":"//' \
				| sed 's/"}],"final":true}],"result_index":0}//g')"
				
				if [ $(echo "$trgt" | wc -c) -ge 150 ]; then
					echo "
$trgt" >> log
				
				else
					nme="$(nmfile "$trgt")"
					mv -f ./"$n".mp3 ./"$nme".mp3
					echo "$trgt" > ./"$nme".txt
					echo "$nme" >> ./ls
					rm -f info.flac info.ret
				fi
				prg=$((100*$n/$lns))
				echo "$prg"
				echo "# ${trgt:0:35} ... " ;
				
				let n++
			done
			
			) | dlg_progress_2
			
			sed -i '/^$/d' ./ls
			[[ $(echo "$tpe" | wc -c) -gt 40 ]] && tcnm="${tpe:0:40}..." || tcnm="$tpe"

			left=$((50 - $(cat "$DC_tlt"/cfg.4 | wc -l)))
			info=$(echo "$remain"$left"$sentences")
			if [ $ns -ge 45 ]; then
				info=$(echo "$remain"$left"$sentences")
			elif [ $ns -ge 49 ]; then
				info=$(echo "$remain"$left"$sentence")
			fi
			
			if [ -z "$(cat ls)" ]; then
			
				dlg_text_info_5 "$gettext_err"
				[[ -d $DT_r ]] && rm -fr $DT_r
				rm -f $lckpr & exit 1
				
			else
				dlg_checklist_5 ./ls
			fi
			
				if [ $? -eq 0 ]; then
				
					source /usr/share/idiomind/ifs/c.conf
					cd $DT_r
					list=$(cat "$slt" | sed 's/|//g')
					n=1
					while [ $n -le "$(cat "$slt" | head -50 | wc -l)" ]; do
						chkst=$(echo "$list" |sed -n "$n"p)
						echo "$chkst" | sed 's/TRUE//g' >> ./slts
						let n++
					done
					
					rm -f "$slt"
					sed -i 's/\://g' ./slts
					
					internet

					(
					echo "1"
					echo "# $pros... " ;
					[ $lgt = ja ] || [ $lgt = "zh-cn" ] || [ $lgt = ru ] && c=c || c=w
					lns=$(cat ./slts ./wrds | wc -l)
					n=1
					while [ $n -le $(cat ./slts | head -50 | wc -l) ]; do
						
						sntc=$(sed -n "$n"p ./slts)
						trgt=$(cat "./$sntc.txt")
						nme="$(nmfile "$sntc")"
						
						if [ $(sed -n 1p "$sntc.txt" | wc -$c) -eq 1 ]; then
						
							if [ $(cat "$DC_tlt"/cfg.3 | wc -l) -ge 50 ]; then
								echo "
$sntc" >> ./slog
						
							else
								srce="$(translate "$trgt" $lgt $lgs)"
								mv -f "$sntc".mp3 "$DM_tlt/words/$nme".mp3
								
								if ( [ -f "$DM_tlt/words/$nme".mp3 ] && [ -n "$trgt" ] && [ -n "$srce" ] ); then
								    tags_1 W "$trgt" "$srce" "$DM_tlt/words/$nme".mp3
								    $DS/mngr.sh inx W "$nme" "$tpe"
								    echo "$nme" >> addw
								fi
							fi
						
						elif [ $(sed -n 1p "$sntc.txt" | wc -$c) -ge 1 ]; then
						
							if [ $(cat "$DC_tlt"/cfg.4 | wc -l) -ge 50 ]; then
								echo "
$sntc" >> ./wlog
						
							else
								srce="$(translate "$trgt" $lgt $lgs | sed ':a;N;$!ba;s/\n/ /g')"
								
								mv -f "$sntc.mp3" "$DM_tlt/$nme.mp3"
								
								if ( [ -f "$DM_tlt/$nme.mp3" ] && [ -n "$trgt" ] && [ -n "$srce" ] ); then
								    tags_1 S "$trgt" "$srce" "$DM_tlt/$nme.mp3"
								    $DS/mngr.sh inx S "$trgt" "$tpe"
								    echo "$nme" >> adds
								fi

								(
								r=$(echo $(($RANDOM%1000)))
								> twrd_$r
								> swrd_$r
								if ([ "$lgt" = ja ] || [ "$lgt" = "zh-cn" ] || [ "$lgt" = ru ]); then
									vrbl="$srce"; lg=$lgt; aw=$DT/swrd_$r; bw=$DT/twrd_$r
								else
									vrbl="$trgt"; lg=$lgs; aw=$DT/twrd_$r; bw=$DT/swrd_$r
								fi

								clean_3 "$vrbl" > $aw
								twrd=$(cat $aw | sed '/^$/d')
								srce="$(translate "$twrd" auto $lg)"
								echo "$srce" | sed 's/,//g' | sed 's/\?//g' | sed 's/\¿//g' | sed 's/;//g' > $bw
								> A_$r
								> B_$r
								> g_$r
								sed -i 's/\. /\n/g' $bw
								sed -i 's/\. /\n/g' $aw
								snmk=$(echo "$trgt"  | sed 's/ /\n/g')
								grammar_1 "$snmk" $DT_r $r
								list_words $aw $bw $DT_r $r
								grmrk=$(cat g_$r | sed ':a;N;$!ba;s/\n/ /g')
								lwrds=$(cat A_$r)
								pwrds=$(cat B_$r | tr '\n' '_')
								tags_3 W "$lwrds" "$pwrds" "$grmrk" "$DM_tlt/$nme.mp3"
								get_words $aw $bw

								echo "__" >> x
								) &
						
								rm -f "$nme".mp3 TMP1.mp3 TMP2.mp3 TMP3.mp3 TMP4.mp3 
							fi
						fi
					
						prg=$((100*$n/$lns-1))
						echo "$prg"
						echo "# ${sntc:0:35} ... " ;
						
						let n++
					done
					
					#-words
					if [ -n "$(cat wrds)" ]; then
						nwrds=" y $(cat wrds | head -50 | wc -l) Palabras"
					fi
					
					n=1
					while [ $n -le "$(cat wrds | head -50 | wc -l)" ]; do
						trgt=$(sed -n "$n"p wrds | awk '{print tolower($0)}' | sed 's/^\s*./\U&\E/g')
						exmp=$(sed -n "$n"p wrdsls)
						nme="$(nmfile "$exmp")"

						if [ $(cat "$DC_tlt"/cfg.3 | wc -l) -ge 50 ]; then
							echo "
$trgt" >> ./wlog
					
						else
							srce="$(translate "$trgt" auto $lgs)"
							$dct "$trgt" $DT_r swrd
							
							if [ -f "$trgt".mp3 ]; then
							
								mv -f "$DT_r/$trgt.mp3" "$DM_tlt/words/$trgt.mp3"
							else
								voice "$trgt" "$DM_tlt/words/$trgt.mp3"
								
							fi
							if ( [ -f "$DM_tlt/words/$trgt.mp3" ] && [ -n "$trgt" ] && [ -n "$srce" ] ); then
							    tags_2 W "$trgt" "$srce" "$exmp" "$DM_tlt/words/$trgt.mp3" >/dev/null 2>&1
							    $DS/mngr.sh inx W "$trgt" "$tpe" "$nme"
							    echo "$trgt" >> addw
							fi
						fi
						
						nn=$(($n+$(cat ./slts | wc -l)-1))
						prg=$((100*$nn/$lns))
						echo "$prg"
						echo "# ${trgt:0:35} ... " ;
						
						let n++
					done
					) | dlg_progress_2

					cd $DT_r
					
					if [ -f ./wlog ]; then
						wadds=" $(($(cat ./addw | wc -l) - $(cat ./wlog | sed '/^$/d' | wc -l)))"
						W=" $words"
						if [ $(echo $wadds) = 1 ]; then
							W=" $word"
						fi
					else
						wadds=" $(cat ./addw | wc -l)"
						W=" $words"
						if [ $(echo $wadds) = 1 ]; then
							wadds=" $(cat ./addw | wc -l)"
							W=" $word"
						fi
					fi
					if [ -f ./slog ]; then
						sadds=" $(($(cat ./adds | wc -l) - $(cat ./slog | sed '/^$/d' | wc -l)))"
						S=" $sentences"
						if [ $(echo $sadds) = 1 ]; then
							S=" $sentence"
						fi
					else
						sadds=" $(cat ./adds | wc -l)"
						S=" $sentences"
						if [ $(echo $sadds) = 1 ]; then
							S=" $sentence"
						fi
					fi
					
					logs=$(cat ./slog ./wlog)
					adds=$(cat ./adds ./addw | wc -l)
					
					if [ $adds -ge 1 ]; then
						notify-send -i idiomind "$tpe" "$is_added\n$sadds$S$wadds$W" -t 2000 &
						echo "aitm.$adds.aitm" >> \
						$DC/addons/stats/.log
					fi
					
					if [ -f ./log ]; then
						if [ $(ls ./*.mp3 | wc -l) -ge 1 ]; then
							btn="--button=$save:0"
						fi
						dlg_msg_2 "$items_rest $logn" "$btn" >/dev/null 2>&1

							ret=$(echo "$?")
						
							if  [ "$ret" -eq 0 ]; then
								aud=$(dlg_file_2)
									ret=$(echo "$?")
									if [ "$ret" -eq 0 ]; then
									    tar cvzf audio.tar.gz ./*.mp3, *.txt
									    mv -f audio.tar.gz "$aud"
									fi
							fi
					fi
					
					if  [ -f ./log ]; then
						rm=$(($(cat ./adds) - $(cat ./log | sed '/^$/d' | wc -l)))
					else
						rm=$(cat ./adds)
					fi
					
					n=1
					while [[ $n -le 20 ]]; do
						 sleep 5
						 if ([ $(cat ./x | wc -l) = $rm ] || [ $n = 20 ]); then
							[[ -d $DT_r ]] && rm -fr $DT_r
							rm -f $lckpr & break & exit 1
						 fi
						let n++
					done
					exit 1
				else
					[[ -d $DT_r ]] && rm -fr $DT_r
					rm -f $lckpr $slt & exit 1
				fi
		fi
	fi

	if [ $(echo ${2:0:4}) = 'Http' ]; then
	
		internet
		
		(
		echo "1"
		echo "# $pros..." ;
		lynx -dump -nolist $2  | sed -n -e '1x;1!H;${x;s-\n- -gp}' \
		| sed 's/\./\.\n/g' | sed 's/<[^>]*>//g' | sed 's/ \+/ /g' \
		| sed '/^$/d' | sed 's/  / /g' | sed 's/^[ \t]*//;s/[ \t]*$//g' \
		| sed '/</ {:k s/<[^>]*>//g; /</ {N; bk}}' \
		| sed 's/<[^>]\+>//g' | sed 's/\://g' >> ./sntsls_
		
		) | dlg_progress_1

	elif [[ "$(echo "$2" | grep -o "i")" = i ]]; then
		
		SCR_IMG=`mktemp`
		trap "rm $SCR_IMG*" EXIT
		scrot -s $SCR_IMG.png
		
		(
		echo "1"
		echo "# $pros..." ;
		mogrify -modulate 100,0 -resize 400% $SCR_IMG.png
		tesseract $SCR_IMG.png $SCR_IMG &> /dev/null
		cat $SCR_IMG.txt | sed 's/\\n/./g' | sed 's/\./\n/g' \
		| sed '/^$/d' | sed 's/^[ \t]*//;s/[ \t]*$//' \
		| sed 's/  / /g' | sed 's/\://g' > ./sntsls_
		
		) | dlg_progress_1

	else
		(
		echo "1"
		echo "# $pros..." ;
		echo "$prdt" | sed 's/\\n/./g' | sed 's/\./\n/g' \
		| sed '/^$/d' | sed 's/^[ \t]*//;s/[ \t]*$//' \
		| sed 's/  / /g' | sed 's/\://g' > ./sntsls_
		
		) | dlg_progress_1
		
	fi
		while read sntnc
		do
			if [ $(echo "$sntnc" | wc -c) -ge 150 ]; then
				less="$(echo "$sntnc" | sed 's/\,/\n/g')"
				n=1
				while [ $n -le $(echo "$less" | wc -l) ]; do
					sn=$(echo "$less" | sed -n "$n"p)
					echo "$sn" >> ./sntsls
					let n++
				done
			else
				echo "$sntnc" >> ./sntsls
			fi
		done < ./sntsls_

		sed -i '/^$/d' ./sntsls
		[[ $(echo "$tpe" | wc -c) -gt 40 ]] && tcnm="${tpe:0:40}..." || tcnm="$tpe"
		
		left=$((50 - $ns))
		info=$(echo "$remain$left$sentences")

		if [ $ns -ge 45 ]; then
			info=$(echo "$remain$left$sentences")
		elif [ $ns -ge 49 ]; then
			info=$(echo "$remain$left$sentence")
		fi
		
		if [ -z "$(cat ./sntsls)" ]; then
		
			dlg_text_info_4 " $gettext_err1."

			[[ -d $DT_r ]] && rm -fr $DT_r
			rm -f $lckpr $slt & exit 1
		
		else
			dlg_checklist_3 ./sntsls

				ret=$(echo "$?")
		fi
				if [ $ret -eq 2 ]; then
					rm -f $lckpr "$slt" &
					w=`dlg_text_dlg_info_1 ./sntsls`
						ret=$(echo "$?")
						if [ $ret -eq 0 ]; then
							$nspr "$w" $DT_r "$tpe" &
							exit 1
						else
							[[ -d $DT_r ]] && rm -fr $DT_r
							rm -f $lckpr $slt & exit 1
						fi
				
				elif [ $ret -eq 0 ]; then
				
					source /usr/share/idiomind/ifs/c.conf
					list=$(cat "$slt" | sed 's/|//g')
					n=1
					while [ $n -le $(cat "$slt" | wc -l) ]; do
						chkst=$(echo "$list" |sed -n "$n"p)
						if echo "$chkst" | grep "TRUE"; then
							echo "$chkst" | sed 's/TRUE//g' >> slts
						fi
						let n++
					done
					
					rm -f $slt
					
					internet
					
					cd $DT_r
					> ./wlog
					> ./slog
					
					#words
					{
					echo "5"
					echo "# $pros... " ;
					[ $lgt = ja ] || [ $lgt = 'zh-cn' ] || [ $lgt = ru ] && c=c || c=w
					lns=$(cat ./slts ./wrds | wc -l)
					n=1
					while [ $n -le $(cat slts | head -50 | wc -l) ]; do
						sntc=$(sed -n "$n"p slts)
						if [ $(echo "$sntc" | wc -$c) = 1 ]; then
							if [ $(cat "$DC_tlt"/cfg.3 | wc -l) -ge 50 ]; then
								echo "
$sntc" >> ./wlog
						
							else
								trgt="$(translate "$sntc" auto $lgt)"
								srce="$(translate "$trgt" $lgt $lgs)"
								wget -q -U Mozilla -O $DT_r/$trgt.mp3 "https://translate.google.com/translate_tts?ie=UTF-8&tl=$lgt&q=$trgt"
								mv -f "$trgt".mp3 "$DM_tlt/words/$trgt".mp3
								
								if ( [ -f "$DM_tlt/words/$trgt".mp3 ] && [ -n "$trgt" ] && [ -n "$srce" ] ); then
								    tags_1 W "$trgt" "$srce" "$DM_tlt/words/$trgt".mp3
								    echo "$trgt" >> addw
								    $DS/mngr.sh inx W "$trgt" "$tpe"
								fi
							fi
						#words
						elif [ $(echo "$sntc" | wc -$c) -ge 1 ]; then
							
							if [ $(cat "$DC_tlt"/cfg.4 | wc -l) -ge 50 ]; then
								echo "
$sntc" >> ./slog
						
							else
								if [ $(echo "$sntc" | wc -c) -ge 150 ]; then
									echo "
$sntc" >> ./slog
							
								else
									txt="$(clean_1 "$sntc")"
									translate "$txt" auto $lgt > ./trgt
									sed -i ':a;N;$!ba;s/\n/ /g' ./trgt
									trgt=$(cat ./trgt | awk '{print tolower($0)}' | sed 's/^\s*./\U&\E/g')
									nme="$(nmfile "$trgt")"
									srce="$(translate "$trgt" $lgt $lgs | sed ':a;N;$!ba;s/\n/ /g')"
									
									if sed -n 1p $DC_s/cfg.3 | grep TRUE; then
									
										tts ./trgt $lgt $DT_r "$nme"
										
									else
										voice "$trgt" "$DM_tlt/$nme.mp3"
										
									fi
									
									if ( [ -f "$DM_tlt/$nme.mp3" ] && [ -n "$trgt" ] && [ -n "$srce" ] ); then
									    tags_1 S "$trgt" "$srce" "$DM_tlt/$nme.mp3"
									    echo "$nme" >> adds
									    $DS/mngr.sh inx S "$trgt" "$tpe"
									fi
									
									
									(
									r=$(echo $(($RANDOM%1000)))
									> twrd_$r
									> swrd_$r
									if ([ "$lgt" = ja ] || [ "$lgt" = "zh-cn" ] || [ "$lgt" = ru ]); then
										vrbl="$srce"; lg=$lgt; aw=$DT/swrd_$r; bw=$DT/twrd_$r
									else
										vrbl="$trgt"; lg=$lgs; aw=$DT/twrd_$r; bw=$DT/swrd_$r
									fi
									clean_3 "$vrbl" > $aw
									twrd=$(cat $aw | sed '/^$/d')
									translate "$twrd" auto $lg | sed 's/,//g' | sed 's/\?//g' | sed 's/\¿//g' | sed 's/;//g' > $bw
									> A_$r
									> B_$r
									> g_$r
									sed -i 's/\. /\n/g' $bw
									sed -i 's/\. /\n/g' $aw
									snmk=$(echo "$trgt"  | sed 's/ /\n/g')
									grammar_1 "$snmk" $DT_r $r
									list_words $aw $bw $DT_r $r
									grmrk=$(cat g_$r | sed ':a;N;$!ba;s/\n/ /g')
									lwrds=$(cat A_$r)
									pwrds=$(cat B_$r | tr '\n' '_')
									tags_3 W "$lwrds" "$pwrds" "$grmrk" "$DM_tlt/$nme.mp3"
									get_words $aw $bw

									echo "__" >> x
									rm -f $aw $bw 
										
									) &
									
									rm -f "$nme".mp3 TMP1.mp3 TMP2.mp3 TMP3.mp3 TMP4.mp3 
								fi
							fi
						fi
						
						prg=$((100*$n/$lns-1))
						echo "$prg"
						echo "# ${sntc:0:35}... " ;
						
						let n++
					done
					
					#words
					n=1
					while [ $n -le $(cat wrds | head -50 | wc -l) ]; do
					
						exmp=$(sed -n "$n"p wrdsls)
						itm=$(sed -n "$n"p wrds | awk '{print tolower($0)}' | sed 's/^\s*./\U&\E/g')
						nme="$(nmfile "$exmp")"

						if [ $(cat "$DC_tlt"/cfg.3 | wc -l) -ge 50 ]; then
							echo "
$itm" >> ./wlog
					
						else
							srce="$(translate "$itm" auto $lgs)"
							$dct "$itm" $DT_r swrd
							
							if [ -f "$itm".mp3 ]; then
								mv -f "$DT_r/$itm.mp3" "$DM_tlt/words/$itm.mp3"
							fi
							
							if ( [ -f "$DM_tlt/words/$itm.mp3" ] && [ -n "$itm" ] && [ -n "$srce" ] ); then
							    tags_2 W "$itm" "$srce" "$exmp" "$DM_tlt/words/$itm.mp3"
							    $DS/mngr.sh inx  W "$itm" "$tpe" "$nme"
							    echo "$itm" >> addw
							fi
						fi
						
						nn=$(($n+$(cat ./slts | wc -l)-1))
						prg=$((100*$nn/$lns))
						echo "$prg"
						echo "# ${itm:0:35}... " ;
						
						let n++
					done
					} | dlg_progress_2

					cd $DT_r
					
					if [ -f ./wlog ]; then
						wadds=" $(($(cat ./addw | wc -l) - $(cat ./wlog | sed '/^$/d' | wc -l)))"
						W=" $words"
						if [ $(echo $wadds) = 1 ]; then
							W=" $word"
						fi
					else
						wadds=" $(cat ./addw | wc -l)"
						W=" $words"
						if [ $(echo $wadds) = 1 ]; then
							wadds=" $(cat ./addw | wc -l)"
							W=" $word"
						fi
					fi
					if [ -f ./slog ]; then
						sadds=" $(($(cat ./adds | wc -l) - $(cat ./slog | sed '/^$/d' | wc -l)))"
						S=" $sentences"
						if [ $(echo $sadds) = 1 ]; then
							S=" $sentence"
						fi
					else
						sadds=" $(cat ./adds | wc -l)"
						S=" $sentences"
						if [ $(echo $sadds) = 1 ]; then
							S=" $sentence"
						fi
					fi
					
					logs=$(cat ./slog ./wlog)
					adds=$(cat ./adds ./addw | wc -l)
					
					source $DS/ifs/trans/$lgs/add.conf
					
					if [ $adds -ge 1 ]; then
						notify-send -i idiomind "$tpe" "$is_added\n$sadds$S$wadds$W" -t 2000 &
						echo "aitm.$adds.aitm" >> \
						$DC/addons/stats/.log
					fi
					
					if [ $(cat ./slog ./wlog | wc -l) -ge 1 ]; then
						
						dlg_text_info_3 "$items_rest" "$logs" >/dev/null 2>&1
						
					fi
					if  [ $(cat ./slog ./wlog | wc -l) -ge 1 ]; then
						rm=$(($(cat ./addw ./adds | wc -l) - $(cat ./slog ./wlog | sed '/^$/d' | wc -l)))
					else
						rm=$(cat ./addw ./adds | wc -l)
					fi
					
					n=1
					while [[ $n -le 20 ]]; do
						 sleep 5
						 if ([ $(cat ./x | wc -l) = $rm ] || [ $n = 20 ]); then
							[[ -d $DT_r ]] && rm -fr $DT_r
							rm -f $lckpr & break & exit 1
						 fi
						let n++
					done
					
				else
					[[ -d $DT_r ]] && rm -fr $DT_r
					 rm -f $lckpr $slt & exit 1
				fi
				
elif [ $1 = set_image ]; then
	cd $DT
	wrd="$2"
	echo '<html>
<head>
<meta http-equiv="Refresh" content="0;url=https://www.google.com/search?q=XxXx&tbm=isch">
</head>
<body>
<p>Search images for '"'XxXx'"'...</p>
</body>
</html>' > html

	sed -i 's/XxXx/'"$wrd"'/g' html
	mv -f html s.html
	chmod +x s.html
	ICON=$DS/icon/nw.png
	btnn=$(echo --button=$add_image:3)
	
	if [ "$3" = word ]; then
		
		if [ ! -f "$DT/$wrd.*" ]; then
			file="$DM_tlt/words/$wrd.mp3"
		fi
		
		if [ -f "$DM_tlt/words/images/$wrd.jpg" ]; then
			ICON="--image=$DM_tlt/words/images/$wrd.jpg"
			btnn=$(echo --button=$change:3)
			btn2=$(echo --button=$delete:2)
		else
			txt="--text=<small>$images_for  <a href='file://$DT/s.html'>$wrd</a></small>"
		fi
		
		dlg_form_5 "$btnn" "$btn2" "$ICON" "$txt"
		ret=$(echo "$?")

			if [ $ret -eq 3 ]; then
			
				rm -f *.l
				scrot_4 "$wrd" "$file" "$DM_tlt/words/images/$wrd.jpg" &&

				rm -f *.jpeg
				$DS/add.sh set_image "$wrd" w
				
			elif [ $ret -eq 2 ]; then
			
				eyeD3 --remove-image "$file"
				rm -f "$DM_tlt/words/images/$wrd.jpg"
				rm -f *.jpeg s.html
				
			else
				rm -f *.jpeg s.html
			fi
			
	elif [ "$3" = sentence ]; then
	
		if [ ! -f "$DT/$wrd.*" ]; then
			file="$DM_tlt/$wrd.mp3"
		fi
		
		btnn=$(echo "--button=$add_image:3")
		eyeD3 --write-images=$DT "$file" >/dev/null 2>&1
		
		if [ -f "$DT/ILLUSTRATION".jpeg ]; then
			mv -f "$DT/ILLUSTRATION".jpeg "$DT/imgsw".jpeg
			ICON="--image=$DT/imgsw.jpeg"
			btnn=$(echo --button=$change:3)
			btn2=$(echo --button=$delete:2)
			
		else
			txt="--text=<small>$search_images \\n<a href='file://$DT/s.html'>$wrd</a></small>"
		fi
		dlg_form_6 "$btnn" "$btn2" "$ICON" "$txt"

			ret=$(echo "$?")
				
			if [ $ret -eq 3 ]; then
			
				rm -f $DT/*.l
				
				scrot_5 "$wrd" "$file" &&

				rm -f *.jpeg
				echo "aimg.$tpc.aimg" >> \
				$DC/addons/stats/.log &
				$DS/add.sh set_image "$wrd" s
				
			elif [ $ret -eq 2 ]; then
				eyeD3 --remove-images "$file" >/dev/null 2>&1
				rm -f s.html *.jpeg
			else
				rm -f s.html *.jpeg
			fi
	fi
fi
