input='tracked_files.txt'
while read line; do
    echo "$HOME/"$(echo "$line")
    rsync -av --relative "$HOME/./"$(echo "$line") ./
done < $input
