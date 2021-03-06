#!/bin/bash
# -*- ENCODING: UTF-8 -*-

[ -z "$DM" ] && source /usr/share/idiomind/ifs/c.conf
source "$DS/ifs/mods/cmns.sh"

if [ ! -f "$DC_a/user_data.cfg" ]; then
echo -e "backup=\"FALSE\"
path=\"$HOME\"
size=\"0\"
others=\" \"" > "$DC_a/user_data.cfg"
fi

path="$(sed -n 2p < "$DC_a/user_data.cfg" \
| grep -o path=\"[^\"]* | grep -o '[^"]*$')"
size="$(sed -n 3p < "$DC_a/user_data.cfg" \
| grep -o size=\"[^\"]* | grep -o '[^"]*$')"
others="$(sed -n 4p < "$DC_a/user_data.cfg" \
| grep -o others=\"[^\"]* | grep -o '[^"]*$')"

[ -f "$path/.udt" ] && udt=$(< "$path/.udt") || udt=" "
dte=$(date +%F)

if [ -z "$1" ]; then
    
    D=$(yad --list --radiolist --title="$(gettext "User Data")" \
    --name=Idiomind --class=Idiomind \
    --text="$(gettext "Total size:") $size" \
    --always-print-result --print-all --separator=" " \
    --window-icon="$DS/images/icon.png" \
    --center --on-top --expand-column=2 --image-on-top \
    --skip-taskbar --image=folder \
    --width=480 --height=330 --borders=15 \
    --button="$(gettext "Cancel")":1 \
    --button=Ok:0 \
    --column="" \
    --column=Options \
    "FALSE" "$(gettext "Import")" "FALSE" "$(gettext "Export")")
    
    ret=$?

    if [[ $ret -eq 0 ]]; then

        in=$(sed -n 1p <<<"$D")
        ex=$(sed -n 2p <<<"$D")
        
        # export
        if grep "TRUE $(gettext "Export")" <<<"$ex"; then
        
            set -e
            IFS=$'\n\t'
            
            cd "$HOME"
            exp=$(yad --file --save --title="$(gettext "Export")" \
            --filename="idiomind_data.tar.gz" \
            --window-icon="$DS/images/icon.png" \
            --skip-taskbar --center --on-top \
            --width=600 --height=500 --borders=10 \
            --button="$(gettext "Cancel")":1 \
            --button=Ok:0)
            ret=$?
                
            if [[ $ret -eq 0 ]]; then
                
                (
                echo "# $(gettext "Copying")..."

                cd "$DM"
                # TODO
                tar cvzf "$DT/backup.tar.gz" \
                --exclude='./topics/Italian/Podcasts' \
                --exclude='./topics/French/Podcasts' \
                --exclude='./topics/Portuguese/Podcasts' \
                --exclude='./topics/Russian/Podcasts' \
                --exclude='./topics/Spanish/Podcasts' \
                --exclude='./topics/German/Podcasts' \
                --exclude='./topics/Chinese/Podcasts' \
                --exclude='./topics/Japanese/Podcasts' \
                --exclude='./topics/Vietnamese/Podcasts' \
                ./topics

                mv -f "$DT/backup.tar.gz" "$DT/idiomind_data.tar.gz"
                mv -f "$DT/idiomind_data.tar.gz" "$exp"
                echo "# $(gettext "Completing")" ; sleep 1

                ) | yad --progress --title="$(gettext "Copying")" \
                --window-icon="$DS/images/icon.png" \
                --pulsate --percentage="5" --auto-close \
                --skip-taskbar --no-buttons --on-top --fixed \
                --width=200 --height=50 --borders=4 --geometry=200x20-2-2
                
                if [ -f "$exp" ]; then
                msg "$(gettext "Data exported successfully.")\n" info; else
                [ -f "$DT/backup.tar.gz" ] && rm -f "$DT/backup.tar.gz"
                msg "$(gettext "An error occurred while copying files.")\n" error; fi
            fi
            
        # import
        elif grep "TRUE $(gettext "Import")" <<<"$in"; then
            
            set -e
            set u pipefail
            cd "$HOME"
            add=$(yad --file --title="$(gettext "Import")" \
            --file-filter="*.gz" \
            --window-icon="$DS/images/icon.png" \
            --skip-taskbar --center --on-top \
            --width=600 --height=500 --borders=10 \
            --button="$(gettext "Cancel")":1 \
            --button=Ok:0)
            
            if [[ $ret -eq 0 ]]; then
            
                if [ -z "$add" ] || [ ! -d "$DM" ]; then
                    exit 1
                fi
                
                (
                [ -d "$DT/import" ] && rm -fr "$DT/import"
                rm -f "$DT/*.XXXXXXXX"
              
                echo "# $(gettext "Copying")..."
                mkdir "$DT/import"
                cp -f "$add" "$DT/import/import.tar.gz"
                cd "$DT/import"
                tar -xzvf import.tar.gz
                cd "$DT/import/topics/"
                list="$(ls * -d | sed 's/saved//g' | sed '/^$/d')"

                while read -r lng; do
                
                    if [ ! -d "$DM_t/$lng" ]; then
                    mkdir "$DM_t/$lng"; fi
                    if [ ! -d "$DM_t/$lng/.share" ]; then
                    mkdir "$DM_t/$lng/.share"; fi
                    if [ "$(ls -A "./$lng/.share")" ]; then
                    mv -f "./$lng/.share"/* "$DM_t/$lng/.share"/
                    fi
                    
                    echo "$lng" >> ./.languages
                    
                done <<<"$list"

                while read language; do

                    if [ -d "$DT/import/topics/$language/" ] &&  \
                    [ "$(ls -A "$DT/import/topics/$language/")" ] ; then
                    cd "$DT/import/topics/$language/"; else continue; fi
                    
                    ls * -d | sed 's/Podcasts//g' | sed '/^$/d' > \
                    "$DT/import/topics/$language/.topics"
                    
                    while read topic; do
                        
                        if [ -d "$DM_t/$language/$topic" ]; then continue; fi
                        if [ -d "$DT/import/topics/$language/$topic" ]; then
                        cp -fr "$DT/import/topics/$language/$topic" "$DM_t/$language/$topic"
                        else continue; fi
                        if [ ! -d "$DM_t/$language/$topic/.conf" ]; then
                        mkdir "$DM_t/$language/$topic/.conf"; fi
                        if [ ! -f "$DM_t/$language/$topic/.conf/8.cfg" ]; then
                        echo 1 > "$DM_t/$language/$topic/.conf/8.cfg"; fi
                        if [ -d "$DT/import/topics/$language/$topic" ]; then
                        echo "$topic" >> "$DM_t/$language/.3.cfg"; fi
                        cd "$DT/import/topics"

                    done < "$DT/import/topics/$language/.topics"
                    
                    if [ -d "$DT/import/topics/$language/Podcasts" ]; then
                    cp -r "$DT/import/topics/$language/Podcasts" "$DM_t/$language/Podcasts"; fi
                
                done < "$DT/import/topics/.languages"

                ) | yad --progress --title="$(gettext "Copying")" \
                --window-icon="$DS/images/icon.png" \
                --pulsate --percentage="5" --auto-close \
                --skip-taskbar --no-buttons --on-top --fixed \
                --width=200 --height=50 --borders=4 --geometry=200x20-2-2
                "$DS/mngr.sh" mkmn; rm -fr "$DT/import"
                msg "$(gettext "Data imported successfully.")\n" info
            fi
    
        fi
    fi
fi
exit
