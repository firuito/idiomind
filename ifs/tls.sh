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
[ -z "$DM" ] && source /usr/share/idiomind/ifs/c.conf
source "$DS/ifs/mods/cmns.sh"
lgt=$(lnglss "$lgtl")
lgs=$(lnglss "$lgsl")

check_source_1() {

CATEGORIES="others
comics
culture
family
entertainment
grammar
history
documentary
in_the_city
movies
internet
music
nature
news
office
relations
sport
social_networks
shopping
technology
travel
article
science
interview
funny"

LANGUAGES="English
Chinese
French
German
Italian
Japanese
Portuguese
Russian
Spanish
Vietnamese"

    dir="${2}"
    file="${dir}/conf/id"
    nu='^[0-9]+$'
    dirs="$(find "${dir}"/ -maxdepth 5 -type d | sed '/^$/d' | wc -l)"
    name="$(sed -n 1p "${file}" | grep -o 'name="[^"]*' | grep -o '[^"]*$')"
    language_source=$(sed -n 2p "${file}" | grep -o 'language_source="[^"]*' | grep -o '[^"]*$')
    language_target=$(sed -n 3p "${file}" | grep -o 'language_target="[^"]*' | grep -o '[^"]*$')
    author="$(sed -n 4p "${file}" | grep -o 'author="[^"]*' | grep -o '[^"]*$')"
    contact=$(sed -n 5p "${file}" | grep -o 'contact="[^"]*' | grep -o '[^"]*$')
    category=$(sed -n 6p "${file}" | grep -o 'category="[^"]*' | grep -o '[^"]*$')
    link=$(sed -n 7p "${file}" | grep -o 'link="[^"]*' | grep -o '[^"]*$')
    date_c=$(sed -n 8p "${file}" | grep -o 'date_c="[^"]*' | grep -o '[^"]*$' | tr -d '-')
    date_u=$(sed -n 9p "${file}" | grep -o 'date_u="[^"]*' | grep -o '[^"]*$' | tr -d '-')
    nwords=$(sed -n 10p "${file}" | grep -o 'nwords="[^"]*' | grep -o '[^"]*$')
    nsentences=$(sed -n 11p "${file}" | grep -o 'nsentences="[^"]*' | grep -o '[^"]*$')
    nimages=$(sed -n 12p "${file}" | grep -o 'nimages="[^"]*' | grep -o '[^"]*$')
    level=$(sed -n 13p "${file}" | grep -o 'level="[^"]*' | grep -o '[^"]*$')

    if [ "${name}" != "${3}" ] || [ "${#name}" -gt 60 ] || \
    [ `grep -o -E '\*|\/|\@|$|\)|\(|=|-' <<<"${name}"` ]; then
    msg "1. $(gettext "File is corrupted.")\n" error & exit 1
    elif ! grep -Fox "${language_source}" <<<"${LANGUAGES}"; then
    msg "2. $(gettext "File is corrupted.")\n" error && exit 1
    elif ! grep -Fox "${language_target}" <<<"${LANGUAGES}"; then
    msg "3. $(gettext "File is corrupted.")\n" error & exit 1
    elif [ "${#author}" -gt 20 ] || \
    [ `grep -o -E '\.|\*|\/|\@|$|\)|\(|=|-' <<<"${author}"` ]; then
    msg "4. $(gettext "File is corrupted.")\n" error & exit 1
    elif [ "${#contact}" -gt 30 ] || \
    [ `grep -o -E '\*|\/|$|\)|\(|=' <<<"${contact}"` ]; then
    msg "5. $(gettext "File is corrupted.")\n" error & exit 1
    elif ! grep -Fox "${category}" <<<"${CATEGORIES}"; then
    msg "6. $(gettext "Unknown category.")\n" error & exit 1
    elif ! [[ 1 =~ $nu ]] || [ "${#link}" -gt 4 ]; then
    msg "7. $(gettext "File is corrupted.")\n" error & exit 1
    elif ! [[ $date_c =~ $nu ]] || [ "${#date_c}" -gt 12 ] && \
    [ -n "${date_c}" ]; then
    msg "8. $(gettext "File is corrupted.")\n" error & exit 1
    elif ! [[ $date_u =~ $nu ]] || [ "${#date_u}" -gt 12 ] && \
    [ -n "${date_u}" ]; then
    msg "9. $(gettext "File is corrupted.")\n" error & exit 1
    elif ! [[ $nwords =~ $nu ]] || [ "${nwords}" -gt 200 ]; then
    msg "10. $(gettext "File is corrupted.")\n" error & exit 1
    elif ! [[ $nsentences =~ $nu ]] || [ "${nsentences}" -gt 200 ]; then
    msg "11. $(gettext "File is corrupted.")\n" error & exit 1
    elif ! [[ $nimages =~ $nu ]] || [ "${nimages}" -gt 200 ]; then
    msg "12. $(gettext "File is corrupted.")\n" error & exit 1
    elif ! [[ $level =~ $nu ]] || [ "${#level}" -gt 2 ]; then
    msg "13. $(gettext "Incorrect value of \"Learning difficulty\".")\n" error & exit 1
    elif grep "invalid" <<<"$chckf"; then
    msg "14. $(gettext "File is corrupted.")\n" error & exit 1
    elif [[ $dirs -gt 6 ]] ; then
    msg "15. $(gettext "File is corrupted.")\n" error & exit 1
    else
    head -n14 < "${file}" > "$DT/$name.cfg"
    fi
}

