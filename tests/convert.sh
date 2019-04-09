#!/bin/bash

ConvertFolder()
{
    find "$1" -type d -print0 | 
    while IFS= read -r -d '' folder; do
        if [ ! -d "${folder//$1/$2}" ]; then
            echo "Folder ${folder//$1/$2} doesn't exist. Creating..."
            mkdir "${folder//$1/$2}"
        fi
    done

    find "$1" -type f -name '*.*' -print0 | 
    while IFS= read -r -d '' file; do
        if [ "${file: -4}" == ".mp3" ] || [ "${file: -4}" == ".wav" ] || [ "${file: -4}" == ".m4a" ] || [ "${file: -4}" == ".aac" ] || [ "${file: -5}" == ".flac" ] || [ "${file: -4}" == ".ogg" ]
        then
            newFile="${file//$1/$2}"
            
            ffmpeg -i "$file" -acodec libopus -b:a 96000 "${newFile%.*}.opus" < /dev/null
            
            mv "${newFile%.*}.opus" "${newFile%.*}.ogg"
            
        elif [ "${file##*/}" == "cover.jpg" ] || [ "${file##*/}" == "cover.png" ] || [ "${file##*/}" == "cover.jpeg" ]; then
            cp "$file" "${file//$1/$2}"
            echo "Copied an image file to the new folder"
        fi
    done

    find "$2" -type d -print0 | 
    while IFS= read -r -d '' folder; do
        if [ -z "$(ls -A "$folder")" ]; then
            echo "Removed an empty folder."
            rm -R "$folder"
        fi
    done
}

FixName()
{
	find "$1" -type f -name '*.*' -print0 | 
	while IFS= read -r -d '' file; do
		if [ "${file: -4}" == ".mp3" ] || [ "${file: -4}" == ".wav" ] || [ "${file: -4}" == ".m4a" ] || [ "${file: -4}" == ".aac" ] || [ "${file: -5}" == ".flac" ] || [ "${file: -4}" == ".ogg" ] || [ "${file: -5}" == ".opus" ]; then
            filename="${file##*/}"
            titlename="$(exiftool -Title "$file")"
            titlename="${titlename:34}"
            tracknumber="$(exiftool -Track "$file")"
            #if [[ "$tracknumber" == "" ]]; then
                #tracknumber="$(exiftool -TrackNumber "$file")"
            #fi
            tracknumber="${tracknumber%%/*}"
            tracknumber="${tracknumber:34}. "
            if [[ "${#tracknumber}" < 4 ]]; then tracknumber="0${tracknumber}"; fi
            
            titlename=$(echo "$titlename" | sed 's/>//g' | sed 's/<//g' | sed 's/?//g' | sed 's/:/-/g' | sed 's/\\/ /g')
            #titlename="${titlename//\\/ }"
            titlename="${titlename//\//\ }"
            
            if [[ $filename != *$titlename* ]]; then
                fixedname="$tracknumber$titlename.${filename##*.}"
                echo "$fixedname"
                #mv "$file" "${file%%/*}
            fi
        fi
	done
}

printf "%s\n" " -------------------------------------------" "|                                           |" "|         Script bash convertisseur         |" "|                                           |" " -------------------------------------------" "(1) To Convert a Folder        (2) To Fix Broken Names" "" "" "" ""

read -r -p "Choix : " choix

case $choix in
1)
    (( i=1 ))
    
    for folder in $(echo */); do
        tab[$i]="${folder%/}"
        (( i+=1 ))
    done
    
    echo "${tab[@]}"
    
    read -r -p "Original Folder (1-${#tab[@]}) : " ori
    
    read -r -p "Converted Folder : " conv
    ConvertFolder "${tab[$ori]}" "$conv"
    ;;
2)
    (( i=1 ))
    
    for folder in $(echo */); do
        tab[$i]="${folder%/}"
        (( i+=1 ))
    done
    
    echo "${tab[@]}"
    
    read -r -p "Folder (1-${#tab[@]}) : " ori

    FixName "${tab[$ori]}"
    ;;
*)
    echo "You gotta choose between 1 and 2, pls."
    ;;
esac
