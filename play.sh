#!/bin/bash
source /usr/share/idiomind/ifs/c.conf
tlng="$DC_tlt/.tlng-inx"
winx="$DC_tlt/.winx"
sinx="$DC_tlt/.sinx"
indw=$(grep -F -x -v -f "$sinx" "$tlng")
inds=$(grep -F -x -v -f "$winx" "$tlng")
cd "$DC_tlt/Practice"
indp=$(cat fin.tmp mcin.tmp \
lwin.tmp | sed '/^$/d' | sort | uniq)
indf=$(cat $DC_tl/Feeds/.t-inx)
uid=$(echo "$(whoami)")
infs=$(echo "$snts Sentences" | wc -l)
infw=$(echo "$wrds Words" | wc -l)
#eht=$(sed -n 7p $HOME/.config/idiomind/s/.rd)
#wth=$(sed -n 8p $HOME/.config/idiomind/s/.rd)

if [[ "$1" = d ]]; then
	uid=$(echo "$(whoami)")
	pst=$(sed -n 1p $DC_s/.pst)
	> $DT/.$uid/INACT
	> $DT/.$uid/ACTIV
	slt=$(mktemp $DT/slt.XXX.s)
	INACT=$DT/.$uid/INACT
	ACTIV=$DT/.$uid/ACTIV
	cd $DT/.$uid/
	
	if echo "$2" | grep "Notification"; then
		cnf1=$(mktemp $DT/cnf1.XXXX.s)
		cnf2=$(mktemp $DT/cnf2.XXXX.s)
		bcl=$(sed -n 1p $DC_s/cnfg2)
		KEY=12342
		
		if [[ -z "$bcl" ]]; then
			echo 8 > $DC_s/cnfg2
			echo $pst >> $DC_s/cnfg2
			bcl=$(sed -n 1p $DC_s/cnfg2)
		fi
		pst2=$(sed -n 2p $DC_s/cnfg2)
		
			$yad --fixed --plug=$KEY --tabnum=1 \
			--mark="8 s":8 --mark="60 s":60 --mark="120 s":120 \
			--borders=20 --button=Ok:0 --scale  \
			--min-value=2 --max-value=128 --value="$bcl" --step 2 > $cnf1 &
			$yad --fixed --plug=$KEY --tabnum=2 \
			--mark="200":200 --mark="400":400 --mark="600":600 --mark="800":800 \
			--mark="1000":1000 --mark="1200":1200 --mark="1400":1400  \
			--borders=0 --scale --vertical \
			--min-value=2 --max-value=1600 --value="$pst2" --step=2 > $cnf2 &
			$yad --notebook --center --key=$KEY --name=idiomind --on-top \
			--fixed --sticky --skip-taskbar --window-icon=idiomind \
			--tab="  Time  " --tab="  Position  " --borders=10 \
		    --title="Play" --width=400 --height=280 --buttons-layout=right \
		    --button="	Ok    ":0
		
			if [[ "$?" -eq 0 ]]; then
				a=$(cat "$cnf1")
				b=$(cat "$cnf2")
				if [[ "$b" -gt "$pst" ]]; then
					b="$pst"
				fi
				sed -i "1s/.*/$a/" $DC_s/cnfg2
				sed -i "2s/.*/$b/" $DC_s/cnfg2
				"$?">/dev/null 2>&1
				fi
				rm -f $cnf1 $cnf2 $cnf3
			[ "$?" -eq 1 ] & rm -f $cnf1 $cnf2 $cnf3 & exit 1
				"$?">/dev/null 2>&1
			exit 1
	
	elif echo "$2" | grep "Notification"; then
		exit 1
	elif echo "$2" | grep "Words"; then
		wttle="$tpc"
		sinda="$DC_tlt/indwa"
		sinde="$DC_tlt/indwe"
		inda=./indwa
		inde=./indwe
		ind=./indw
		info="Reproducir solo estas palabras:"
	elif echo "$2" | grep "Sentences"; then
		wttle="$tpc"
		sinda="$DC_tlt/indsa"
		sinde="$DC_tlt/indse"
		inda=./indsa
		inde=./indse
		ind=./inds
		info="Reproducir solo estas Oraciones:"
	elif echo "$2" | grep "Practice"; then
		wttle="$tpc"
		sinda="$DC_tlt/indpa"
		sinde="$DC_tlt/indpe"
		inda=./indpa
		inde=./indpe
		ind=./indp
		info="Reproducir solo estas Palabras (Practica):"
	elif echo "$2" | grep "Feeds"; then
		wttle="Conten saved from Feeds"
		sinda="$DC_tlf/indfa"
		sinde="$DC_tlf/indfe"
		inda=./indfa
		inde=./indfe
		ind=./indf
		info="Reproducir solo este contenido (Feed):"
	fi
	
	if ( [ -z $(cat "$inda") ] && [ -z $(cat "$inde") ] ); then
	echo "No se encuentra contenido" | \
		$yad --text-info \
		--print-all --always-print-result --on-top \
		--text=" " \
		--center --sticky --multiple --no-headers \
		--skip-taskbar --on-top --margins=5 \
		--buttons-layout=end --width=400 \
		--height=280 --borders=10 \
		--button=Ok:0 \
		--title="$wttle" --fontname=Arial
			rm "$sinda" "$sinde" "$inde" "$inda"
			exit 1
	else
	((cat "$inda" | awk '{print "TRUE\n"$0}') && \
		(cat "$inde" | awk '{print "FALSE\n"$0}')) | \
		$yad --list --checklist \
		--print-all --always-print-result --on-top \
		--text="<sup> $info </sup>" \
		--center --sticky --multiple --no-headers \
		--ellipsize=END --skip-taskbar --on-top \
		--buttons-layout=end --width=400 \
		--height=280 --borders=10 --window-icon=idiomind \
		--button="Play all":2 \
		--button=gtk-apply:0 \
		--title="$wttle" \
		--column="" --column="Select" > "$slt"
	fi
		ret=$?
		
		if [ $ret -eq 0 ]; then
			lst=$(cat "$slt" | sed 's/|//g')
			rm -f "$inda" "$inde"
			n=1
			while [ $n -le $(cat "$slt" | wc -l) ]; do
				itm=$(echo "$lst" | sed -n "$n"p)
				if echo "$itm" | grep "FALSE"; then
					echo "$itm" | sed 's/FALSE//g' >> "$inde"
				elif echo "$itm" | grep "TRUE"; then
					echo "$itm" | sed 's/TRUE//g' >> "$inda"
				fi
				let n++
			done
			
			cp -f "$inde" "$sinde"
			cp -f "$inda" "$sinda"
			rm -f $DT/*.s
			exit 1
				
		elif [ $ret -eq 2 ]; then
			kill -9 $(pgrep -f "$yad --list ") &
			rm "$sinda" "$sinde" "$inde" "$inda"
			$DS/play.sh
			rm -f $DT/*.s
			exit 1
		
		else
			"$?">/dev/null 2>&1
			rm -f $DT/*.s
			exit 1
		fi
fi

Words="Words"
if [ -f "$DC_tlt/indwa" ]; then
	Words="Words *"
fi
Sentences="Sentences"
if [ -f "$DC_tlt/indsa" ]; then
	Sentences="Sentences *"
fi
Practice="Practice"
if [ -f "$DC_tlt/indpa" ]; then
	Practice="Practice *"
fi
Feeds="Feeds"
if [ -f "$DC_tlf/indfa" ]; then
	Feeds="Feeds *"
fi

if [ ! -d $DT/.$uid ]; then
	mkdir $DT/.$uid/
	cd $DT/.$uid
	
	if [ -f "$DC_tlt/indwa" ]; then
		cp -f "$DC_tlt/indwa" ./indwa
		cp -f "$DC_tlt/indwe" ./indwe
		echo "$indw" > ./indw
	else
		echo "$indw" > ./indw
		echo "$indw" > ./indwe
	fi
	if [ -f "$DC_tlt/indsa" ]; then
		cp -f "$DC_tlt/indsa" ./indsa
		cp -f "$DC_tlt/indse" ./indse
		echo "$inds" > ./inds
	else
		echo "$inds" > ./inds
		echo "$inds" > ./indse
	fi
	if [ -f "$DC_tlt/indpa" ]; then
		cp -f "$DC_tlt/indpa" ./indpa
		cp -f "$DC_tlt/indpe" ./indpe
		echo "$indp" > ./indp
	else
		echo "$indp" > ./indp
		echo "$indp" > ./indpe
	fi
	if [ -f "$DC_tlf/indfa" ]; then
		cp -f "$DC_tlf/indfa" ./indfa
		cp -f "$DC_tlf/indfe" ./indfe
		echo "$indf" > ./indf
	else
		echo "$indf" > ./indf
		echo "$indf" > ./indfe
	fi
	
fi
if [ -z "$indw" ]; then
img1=$DS/images/addi.png
else
img1=$DS/images/add.png
fi
if [ -z "$inds" ]; then
img2=$DS/images/addi.png
else
img2=$DS/images/add.png
fi
if [ -z "$indp" ]; then
img3=$DS/images/prtci.png
else
img3=$DS/images/prtc.png
fi
if [ -z "$indf" ]; then
img4=$DS/images/srssi.png
else
img4=$DS/images/srss.png
fi
img5=$DS/images/set-26.png

if [ ! -f $DC_s/cnfg5 ]; then
	cp $DS/default/cnfg5 $DC_s/cnfg5
fi

st1=$(cat $DC_s/cnfg5 | sed -n 1p)
st2=$(cat $DC_s/cnfg5 | sed -n 2p)
st3=$(cat $DC_s/cnfg5 | sed -n 3p)
st4=$(cat $DC_s/cnfg5 | sed -n 4p)
st5=$(cat $DC_s/cnfg5 | sed -n 5p)
st6=$(cat $DC_s/cnfg5 | sed -n 6p)
st7=$(cat $DC_s/cnfg5 | sed -n 7p)
st8=$(cat $DC_s/cnfg5 | sed -n 8p)
st9=$(cat $DC_s/cnfg5 | sed -n 9p)
st10=$(cat $DC_s/cnfg5 | sed -n 10p)
slct=$(mktemp $DT/slct.XXXX)

btn1="--button=Ok:0"
btn2="--center"
if [ -f $DT/.p__$uid ]; then
	btn1="--button=Ok:0"
	btn2="--button=gtk-media-stop:2"
fi

$yad --list --on-top \
--expand-column=3 --print-all --center \
--width=190 --name=idiomind --class=idmnd \
--height=260 --title=Play --always-print-result \
--window-icon=idiomind --no-headers \
--buttons-layout=end --skip-taskbar \
--borders=0 $btn2 $btn1 --hide-column=1 \
--dclick-action='/usr/share/idiomind/play.sh d' \
--column=Action:TEXT --column=icon:IMG \
--column=Action:TEXT --column=icon:CHK \
"Words" "$img1" "$Words" $st1 \
"Sentences" "$img2" "$Sentences" $st2 \
"Practice" "$img3" "$Practice" $st3 \
"Feeds" "$img4" "$Feeds" $st4 \
"Notification" "$img5" "Notification" $st5 \
"Audio" "$img5" "Audio" $st6 \
"Repeat" "$img5" "Repeat" $st7 > "$slct"
	
ret=$?
slt=$(cat "$slct")
#=============================  continuar

if  [[ "$ret" -eq 0 ]]; then
	cd $DT/.$uid
	> ./indx
	
	#----------------------------------------------------- words
	if echo "$(echo "$slt" | sed -n 1p)" | grep TRUE; then
		sed -i "1s/.*/TRUE/" $DC_s/cnfg5
		if  [ -f ./indwa ]; then
			cat ./indwa >> ./indx
		else
			cat ./indw >> ./indx
		fi
	else
		sed -i "1s/.*/FALSE/" $DC_s/cnfg5
	fi
	#-----------------------------------------------------sentences
	if echo "$(echo "$slt" | sed -n 2p)" | grep TRUE; then
		sed -i "2s/.*/TRUE/" $DC_s/cnfg5
		if  [ -f ./indsa ]; then
			cat ./indsa >> ./indx
		else
			cat ./inds >> ./indx
		fi
	else
		sed -i "2s/.*/FALSE/" $DC_s/cnfg5
	fi
	#-----------------------------------------------------practice
	if echo "$(echo "$slt" | sed -n 3p)" | grep TRUE; then
		sed -i "3s/.*/TRUE/" $DC_s/cnfg5
		if  [ -f ./indpa ]; then
			cat ./indpa >> ./indx
		else
			cat ./indp >> ./indx
		fi
	else
		sed -i "3s/.*/FALSE/" $DC_s/cnfg5
	fi
	#-----------------------------------------------------feeds content
	if echo "$(echo "$slt" | sed -n 4p)" | grep TRUE; then
		sed -i "4s/.*/TRUE/" $DC_s/cnfg5
		if  [ -f ./indfa ]; then
			cat ./indfa >> ./indx
		else
			cat ./indf >> ./indx
		fi
	else
		sed -i "4s/.*/FALSE/" $DC_s/cnfg5
	fi
	#-----------------------------------------------------osd
	if echo "$(echo "$slt" | sed -n 5p)" | grep TRUE; then
		sed -i "5s/.*/TRUE/" $DC_s/cnfg5
	else
		sed -i "5s/.*/FALSE/" $DC_s/cnfg5
	fi
	#-----------------------------------------------------audio
	if echo "$(echo "$slt" | sed -n 6p)" | grep TRUE; then
		sed -i "6s/.*/TRUE/" $DC_s/cnfg5
	else
		sed -i "6s/.*/FALSE/" $DC_s/cnfg5
	fi
	#-----------------------------------------------------repeat
	if echo "$(echo "$slt" | sed -n 7p)" | grep TRUE; then
		sed -i "7s/.*/TRUE/" $DC_s/cnfg5
	else
		sed -i "7s/.*/FALSE/" $DC_s/cnfg5
	fi
	#-----------------------------------------------------
	
	rm -f "$slct"

