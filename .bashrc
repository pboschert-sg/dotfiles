# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history and ignore spaces
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=20000
HISTSIZE=20000
HISTTIMEFORMAT="[%F %T] "
HISTFILE="$HOME/.bash_history_other"
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# minimize and include condition constrained path information
if [ $(type -P "long-pwd-prompt-command") ]; then
    PROMPT_COMMAND="source long-pwd-prompt-command; $PROMPT_COMMAND"
fi

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -Fh --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Create and use the vi alias only if we're in screen
viAlias() {
    echo -en "\033k${1}\033\\" && vi ${1}
}
if [[ "$TERM" == *"screen"* ]]; then
    alias vi=viAlias
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias tailf='tail -f'

# human readable format for df/du
alias df='df -h'
alias du='du -h'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# add ~/bin to the path
PATH=$PATH:$HOME/bin

fortune

# dotnet
DOTNET_CLI_TELEMETRY_OPTOUT=1
# Add dotnet tools if the directory exists

[ -d $HOME/.dotnet/tools ] && PATH=$PATH:$HOME/.dotnet/tools
