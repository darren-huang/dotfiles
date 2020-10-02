input='tracked_files.txt'
while read line; do
    cp "./$line" ~/
done < $input
