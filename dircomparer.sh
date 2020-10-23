#!/usr/bin/bash

project_dir=$1
web_dir=$2

escaped_pd=$(echo -n "$project_dir" | sed "s/\//\\\\\//g")
escaped_wd=$(echo -n "$web_dir" | sed "s/\//\\\\\//g") 

for item in `find $project_dir`
do
	echo "[*] Comparing $item"
	filename=$(echo -n "$item" | sed "s/$escaped_pd//g")
	
	if [[ -d $item ]];
	then
		continue
	fi

	if [[ ! -f $web_dir/$filename ]];
	then
		echo "[!] $item does not exist in $web_dir"
		continue
	fi

	project_hash=$(md5sum "$project_dir/$filename" | awk '{ print $1 }')
	web_hash=$(md5sum "$web_dir/$filename" | awk '{ print $1 }')

	if [ $project_hash != $web_hash ]
	then
		echo "[!] $item hashes not equal!: $project_hash / $web_hash"
		echo "[*] Running diff:"
		diff "$project_dir/$filename" "$web_dir/$filename"
	fi
done