details() {
    
    cd "$2"
    dirs="$(find . -maxdepth 5 -type d)"
    files="$(find . -type f -exec file {} \; 2> /dev/null)"
    hfiles="$(ls -d ./.[^.]* | less)"
    exfiles="$(find . -maxdepth 5 -perm -111 -type f)"
    attchsdir="$(cd "./files/"; find . -maxdepth 5 -type f)"
    wcdirs=`sed '/^$/d' <<<"${dirs}" | wc -l`
    wcfiles=`sed '/^$/d' <<<"${files}" | wc -l`
    wchfiles=`sed '/^$/d' <<<"${hfiles}" | wc -l`
    wcexfiles=`sed '/^$/d' <<<"${exfiles}" | wc -l`
    others=$((wchfiles+wcexfiles))
    SRFL1=$(cat "./conf/id")
    SRFL2=$(cat "./conf/info")
    SRFL3=$(cat "./conf/4.cfg")
    SRFL4=$(cat "./conf/3.cfg")
    SRFL5=$(cat "./conf/0.cfg")
    

    echo -e "
$(gettext "SUMMARY")

Directories: $wcdirs
Files: $wcfiles
Others files: $others


$(gettext "FILES")

$files

./files

$attchsdir

$hfiles

$exfiles

$(gettext "TEXT FILES")


$SRFL1

$SRFL2

$SRFL3

$SRFL4

$SRFL5" | yad --text-info --title="$(gettext "Installation details")" \
    --name=Idiomind --class=Idiomind \
    --window-icon="$DS/images/icon.png" --center \
    --buttons-layout=edge --scroll --margins=10 \
    --width=600 --height=550 --borders=0 \
    --button="$(gettext "Open Folder")":"xdg-open '$2'" \
    --button="$(gettext "Close")":0
} >/dev/null 2>&1

