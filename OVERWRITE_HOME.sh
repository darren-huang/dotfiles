input='tracked_files.txt'
while read line; do
    mkdir -p ./old_home_dotfiles
    echo "./"$(echo "$line")
    rsync -av "$HOME/"$(echo "$line") ./old_home_dotfiles
    rsync -av "./"$(echo "$line") ~/
done < $input
