# ~/.zshrc

# add brew to the path
export PATH=/opt/homebrew/bin:$PATH

# You can change to parent director(ies) with "cd ../../..", but typing
# all of those dots is exactly the sort of meaningless work that you hate:
alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'

# visual settings
export VISUAL=vim
export EDITOR="$VISUAL"
set -o vi 

# tmux aliases and functions
alias tmux='tmux -2'
alias tmuxn='tmux new-session -s $$'
_trap_exit() { tmux kill-session -t $$; }
trap _trap_exit EXIT

# run tmux if not running already
if [[ -z "$TMUX" ]]
then
    tmuxn
fi

# trash command (softer than rm)
trash() {
    mv $1 ~/trash 
}

export PATH=~/.local/bin:$PATH
alias dc=docker-compose

# Load machine specific bashrc
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

# colors stuff
export TERM=xterm-256color
export CLICOLOR=1
alias ls="ls -G"

# git stuff
alias gitlgu="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitlg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Creset' --abbrev-commit"

# vscode annoyance
alias sshserver="sudo service ssh start"

alias chownme="sudo chown -R $(whoami) .*"

# get latest log
function latestlog() {
    if [ "$#" -eq 1 ]; then
        echo "$1""/$(ls -At $1 | head -n 1)"
    else
        echo "$(ls -At $@ | head -n 1)"
    fi
}

function kubeconfigdev() {
    mv ~/.kube/config ~/.kube/config.old
    cp ~/.kube/config.dev ~/.kube/config
}

function kubeconfigbuild() {
    mv ~/.kube/config ~/.kube/config.old
    cp ~/.kube/config.build ~/.kube/config
}

alias sourcevenv="source .venv/bin/activate"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dhuang5/Install/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dhuang5/Install/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dhuang5/Install/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dhuang5/Install/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# PS1 - modifies the prompt
function parse_git_branch() {
    # Parse the current git branch name and print it
    which git &>/dev/null || return
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    [[ -n $branch ]] && echo " [${branch}]"
}
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}
function get_cpu_arch {
    ([[ "$(arch)" = 'arm64' ]] && echo "") || \
        ([[ "$(arch)" = 'i386' ]] && echo "<intel> ")
}
setopt PROMPT_SUBST
autoload -U colors && colors

PS1_0=$'\n'
PS1_1=$'%{\e[1;33m%}%D{%b-%d %H:%M:%S}%{\e[0m%} %{\e[1;35m%}%d%{\e[0m%}$(parse_git_branch)\n'
PS1_2=$'%{\e[1;36m%}[%n.%m]%{\e[0m%}'
base_PS1=$PS1_0$PS1_1$PS1_2
tail_PS1=' $(virtualenv_info)$(get_cpu_arch)%% '
VIM_CMD_PROMPT="%{$fg_bold[red]%}[% cmd]% %{$reset_color%}"
VIM_INS_PROMPT="%{$fg_bold[green]%}[% ins]% %{$reset_color%}"

# PS1 insert command or insert mode
function repeat_char {
    local input="$1"
    local count="$2"
    printf -v myString '%*s' "$count"
    printf '%s\n' "${myString// /$input}"
}
function count_prompt_len {
    local zero='%([BSUbfksu]|([FK]|){*})'
    echo ${#${(S%%)1//$~zero/}}
}
function zle-line-init zle-keymap-select {
    CMD_OR_INS="${${KEYMAP/vicmd/$VIM_CMD_PROMPT}/(main|viins)/$VIM_INS_PROMPT}"
    PS1=${base_PS1}${CMD_OR_INS}${tail_PS1}
    ps1_2_spaced=$(repeat_char " " $(count_prompt_len $PS1_2))
    PS2="$ps1_2_spaced     $tail_PS1"
    RPS1=""
    RPS2=""
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Reverse command search
bindkey -v
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
stty -ixon

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# snap access alias
alias awsnap="snapaccess credentials refresh"
alias ausnap="snapaccess credentials refresh"

# code folder locations
alias cdsnap="cd ~/src/snap/snapchat"
alias cdflow="cd ~/src/snap/flowrida"
alias cdflow2="cd ~/src/snap/flowrida/v2"
alias cdpia="cd ~/src/snap/snapchat/targeting/identitygraph/src/main/python/analysis/pixel-ip-agg-model"
alias cdtiam="cd ~/src/snap/snapchat/applications/tiam_ml"

# fix command line vi-editing mode backspace
bindkey -v '^?' backward-delete-char

# alias to set architecture
alias intel="env /usr/bin/arch -x86_64 /bin/zsh --login"
alias arm="env /usr/bin/arch -arm64 /bin/zsh --login"
alias brew86='/usr/local/bin/brew'

# alias for ssh stuffs
alias rsynctiam="rsync -az -e 'ssh -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' /Users/dhuang5/src/snap/snapchat/applications/tiam_ml/ dhuang5@estimated-conversions-dev.sc-targeting-measurement.snapint:src/tiam_ml"
alias sshec="ssh estimated-conversions-dev.sc-targeting-measurement.snapint"

# function for running a command and tee-ing the output to a file
function runlog() {
    # usage notif
    function usage_notif() {
        echo "USAGE:"
        echo "runlog [-f filename (no ext)] script arg1 arg2 arg3 ..."
        echo "default filename is 'script'.txt"
    }

    # setup variables
    local OPTIND f filename logs_dir pos_args; OPTIND=1
    pos_args=()

    # setup logs directory
    logs_dir="${HOME}/terminal_logs/runlog"
    mkdir -p $logs_dir

    # process flags
    while [ $OPTIND -le "$#" ]; do
    if getopts "hf:" option; then
        case $option in
            f) filename="$OPTARG";;
            *) usage_notif; return 1;;
        esac
    else
        pos_args+=("${@[OPTIND]}")
        ((OPTIND++))
    fi
    done

    # check num of pos_args
    if [[ ${#pos_args} -eq 0 ]]; then usage_notif; return 1; fi

    # notify user
    if [[ ! $filename ]]; then filename=${pos_args[1]}; fi
    date_suffix="$(date +"%Y-%m-%d_%H%M%S")"
    logfile="${logs_dir}/${filename}_${date_suffix}.txt"
    echo "running command:  ${pos_args[@]}"
    echo "saving output to: ${logfile}"

    # run command & log to file
    echo ">>>runlog start" >> $logfile
    echo "# command: $@" >> $logfile
    echo "# output:" >> $logfile
    set -o pipefail # if any fail, pipeline fails
    ${pos_args[@]} 2>&1 | tee -a $logfile
    set +o pipefail # pipeline fails with rightmost
    echo "<<<runlog end" >> $logfile
}

# save current pane to file
function savepane() {
        if [[ $# -ne 1 ]] ; then
                echo "USAGE:"
                echo "savepane [filename]"
                return 1
        fi
        tmux capture-pane -pS - >> "${HOME}/terminal_logs/tmux/${1}"
}


# set javahome
export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0_181`

# set PATH
export PATH=$PATH:/Users/dhuang5/bin
