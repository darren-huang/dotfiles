input='tracked_files.txt'
while read line; do
    mkdir -p ./old_home_dotfiles
    cp "$HOME/$line" ./old_home_dotfiles
    cp "./$line" ~/
done < $input
