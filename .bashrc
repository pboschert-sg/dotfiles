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

# add ~/bin to the path
PATH=$PATH:$HOME/bin

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

case "$(uname -s)" in
    Linux*)  mach_type="nix";;
    Darwin*) mach_type="mac";;
    CYGWIN*) mach_type="win";;
    MINGW*)  mach_type="win";;
    *)       mach_type="nix";;  # assume *nix
esac

# Create and use the vi alias only if we're in screen
viAlias() {
    echo -en "\033k${1}\033\\" && vi ${1}
}
if [[ "$TERM" == *"screen"* ]]; then
    alias vi=viAlias
fi

# some more ls aliases
alias ls='ls -F'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias tailf='tail -f'

# human readable format for df/du
alias df='df -h'
alias du='du -h'

color_prompt=false
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with ECMA-48 (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=true
fi

if $color_prompt; then
    # set a colorful prompt
    PS1="\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;32m\]\h\[\033[01;34m\] \w $\[\033[00m\] "

    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

        alias ls='ls --color=auto -F'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
fi
unset color_prompt

# enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [[ "$mach_type" == "nix" ]]; then
    # disable M$ telemetry collection
    DOTNET_CLI_TELEMETRY_OPTOUT=1

    # Add dotnet tools if the directory exists
    [ -d $HOME/.dotnet/tools ] && PATH=$PATH:$HOME/.dotnet/tools
fi

# run fortune if it exists
if [ $(type -P "fortune") ]; then
    fortune
fi

# SRWare Iron
[ -d /usr/share/iron ] && PATH="$PATH:/usr/share/iron"

if [ $(type -P "rbenv") ]; then
    PATH="$PATH:$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin"
    eval "$(rbenv init -)"
fi

# make gnuplot readline not suck
if [ $(type -P "gnuplot") ]; then
    alias gnuplot='rlwrap -a -c gnuplot'
fi

# OPAM configuration
if [ -x $HOME/.opam/opam-init/init.sh ]; then
. $HOME/.opam/opam-init/init.sh > /dev/null 2>&1 || true
fi

# Adding Scala SBT bin to path
[ -d /opt/sbt/bin ] && PATH="/opt/sbt/bin:$PATH"

# Golang
if [ -d /usr/local/go/bin ]; then
    GOPATH="$HOME/gopath"
    PATH=$GOPATH:$GOPATH/bin:$PATH
    PATH=$PATH:/usr/local/go/bin
fi

