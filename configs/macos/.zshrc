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
