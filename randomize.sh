#!/bin/bash

hexlength=8 # Max length is 16
IFS=$'\n' # Avoid interpreting the spaces in file names as a separator
filepaths=($(find . -type f)) # An array containing paths to every file under the current directory
unset IFS
arrlength=${#filepaths[@]}

read -p "You are about to rename $(($arrlength-1)) files under the current directory to random $hexlength-byte hex strings. Proceed? (Y/N) "
# Execute the script only when the user replies with Y or y
if [ ! \( "$REPLY" = "Y" -o "$REPLY" = "y" \) ]; then exit 1; fi
echo "Renaming in progress..."

# Percentage of files already renamed, increment only by 10.
# This is only relevant when there are >= 50 files;
# otherwise, progress is not displayed.
percentage=0
for i in ${!filepaths[@]}; do # Iterate over the indexes of the array
	path=${filepaths[i]}
	extension=${path##*.}
	if [ $extension == "sh" ]; then continue; fi # Avoid renaming the script itself
	directory=${path%/*}

	# A random hex string
	newname=$(openssl rand -hex 8 | head -c ${hexlength})
	newpath="$directory/$newname.$extension"
	mv "$path" "$newpath"
	
	# Display what percentage is completed
	if (($arrlength >= 50)); then
		if [ $i -ge $(($arrlength * ($percentage+10) / 100)) ]; then
			percentage=$(($percentage+10))
			echo "$percentage% completed..."
		fi
	fi
done

echo "Renaming completed!"