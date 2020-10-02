input='tracked_files.txt'
while read line; do
    cp "$HOME/$line" ./
done < $input