#-------------------------------------stop 
elif [[ "$ret" -eq 2 ]]; then
	rm -fr $DT/.$uid $slct $DT/.p__$uid &
	$DS/stop.sh P & exit 1
	
else
	if  [ ! -f $DT/.p__$uid ]; then
		rm -fr $DT/.$uid
	fi
	rm -f $slct &
	exit 1
fi

#-----------------------------------------acondicion
rm -f $slct
$DS/stop.sh P
#-----------------------------------------condicion 

w=$(sed -n 1p $DC_s/cnfg5)
s=$(sed -n 2p $DC_s/cnfg5)
p=$(sed -n 3p $DC_s/cnfg5)
f=$(sed -n 4p $DC_s/cnfg5)

if [ -z "$(echo "$w""$s""$f""$p" | grep -o "TRUE")" ]; then
	notify-send "Error " "No Hay Nada \
	Indicado para Reproduccir" -i info -t 2000 &&
	sleep 5
	$DS/stop.sh
fi

if [[ "$(cat ./indx | wc -l)" -lt 1 ]]; then
	notify-send -i info "nada para reproducir" -t 9000 &
	rm -f $DT/.p__$uid &
	$DS/stop.sh S & exit
fi

echo "$(date '+%Y %m %d %l %M') -plyrt $tpc -plyrt" >> \
$DC/addons/stats/.log &

$DS/bcle.sh & exit 1
