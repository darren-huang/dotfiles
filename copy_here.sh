input='tracked_files.txt'
while read line; do
    echo "$HOME/"$(echo "$line")
    rsync -rv "$HOME/"$(echo "$line") ./
done < $input
