input='tracked_files.txt'
while read line; do
    echo "$HOME/"$(echo "$line")
    rsync -av "$HOME/"$(echo "$line") ./
done < $input
