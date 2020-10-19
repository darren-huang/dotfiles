input='tracked_files.txt'
while read line; do
    mkdir -p ./old_home_dotfiles
    echo "./"$(echo "$line")
    rsync -rv "$HOME/"$(echo "$line") ./old_home_dotfiles
    rsync -rv "./"$(echo "$line") ~/
done < $input