check_index() {

    source /usr/share/idiomind/ifs/c.conf
    DC_tlt="$DM_tl/${2}/.conf"
    DM_tlt="$DM_tl/${2}"
    
    check() {
        
        if [ ! -d "${DC_tlt}" ]; then mkdir "${DC_tlt}"; fi
        n=0
        while [[ $n -le 5 ]]; do
            [ ! -f "${DC_tlt}/$n.cfg" ] && touch "${DC_tlt}/$n.cfg"
            if grep '^$' "${DC_tlt}/$n.cfg"; then
            sed -i '/^$/d' "${DC_tlt}/$n.cfg"; fi
            check_index1 "${DC_tlt}/$n.cfg"
            chk=$(wc -l < "${DC_tlt}/$n.cfg")
            [ -z "$chk" ] && chk=0
            eval chk$n="$chk"
            ((n=n+1))
        done
        
        if [[ `wc -l < "${DC_tlt}/5.cfg"` -lt 1 ]]; then
        cp "${DC_tlt}/1.cfg" "${DC_tlt}/5.cfg"; fi
        if [[ ! -f "${DC_tlt}/8.cfg" ]]; then
        echo 1 > "${DC_tlt}/8.cfg"; fi
        eval stts=$(sed -n 1p "${DC_tlt}/8.cfg")
    }
    
    fix() {
        
       rm "$DC_tlt/0.cfg" "$DC_tlt/1.cfg" "$DC_tlt/2.cfg" \
       "$DC_tlt/3.cfg" "$DC_tlt/4.cfg"
       
       while read name; do
        
            md5sum="$(nmfile "$name")"

            if [ -f "$DM_tlt/$name.mp3" ]; then
                tgs="$(eyeD3 "$DM_tlt/$name.mp3")"
                trgt="$(echo "$tgs" | grep -o -P '(?<=ISI1I0I).*(?=ISI1I0I)')"
                [ -z "$trgt" ] && rm "$DM_tlt/$name.mp3" && continue
                md5sum_2="$(echo -n "$trgt" | md5sum | rev | cut -c 4- | rev)"
                [ "$name" != "$md5sum_2" ] && \
                mv -f "$DM_tlt/$name.mp3" "$DM_tlt/$md5sum_2.mp3"
                echo "$trgt" >> "$DC_tlt/0.cfg.tmp"
                echo "$trgt" >> "$DC_tlt/4.cfg.tmp"
                
            elif [ -f "$DM_tlt/$md5sum.mp3" ]; then
                tgs=$(eyeD3 "$DM_tlt/$md5sum.mp3")
                trgt=$(echo "$tgs" | grep -o -P '(?<=ISI1I0I).*(?=ISI1I0I)')
                [ -z "$trgt" ] && rm "$DM_tlt/$md5sum.mp3" && continue
                md5sum_2="$(echo -n "$trgt" | md5sum | rev | cut -c 4- | rev)"
                [ "$md5sum" != "$md5sum_2" ] && \
                mv -f "$DM_tlt/$md5sum.mp3" "$DM_tlt/$md5sum_2.mp3"
                echo "$trgt" >> "$DC_tlt/0.cfg.tmp"
                echo "$trgt" >> "$DC_tlt/4.cfg.tmp"
                
            elif [ -f "$DM_tlt/words/$name.mp3" ]; then
                tgs="$(eyeD3 "$DM_tlt/words/$name.mp3")"
                trgt="$(echo "$tgs" | grep -o -P '(?<=IWI1I0I).*(?=IWI1I0I)')"
                [ -z "$trgt" ] && rm "$DM_tlt/words/$name.mp3" && continue
                md5sum_2="$(echo -n "$trgt" | md5sum | rev | cut -c 4- | rev)"
                [ "$name" != "$md5sum_2" ] && \
                mv -f "$DM_tlt/words/$name.mp3" "$DM_tlt/words/$md5sum_2.mp3"
                echo "$trgt" >> "$DC_tlt/0.cfg.tmp"
                echo "$trgt" >> "$DC_tlt/3.cfg.tmp"
                
            elif [ -f "$DM_tlt/words/$md5sum.mp3" ]; then
                tgs="$(eyeD3 "$DM_tlt/words/$md5sum.mp3")"
                trgt="$(echo "$tgs" | grep -o -P '(?<=IWI1I0I).*(?=IWI1I0I)')"
                [ -z "$trgt" ] && rm "$DM_tlt/words/$md5sum.mp3" && continue
                md5sum_2="$(echo -n "$trgt" | md5sum | rev | cut -c 4- | rev)"
                [ "$md5sum" != "$md5sum_2" ] \
                && mv -f "$DM_tlt/words/$md5sum.mp3" "$DM_tlt/words/$md5sum_2.mp3"
                echo "$trgt" >> "$DC_tlt/0.cfg.tmp"
                echo "$trgt" >> "$DC_tlt/3.cfg.tmp"
            fi
        done < "$index"

        [ -f "$DC_tlt/0.cfg.tmp" ] && mv -f "$DC_tlt/0.cfg.tmp" "$DC_tlt/0.cfg"
        [ -f "$DC_tlt/3.cfg.tmp" ] && mv -f "$DC_tlt/3.cfg.tmp" "$DC_tlt/3.cfg"
        [ -f "$DC_tlt/4.cfg.tmp" ] && mv -f "$DC_tlt/4.cfg.tmp" "$DC_tlt/4.cfg"
        if [ ! -f "$DC_tlt/7.cfg" ]; then
        cp -f "$DC_tlt/0.cfg" "$DC_tlt/1.cfg"; else
        cp -f "$DC_tlt/0.cfg" "$DC_tlt/2.cfg"; fi
        cp -f "$DC_tlt/0.cfg" "$DC_tlt/.11.cfg"
        rm -r "$DC_tlt/practice"
        check_index1 "$DC_tlt/0.cfg" "$DC_tlt/1.cfg" \
        "$DC_tlt/2.cfg" "$DC_tlt/3.cfg" "$DC_tlt/4.cfg"
        
        if [ $? -ne 0 ]; then
        [ -f "$DT/ps_lk" ] && rm -f "$DT/ps_lk"
        msg "$(gettext "File not found")\n" error & exit 1; fi
        
        if [ "$stts" = 13 ]; then
            if [ -f "$DC_tlt/8.cfg_" ] && \
            [ -n $(< "$DC_tlt/8.cfg_") ]; then
            stts=$(sed -n 1p "$DC_tlt/8.cfg_")
            rm "$DC_tlt/8.cfg_"
            else stts=1; fi
            echo "$stts" > "$DC_tlt/8.cfg"
        fi
    }
    
    namefiles() {
        
        cd "$DM_tlt/words/"
        for i in *.mp3 ; do [ ! -s ${i} ] && rm ${i} ; done
        find -name "* *" -type f | rename 's/ /_/g'
        if [ -f ".mp3" ]; then rm ".mp3"; fi
        cd "$DM_tlt/"
        for i in *.mp3 ; do [[ ! -s ${i} ]] && rm ${i} ; done
        find -name "* *" -type f | rename 's/ /_/g'
        if [ -f ".mp3" ]; then rm ".mp3"; fi
        cd "$DM_tlt/"; find . -maxdepth 2 -name '*.mp3' \
        | sort -k 1n,1 -k 7 | sed s'|\.\/words\/||'g \
        | sed s'|\.\/||'g | sed s'|\.mp3||'g > "$DT/index"
    }
        
    check

    if [ $((chk3+chk4)) != $chk0 ] || [ $((chk1+chk2)) != $chk0 ] \
    || [ $stts = 13 ]; then
    
        (sleep 1
        notify-send -i idiomind "$(gettext "Index Error")" "$(gettext "Fixing...")" -t 3000) &
        > "$DT/ps_lk"
        [ ! -d "$DM_tlt/.conf" ] && mkdir "$DM_tlt/.conf"
        DC_tlt="$DM_tlt/.conf"

        [ "$DC_tlt/.11.cfg" ] && sed -i '/^$/d' "$DC_tlt/.11.cfg"
        if [ "$DC_tlt/.11.cfg" ] && [ -s "$DC_tlt/.11.cfg" ]; then
        index="$DC_tlt/.11.cfg"
        else 
        namefiles
        index="$DT/index"; fi
        
        fix

    n=0
    while [[ $n -le 4 ]]; do
        touch "$DC_tlt/$n.cfg"
        ((n=n+1))
    done
    rm -f "$DT/index"
    "$DS/mngr.sh" mkmn
    fi
    
    exit
}

add_audio() {

    cd "$HOME"
    AU=$(yad --file --title="$(gettext "Add Audio")" \
    --text=" $(gettext "Browse to and select the audio file that you want to add.")" \
    --class=Idiomind --name=Idiomind \
    --file-filter="*.mp3" \
    --window-icon="$DS/images/icon.png" --center --on-top \
    --width=620 --height=500 --borders=5 \
    --button="$(gettext "Cancel")":1 \
    --button="$(gettext "OK")":0)

    ret=$?
    audio=$(cut -d "|" -f1 <<<"$AU")

    DT="$2"; cd "$DT"
    if [[ $ret -eq 0 ]]; then
    
        if [ -f "$audio" ]; then
        cp -f "$audio" "$DT/audtm.mp3"
        #eyeD3 -P itunes-podcast --remove $DT/audtm.mp3
        eyeD3 --remove-all "$DT/audtm.mp3" & exit
        fi
    fi
} >/dev/null 2>&1

