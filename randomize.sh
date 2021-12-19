#!/bin/bash

hexlength=8 # Max length is 16
IFS=$'\n' # Avoid interpreting the spaces in file names as a separator
filepaths=($(find . -type f)) # An array containing paths to every file under ./
unset IFS
arrlength=${#filepaths[@]}
echo "Renaming ${arrlength} files under ./ to random ${hexlength}-byte hex strings..."

percentage=0 # Percentage of files already renamed, increment only by 10
for i in ${!filepaths[@]}; do # Iterate over the indexes of the array
	path=${filepaths[i]}
	extension=${path##*.}
	if [ $extension == "sh" ]; then continue; fi # Avoid renaming the script itself
	directory=${path%/*}

	newname=$(openssl rand -hex 8 | head -c ${hexlength}) # A random hex string
	newpath="$directory/$newname.$extension"
	mv "$path" "$newpath"

	if [ $i -ge $(($arrlength * ($percentage+10) / 100)) ]; then
		percentage=$(($percentage+10))
		echo "$percentage% completed..."
	fi
done

echo "Randomization completed!"