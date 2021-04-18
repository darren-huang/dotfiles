input='tracked_files.txt'
while read line; do
    mkdir -p ./old_home_dotfiles
    echo "./"$(echo "$line")
    rsync -av "$HOME/"$(echo "$line") ./old_home_dotfiles
    rsync -avR --relative $(echo "$line") ~/
done < $input