edit_audio() {

    cmd="$(sed -n 16p $DC_s/1.cfg)"
    (cd "$3"; "$cmd" "$2") & exit
}

text() {

    yad --form --title="$(gettext "Info")" \
    --name=Idiomind --class=Idiomind \
    --window-icon="$DS/images/icon.png" \
    --scroll --fixed --center --on-top \
    --width=300 --height=250 --borders=5 \
    --field="$(< "$2")":lbl \
    --button="$(gettext "Close")":0
} >/dev/null 2>&1

add_file() {

    cd "$HOME"
    FL=$(yad --file --title="$(gettext "Add File")" \
    --text=" $(gettext "Browse to and select the file that you want to add.")" \
    --name=Idiomind --class=Idiomind \
    --file-filter="*.mp3 *.ogg *.mp4 *.m4v *.jpg *.jpeg *.png *.txt *.pdf *.gif" \
    --add-preview --multiple \
    --window-icon="$DS/images/icon.png" --on-top --center \
    --width=680 --height=500 --borders=5 \
    --button="$(gettext "Cancel")":1 \
    --button="$(gettext "OK")":0)
    ret=$?

    if [[ $ret -eq 0 ]]; then
    
        while read -r file; do
        [ -f "$file" ] && cp -f "$file" \
        "$DM_tlt/files/$(basename "$file" |iconv -c -f utf8 -t ascii)"
        done <<<"$(tr '|' '\n' <<<"$FL")"
    fi
    
} >/dev/null

