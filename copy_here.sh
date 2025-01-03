# validate arguments
if [[ $# -ne 1 || ( "$1" != "macos" && "$1" != "windows" ) ]]; then
    echo "usage:"
    echo "copy_here.sh [windows|macos]"
    exit 1
fi;

# define vars
cwd=$(pwd)
shared_dir="${cwd}/configs/shared"
windows_dir="${cwd}/configs/windows"
macos_dir="${cwd}/configs/macos"

process_dir() {
    target_dir=$1
    configs_txt="${target_dir}/load_order.txt"
    cd $target_dir

    while read config; do
        echo "${HOME}/${config}"
        rsync -av --relative --no-implied-dirs "${HOME}/./${config}" ./
        echo "\n\n"
    done < $configs_txt
}

process_dir "$shared_dir"
if [[ "$1" == "windows" ]]; then process_dir "$windows_dir"; fi;
if [[ "$1" == "macos" ]]; then process_dir "$macos_dir"; fi;


