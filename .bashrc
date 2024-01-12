#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip -c'
alias shutdown='shutdown now'
alias vim='nvim'
PS1='[\u@\h \W]\$ '

# Adding Folders to PATH
export PATH="$HOME/.exec:$PATH"

# Starship shell setup
eval "$(starship init bash)"
