# validate arguments
if [[ $# -ne 1 || ( "$1" != "macos" && "$1" != "windows" ) ]]; then
    echo "usage:"
    echo "OVERWRITE_HOME.sh [windows|macos]"
    return 1
fi;

# define vars
cwd=$(pwd)
shared_dir=$cwd"/configs/shared"
windows_dir=$cwd"/configs/windows"
macos_dir=$cwd"/configs/macos"

process_dir() {
    target_dir=$1
    configs_txt=$target_dir"/load_order.txt"
    cd $target_dir

    while read config; do
        mkdir -p ./old_home_dotfiles
        echo "./"$(echo "$config")
        rsync -av "$HOME/"$(echo "$config") ./old_home_dotfiles
        rsync -avR --relative $(echo "$config") ~/
        echo "\n\n"
    done < $configs_txt
}

process_dir "$shared_dir"
if [[ "$1" == "windows" ]]; then process_dir "$windows_dir"; fi;
if [[ "$1" == "macos" ]]; then process_dir "$macos_dir"; fi;