# ~/.zshrc

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
setopt PROMPT_SUBST
autoload -U colors && colors

PS1_0=$'\n'
PS1_1=$'%{\e[1;33m%}%D{%b-%d %H:%M:%S}%{\e[0m%} %{\e[1;35m%}%d%{\e[0m%}$(parse_git_branch)\n'
PS1_2=$'%{\e[1;36m%}[%n.%m]%{\e[0m%}'
base_PS1=$PS1_0$PS1_1$PS1_2
tail_PS1=' %% '
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
bindkey '^R' history-incremental-search-backward
