# ~/.bashrc
# vim: filetype=sh :

# Load the original .bashrc if it exists:
[[ -f ~/.bashrc-orig ]] && source  ~/.bashrc-orig

# Attention vim users:  un-comment this when you want to switch
# the readline key map to `vi` mode instead of the default (emacs --> hiss...!)
# set -o vi

umask 0022  # Turn off write permissions for group+others when creating new files
set -o ignoreeof  # Don't close the shell if we accidentally hit Ctrl+D

# The "Locale" deals with language internationalization. Best to get that set
# explicitly:
# export LC_ALL=en_US.UTF-8
# export LANG=en_US.UTF-8
# export LANGUAGE=en_US.UTF-8

# Don't put duplicate command-lines in the history, and if a command-lines
# starts with space, don't add it to history:
HISTCONTROL=ignoredups:ignorespace

# Timestamp format for command history:
HISTTIMEFORMAT="%F %T "

# Append to the history file on exit: don't overwrite it:
shopt -s histappend

# When retrieving commands from history, load them into the edit buffer
# so the user can review/modify before execution:
shopt -s histverify

# How much command history should we keep?  This is mostly about
# ones' tolerance for watching-the-text-scroll if the 'history' command
# is entered on a sluggish terminal, vs. the desire to find very-old
# command lines.  It's not really about disk space or memory consumption.
HISTSIZE=1000


# Assuming 'dircolors' is available, define an alias for 'ls' which colorizes
# directory listings:
which dircolors &>/dev/null && { eval $(dircolors); alias ls='ls --color=auto'; }

# Check the window size after each command and update the values of lines
# and COLUMNS:
shopt -s checkwinsize

# Shell "aliases" are a simple first-word-substitution mechanism which save
# typing and wear-and-tear on the user's mental recall:
alias ll='ls --color=auto -l'   # The -l is "long format" in file listings
alias lr='ls --color=auto -lrt' # Sort by reverse timestamp, long format

# You can change to parent director(ies) with "cd ../../..", but typing
# all of those dots is exactly the sort of meaningless work that you hate:
alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'

# You can set the terminal title (on the title bar) with this command, which
# is handy if you have many terminals open, e.g. for one terminal you might
# add the title "Code editing" and another might be "Compile + Test".
function title {
    printf '\E]2;%s\E\\' "$*"
}

# Enable command completion (i.e. with the TAB key) for bash commands:
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# Disable flow control for the terminal.  Back in the day, Ctrl-S and Ctrl-Q
# were used to start and stop long-running streams of text from applications,
# but the need for that has been gone for years:
stty -ixon -ixoff

# Magic space expands !! and !-{n} when you hit spacebar after.  You can also do
# {cmd-frag}!<space> to expand the last command that started with that frag.
bind Space:magic-space

function parse_git_branch() {
    # Parse the current git branch name and print it
    which git &>/dev/null || return
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    [[ -n $branch ]] && echo " [${branch}]"
}

function set_PS1 {
    # The built-in PS1 variable defines the format of the user's shell
    # prompt. This version displays:
    #   - date/time (\D{})
    #   - current directory (\w)
    #   - current git branch (parse_git_branch)
    #   - user name (\u)
    #   - host machine (\h)
    # See also: `man bash`.
    PS1='
\[\e[1;33m\]\D{%b-%d %H:%M:%S}\[\e[0m\] \[\e[1;35m\]\w\[\e[0m\]$(parse_git_branch)
\[\e[1;36m\][\u.\h]\[\e[0m\]$Ps1Tail> '
}

set_PS1  # Set the prompt to something more useful than the default

export VISUAL=vim
export EDITOR="$VISUAL"
set -o vi 

alias tmux='tmux -2'
alias tmuxn='tmux new-session -s $$'
_trap_exit() { tmux kill-session -t $$; }
trap _trap_exit EXIT

if [[ -z "$TMUX" ]]
then
    tmuxn
fi


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

# nvm stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Node items
alias tscwatch="tsc -w -p ."

# pyenv stuff
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"