videourl() {

    n=$(ls *.url "$DM_tlt/files/" | wc -l)
    url=$(yad --form --title=" " \
    --name=Idiomind --class=Idiomind \
    --separator="" \
    --window-icon="$DS/images/icon.png" \
    --skip-taskbar --center --on-top \
    --width=420 --height=100 --borders=5 \
    --field="$(gettext "URL")" \
    --button="$(gettext "Cancel")":1 \
    --button=gtk-ok:0)
    [ $? = 1 ] && exit
    if [ ${#url} -gt 40 ] && \
    ([ ${url:0:29} = 'https://www.youtube.com/watch' ] \
    || [ ${url:0:28} = 'http://www.youtube.com/watch' ]); then \
    echo "$url" > "$DM_tlt/files/video$n.url"
    else msg "$(gettext "Invalid URL.")\n" error \
    "$(gettext "Invalid URL")"; fi
}

attatchments() {

    mkindex() {

rename 's/_/ /g' "$DM_tlt/files"/*
echo "<meta http-equiv=\"Content-Type\" \
content=\"text/html; charset=UTF-8\" />
<link rel=\"stylesheet\" \
href=\"/usr/share/idiomind/default/attch.css\">\
<body>" > "$DC_tlt/att.html"

while read -r file; do
if grep ".mp3" <<<"${file: -4}"; then
echo "${file::-4}<br><br><audio controls>
<source src=\"../files/$file\" type=\"audio/mpeg\">
</audio><br><br>" >> "$DC_tlt/att.html"
elif grep ".ogg" <<<"${file: -4}"; then
echo "${file::-4}<audio controls>
<source src=\"../files/$file\" type=\"audio/mpeg\">
</audio><br><br>" >> "$DC_tlt/att.html"; fi
done <<<"$(ls "$DM_tlt/files")"

while read -r file; do
if grep ".txt" <<<"${file: -4}"; then
txto=$(sed ':a;N;$!ba;s/\n/<br>/g' \
< "$DM_tlt/files/$file" \
| sed 's/\"/\&quot;/;s/\&/&amp;/g')
echo "<div class=\"summary\">
<h2>${file::-4}</h2><br>$txto \
<br><br><br></div>" >> "$DC_tlt/att.html"; fi
done <<<"$(ls "$DM_tlt/files")"

while read -r file; do
if grep ".mp4" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<video width=450 height=280 controls>
<source src=\"../files/$file\" type=\"video/mp4\">
</video><br><br><br>" >> "$DC_tlt/att.html"
elif grep ".m4v" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<video width=450 height=280 controls>
<source src=\"../files/$file\" type=\"video/mp4\">
</video><br><br><br>" >> "$DC_tlt/att.html"
elif grep ".jpg" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<img src=\"../files/$file\" alt=\"$name\" \
style=\"width:100%;height:100%\"><br><br><br>" \
>> "$DC_tlt/att.html"
elif grep ".jpeg" <<<"${file: -5}"; then
echo "${file::-5}<br><br>
<img src=\"../files/$file\" alt=\"$name\" \
style=\"width:100%;height:100%\"><br><br><br>" \
>> "$DC_tlt/att.html"
elif grep ".png" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<img src=\"../files/$file\" alt=\"$name\" \
style=\"width:100%;height:100%\"><br><br><br>" \
>> "$DC_tlt/att.html"
elif grep ".url" <<<"${file: -4}"; then
url=$(tr -d '=' < "$DM_tlt/files/$file" \
| sed 's|watch?v|v\/|;s|https|http|g')
echo "<iframe width=\"100%\" height=\"85%\" src=\"$url\" \
frameborder=\"0\" allowfullscreen></iframe>
<br><br>" >> "$DC_tlt/att.html"
elif grep ".gif" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<img src=\"../files/$file\" alt=\"$name\" \
style=\"width:100%;height:100%\"><br><br><br>" \
>> "$DC_tlt/att.html"; fi
done <<<"$(ls "$DM_tlt/files")"

echo "</body>" >> "$DC_tlt/att.html"
    
    } >/dev/null 2>&1
    
    [ ! -d "$DM_tlt/files" ] && mkdir "$DM_tlt/files"
    ch1="$(ls -A "$DM_tlt/files")"
    
    if [ "$(ls -A "$DM_tlt/files")" ]; then
        [ ! -f "$DC_tlt/att.html" ] && mkindex >/dev/null 2>&1
        yad --html --title="$(gettext "Attached Files")" \
        --name=Idiomind --class=Idiomind \
        --uri="$DC_tlt/att.html" --browser \
        --window-icon="$DS/images/icon.png" --center \
        --width=680 --height=580 --borders=10 \
        --button="$(gettext "Folder")":"xdg-open \"$DM_tlt\"/files" \
        --button="$(gettext "Video URL")":2 \
        --button="gtk-add":0 \
        --button="gtk-close":1
        ret=$?
            if [ $ret = 0 ]; then 
            "$DS/ifs/tls.sh" add_file
            elif [ $ret = 2 ]; then
            "$DS/ifs/tls.sh" videourl
            fi
            if [ "$ch1" != "$(ls -A "$DM_tlt/files")" ]; then
            mkindex; fi
        
    else
        yad --form --title="$(gettext "Attached Files")" \
        --text="  $(gettext "Save files related to topic")" \
        --name=Idiomind --class=Idiomind \
        --window-icon="$DS/images/icon.png" --center \
        --width=350 --height=180 --borders=5 \
        --field="$(gettext "Add File")":FBTN "$DS/ifs/tls.sh 'add_file'" \
        --field="$(gettext "YouTube Video URL")":FBTN "$DS/ifs/tls.sh 'videourl'" \
        --button="$(gettext "Cancel")":1 \
        --button="$(gettext "OK")":0
        ret=$?
        if [ "$ch1" != "$(ls -A "$DM_tlt/files")" ] && [ $ret = 0 ]; then
            mkindex
        fi
    fi
} >/dev/null 2>&1

help() {

    URL="http://idiomind.sourceforge.net/doc/$(gettext "help").pdf"
    xdg-open "$URL"
     
} >/dev/null 2>&1
    
definition() {

    URL="http://glosbe.com/$lgt/$lgs/${2,,}"
    xdg-open "$URL"
}

web() {

    web="http://idiomind.sourceforge.net"
    xdg-open "$web/$lgs/${lgtl,,}" >/dev/null 2>&1
}

fback() {
    
    internet
    URL="http://idiomind.sourceforge.net/doc/msg.html"
    yad --html --title="$(gettext "Feedback")" \
    --name=Idiomind --class=Idiomind \
    --browser --uri="$URL" \
    --window-icon="$DS/images/icon.png" \
    --no-buttons --fixed \
    --width=500 --height=450
     
} >/dev/null 2>&1

check_updates() {

    internet
    nver=`curl http://idiomind.sourceforge.net/doc/release | sed -n 1p`
    cver=`echo "$(idiomind -v)"`
    pkg='https://sourceforge.net/projects/idiomind/files/idiomind.deb/download'
    echo "$(date +%d)" > "$DC_s/9.cfg"
    if [ ${#nver} -lt 9 ] && [ ${#cver} -lt 9 ] \
    && [ ${#nver} -ge 3 ] && [ ${#cver} -ge 3 ] \
    && [ "$nver" != "$cver" ]; then
    
        msg_2 " <b>$(gettext "A new version of Idiomind available\!")</b>\n" \
        info "$(gettext "Download")" "$(gettext "Cancel")" $(gettext "Updates")
        ret=$(echo $?)
        
        if [[ $ret -eq 0 ]]; then
        
            xdg-open "$pkg"
        fi
        
    else
        msg " $(gettext "No updates available.")\n" info $(gettext "Updates")
    fi

    exit 0
}

a_check_updates() {

    [ ! -f "$DC_s/9.cfg" ] && echo `date +%d` > "$DC_s/9.cfg" && exit
    d1=$(< "$DC_s/9.cfg"); d2=$(date +%d)
    if [ "$(sed -n 1p "$DC_s/9.cfg")" = 28 ] && \
    [ "$(wc -l < "$DC_s/9.cfg")" -gt 1 ]; then
    rm -f "$DC_s/9.cfg"; fi
    [ "$(wc -l < "$DC_s/9.cfg")" -gt 1 ] && exit 1

    if [ "$d1" != "$d2" ]; then

        curl -v www.google.com 2>&1 | \
        grep -m1 "HTTP/1.1" >/dev/null 2>&1 || exit 1
        echo "$d2" > "$DC_s/9.cfg"
        nver=`curl http://idiomind.sourceforge.net/doc/release | sed -n 1p`
        cver=`echo "$(idiomind -v)"`
        pkg='https://sourceforge.net/projects/idiomind/files/idiomind.deb/download'
        if [ ${#nver} -lt 9 ] && [ ${#cver} -lt 9 ] \
        && [ ${#nver} -ge 3 ] && [ ${#cver} -ge 3 ] \
        && [ "$nver" != "$cver" ]; then
            
            msg_2 " <b>$(gettext "A new version of Idiomind available\!")\n</b>\n $(gettext "Do you want to download it now?")\n" info "$(gettext "Download")" "$(gettext "No")" "$(gettext "Updates")" "$(gettext "Ignore")"
            ret=$(echo $?)
            
            if [[ $ret -eq 0 ]]; then
            
            xdg-open "$pkg"
            
            elif [[ $ret -eq 2 ]]; then
            
            echo "$d2" >> "$DC_s/9.cfg"
            
            fi
        fi
    fi
    exit 0
}

about() {

#about.set_website(app_website)
#about.set_website_label(web)
c="$(gettext "Vocabulary learning tool")"
website="$(gettext "Web Site")"
export c website
python << END
import gtk
import os
app_logo = os.path.join('/usr/share/idiomind/images/idiomind.png')
app_icon = os.path.join('/usr/share/idiomind/images/icon.png')
app_name = 'Idiomind'
app_version = 'v2.2-beta'
app_comments = os.environ['c']
web = os.environ['website']
app_copyright = 'Copyright (c) 2015 Robin Palatnik'
app_website = 'http://idiomind.sourceforge.net/'
app_license = (('This program is free software: you can redistribute it and/or modify\n'+
'it under the terms of the GNU General Public License as published by\n'+
'the Free Software Foundation, either version 3 of the License, or\n'+
'(at your option) any later version.\n'+
'\n'+
'This program is distributed in the hope that it will be useful,\n'+
'but WITHOUT ANY WARRANTY; without even the implied warranty of\n'+
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n'+
'GNU General Public License for more details.\n'+
'\n'+
'You should have received a copy of the GNU General Public License\n'+
'along with this program.  If not, see <http://www.gnu.org/licenses/>.'))
app_authors = ['Robin Palatnik <patapatass@hotmail.com>']
app_artists = [' ']

class AboutDialog:
    def __init__(self):
        about = gtk.AboutDialog()
        about.set_logo(gtk.gdk.pixbuf_new_from_file(app_logo))
        about.set_icon_from_file(app_icon)
        about.set_wmclass('Idiomind', 'Idiomind')
        about.set_name(app_name)
        about.set_program_name(app_name)
        about.set_version(app_version)
        about.set_comments(app_comments)
        about.set_copyright(app_copyright)
        about.set_license(app_license)
        about.set_authors(app_authors)
        about.set_artists(app_artists)
        about.run()
        about.destroy()

if __name__ == "__main__":
    AboutDialog = AboutDialog()
    main()
END
} >/dev/null 2>&1

set_image() {

    cd "$DT"
    if [ "$3" = word ]; then
    item=$(eyeD3 "$2" | grep -o -P '(?<=IWI1I0I).*(?=IWI1I0I)')
    elif [ "$3" = sentence ]; then
    item=$(eyeD3 "$2" | grep -o -P '(?<=ISI1I0I).*(?=ISI1I0I)'); fi
    q="$(sed "s/'/ /g" <<<"$item")"
    file="$2"
    fname="$(nmfile "$item")"
    source "$DS/ifs/mods/add/add.sh"

    echo -e "<html><head>
    <meta http-equiv=\"Refresh\" content=\"0;url=https://www.google.com/search?q="$q"&tbm=isch\">
    </head><body><p>Search images for \"$q\"...</p></body></html>" > search.html
    btn1="--button="$(gettext "Image")":3"

    if [ -f "$DM_tlt/words/images/$fname.jpg" ]; then
    image="--image=$DM_tlt/words/images/$fname.jpg"
    btn1="--button="$(gettext "Change")":3"
    btn2="--button="$(gettext "Delete")":2"
    else label="--text=<small><a href='file://$DT/search.html'>"$(gettext "Search image")"</a></small>"; fi

    if [ "$3" = word ]; then

        dlg_form_3
        ret=$(echo $?)
            
            if [[ $ret -eq 3 ]]; then
            
            rm -f *.l
            scrot -s --quality 90 "$fname.temp.jpeg"
            /usr/bin/convert "$fname.temp.jpeg" -interlace Plane -thumbnail 100x90^ \
            -gravity center -extent 100x90 -quality 90% "$item"_temp.jpeg
            /usr/bin/convert "$fname.temp.jpeg" -interlace Plane -thumbnail 400x270^ \
            -gravity center -extent 400x270 -quality 90% "$DM_tlt/words/images/$fname.jpg"
            eyeD3 --remove-images "$file"
            eyeD3 --add-image "$fname"_temp.jpeg:ILLUSTRATION "$file"
            wait
            "$DS/ifs/tls.sh" set_image "$file" word & exit
                
            elif [[ $ret -eq 2 ]]; then
            
            eyeD3 --remove-image "$file"
            rm -f "$DM_tlt/words/images/$fname.jpg"
            
            fi
            
    elif [ "$3" = sentence ]; then
    
        dlg_form_3
        ret=$(echo $?)
                
            if [[ $ret -eq 3 ]]; then
            
            rm -f *.l
            scrot -s --quality 90 "$fname.temp.jpeg"
            /usr/bin/convert "$fname.temp.jpeg" -interlace Plane -thumbnail 100x90^ \
            -gravity center -extent 100x90 -quality 90% "$item"_temp.jpeg
            /usr/bin/convert "$fname.temp.jpeg" -interlace Plane -thumbnail 400x270^ \
            -gravity center -extent 400x270 -quality 90% "$DM_tlt/words/images/$fname.jpg"
            eyeD3 --remove-images "$file"
            eyeD3 --add-image "$fname"_temp.jpeg:ILLUSTRATION "$file"
            wait
            "$DS/ifs/tls.sh" set_image "$file" sentence & exit
                
            elif [[ $ret -eq 2 ]]; then
            
            eyeD3 --remove-image "$file"
            rm -f "$DM_tlt/words/images/$fname.jpg"
            
            fi
    fi
    rm -f "$DT"/*.jpeg
    (sleep 50 && rm -f "$DT/search.html") & exit
} >/dev/null 2>&1


mkpdf() {

    cd "$HOME"
    pdf=$(yad --file --save --title="$(gettext "Export to PDF")" \
    --name=Idiomind --class=Idiomind \
    --filename="$HOME/$tpc.pdf" \
    --window-icon="$DS/images/icon.png" --center --on-top \
    --width=600 --height=500 --borders=5 \
    --button="$(gettext "Cancel")":1 \
    --button="$(gettext "OK")":0)
    ret=$?

    if [ "$ret" -eq 0 ]; then
    
        dte=`date "+%d %B %Y"`
        [ -d "$DT/mkhtml" ] && rm -f "$DT/mkhtml"
        mkdir "$DT/mkhtml"
        mkdir "$DT/mkhtml/images"
        nts="$(sed ':a;N;$!ba;s/\n/<br>/g' < "$DC_tlt/10.cfg" \
        | sed 's/\&/&amp;/g')"
        if [ -f "$DM_tlt/words/images/img.jpg" ]; then
        convert "$DM_tlt/words/images/img.jpg" \
        -alpha set -channel A -evaluate set 50% \
        "$DT/mkhtml/img.png"; fi

        cd "$DT/mkhtml"
        cp -f "$DC_tlt/3.cfg" "./3.cfg"
        cp -f "$DC_tlt/4.cfg" "./4.cfg"

        n="$(wc -l < "./3.cfg" | awk '{print ($1)}')"
        while [[ $n -ge 1 ]]; do
            Word=$(sed -n "$n"p "./3.cfg")
            fname="$(nmfile "$Word")"
            if [ -f "$DM_tlt/words/images/$fname.jpg" ]; then
            convert "$DM_tlt/words/images/$fname.jpg" -alpha set -virtual-pixel transparent \
            -channel A -blur 0x10 -level 50%,100% +channel "$DT/mkhtml/images/$Word.png"
            fi
            let n--
        done

        n="$(wc -l < "./4.cfg" | awk '{print ($1)}')"
        while [[ $n -ge 1 ]]; do
            Word=$(sed -n "$n"p "./4.cfg")
            fname="$(nmfile "$Word")"
            tgs=$(eyeD3 "$DM_tlt/$fname.mp3")
            trgt=$(grep -o -P "(?<=ISI1I0I).*(?=ISI1I0I)" <<<"$tgs")
            srce=$(grep -o -P "(?<=ISI2I0I).*(?=ISI2I0I)" <<<"$tgs")
            echo "$trgt" >> trgt_sentences
            echo "$srce" >> srce_sentences
            let n--
        done
        echo -e "<head>
        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
        <title>$tpc</title><head>
        <link rel=\"stylesheet\" href=\"/usr/share/idiomind/default/pdf.css\">
        </head>
        <body>
        <div><p></p>
        </div>
        <div>" >> doc.html
        if [ -f "$DT/mkhtml/img.png" ]; then
        echo -e "<table width=\"100%\" border=\"0\">
        <tr>
        <td><img src=\"$DT/mkhtml/img.png\" alt="" border=0 height=100% width=100%></img>
        </td>
        </tr>
        </table>" >> doc.html; fi
        echo -e "<p>&nbsp;</p>
        <h3>$tpc</h3>
        <hr>
        <div width=\"80%\" align=\"left\" border=\"0\" class=\"ifont\">
        <br>" >> doc.html
        printf "$nts" >> doc.html
        echo -e "<p>&nbsp;</p>
        <div>" >> doc.html

        cd "$DM_tlt/words/images"
        cnt=`ls -1 *.jpg | grep -v "img.jpg" | wc -l`
        if [[ $cnt != 0 ]]; then
            cd "$DT/mkhtml/images/"
            ls *.png | sed 's/\.png//g' > "$DT/mkhtml/image_list"
            cd "$DT/mkhtml"
            echo -e "<p>&nbsp;</p><table width=\"100%\" align=\"center\" border=\"0\" class=\"images\">" >> doc.html
            n=1
            while [[ $n -lt $(($(wc -l < ./image_list)+1)) ]]; do
            
                    label1=$(sed -n "$n",$((n+1))p < ./image_list | sed -n 1p)
                    label2=$(sed -n "$n",$((n+1))p < ./image_list | sed -n 2p)
                    if [ -n "$label1" ]; then
                        echo -e "<tr>
                        <td align=\"center\"><img src=\"images/$label1.png\" width=\"200\" height=\"140\"></td>" >> doc.html
                        if [ -n "$label2" ]; then
                        echo -e "<td align=\"center\"><img src=\"images/$label2.png\" width=\"200\" height=\"140\"></td></tr>" >> doc.html
                        else
                        echo '</tr>' >> doc.html
                        fi
                        echo -e "<tr>
                        <td align=\"center\" valign=\"top\"><p>$label1</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p></td>" >> doc.html
                        if [ -n "$label2" ]; then
                        echo -e "<td align=\"center\" valign=\"top\"><p>$label2</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p></td>
                        </tr>" >> doc.html
                        else
                        echo '</tr>' >> doc.html
                        fi
                    else
                        break
                    fi

                ((n=n+2))
            done
            echo -e "</table>" >> doc.html
        fi

        cd "$DT/mkhtml"
        n="$(wc -l < "./3.cfg")"
        while [[ $n -ge 1 ]]; do
            Word=$(sed -n "$n"p "./3.cfg")
            fname="$(nmfile "$Word")"
            tgs=$(eyeD3 "$DM_tlt/words/$fname.mp3")
            trgt=$(grep -o -P "(?<=IWI1I0I).*(?=IWI1I0I)" <<<"$tgs")
            srce=$(grep -o -P "(?<=IWI2I0I).*(?=IWI2I0I)" <<<"$tgs")
            inf=$(grep -o -P "(?<=IWI3I0I).*(?=IWI3I0I)" <<<"$tgs" | tr '_' '\n')
            hlgt="${trgt,,}"
            exm1=$(echo "$inf" | sed -n 1p | sed 's/\\n/ /g')
            dftn=$(echo "$inf" | sed -n 2p | sed 's/\\n/ /g')
            exmp1=$(echo "$exm1" \
            | sed "s/"$hlgt"/<b>"$hlgt"<\/\b>/g")
            echo "$trgt" >> trgt_words
            echo "$srce" >> srce_words
            
            if [ -n "$trgt" ]; then
                echo -e "<table width=\"55%\" border=\"0\" align=\"left\" cellpadding=\"10\" cellspacing=\"5\">
                <tr>
                <td bgcolor=\"#E6E6E6\" class=\"side\"></td>
                <td bgcolor=\"#FFFFFF\"><w1>$trgt</w1></td>
                </tr><tr>
                <td bgcolor=\"#E6E6E6\" class=\"side\"></td>
                <td bgcolor=\"#FFFFFF\"><w2>$srce</w2></td>
                </tr>
                </table>" >> doc.html
                echo -e "<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"10\" class=\"efont\">
                <tr>
                <td width=\"10px\"></td>" >> doc.html
                if [ -z "$dftn" ] && [ -z "$exmp1" ]; then
                echo -e "<td width=\"466\" valign=\"top\" class=\"nfont\" >$ntes</td>
                <td width=\"389\"</td>
                </tr>
                </table>" >> doc.html
                else
                    echo -e "<td width=\"466\">" >> doc.html
                    if [ -n "$dftn" ]; then
                    echo -e "<dl>
                    <dd><dfn>$dftn</dfn></dd>
                    </dl>" >> doc.html
                    fi
                    if [ -n "$exmp1" ]; then
                    echo -e "<dl>
                    <dt> </dt>
                    <dd><cite>$exmp1</cite></dd>
                    </dl>" >> doc.html
                    fi 
                    echo -e "</td>
                    <td width=\"400\" valign=\"top\" class=\"nfont\">$ntes</td>
                    </tr>
                    </table>" >> doc.html
                fi
            fi
            let n--
        done

        n=1; trgt=""
        while [[ $n -le "$(wc -l < "./4.cfg")" ]]; do
        
            trgt=$(sed -n "$n"p "trgt_sentences")
            while read -r mrk; do
                if grep -Fxo ${mrk^} < "./3.cfg"; then
                trgsm=$(sed "s|$mrk|<mark>$mrk<\/mark>|g" <<<"$trgt")
                trgt="$trgsm"; fi
            done <<<"$(tr ' ' '\n' <<<"$trgt")"

            if [ -n "$trgt" ]; then
                srce=$(sed -n "$n"p "srce_sentences")
                fn=$(sed -n "$n"p "./4.cfg")
                echo -e "<h1>&nbsp;</h1>
                <table width=\"100%\" border=\"0\" align=\"left\" cellpadding=\"10\" cellspacing=\"5\">
                <tr>
                <td bgcolor=\"#E6E6E6\" class=\"side\"></td>
                <td bgcolor=\"#FFFFFF\"><h1>$trgt</h1></td>
                </tr><tr>
                <td bgcolor=\"#E6E6E6\" class=\"side\"></td>
                <td bgcolor=\"#FFFFFF\"><h2>$srce</h2></td>
                </tr>
                </table>
                <h1>&nbsp;</h1>" >> doc.html
            fi
            let n++
        done

        echo -e "<p>&nbsp;</p>
        <p>&nbsp;</p>
        <h3>&nbsp;</h3>
        <p>&nbsp;</p>
        </div>
        </div>
        <span class=\"container\"></span>
        </body>
        </html>" >> doc.html

        wkhtmltopdf -s A4 -O Portrait ./doc.html ./tmp.pdf
        mv -f ./tmp.pdf "$pdf"; rm -fr "$DT/mkhtml"
    fi
    exit
}

if [ "$1" = play ]; then

    play "$2"
    wait
    
elif [ "$1" = listen_sntnc ]; then

    play "$DM_tlt/$2.mp3" >/dev/null 2>&1
    exit

elif [ "$1" = dclik ]; then

    play "$DM_tls/${2,,}.mp3" >/dev/null 2>&1
    exit

elif [ "$1" = play_temp ]; then

    nmt=$(sed -n 1p "/tmp/.idmtp1.$USER/dir$2/folder")
    dir="/tmp/.idmtp1.$USER/dir$2/$nmt"
    play "$dir/audio/${3,,}.mp3"
    exit
fi

gtext() {
$(gettext "Marked items")
$(gettext "Difficult words")
}>/dev/null 2>&1

case "$1" in
    details)
    details "$@" ;;
    check_source_1)
    check_source_1 "$@" ;;
    check_index)
    check_index "$@" ;;
    add_audio)
    add_audio "$@" ;;
    edit_audio)
    edit_audio "$@" ;;
    text)
    text "$@" ;;
    attachs)
    attatchments "$@" ;;
    add_file)
    add_file ;;
    videourl)
    videourl "$@" ;;
    help)
    help ;;
    definition)
    definition "$@" ;;
    check_updates)
    check_updates ;;
    a_check_updates)
    a_check_updates ;;
    check_index)
    check_index "$@" ;;
    set_image)
    set_image "$@" ;;
    pdf)
    mkpdf ;;
    html)
    mkhtml ;;
    fback)
    fback ;;
    about)
    about ;;
esac
