userid=`id -g`
if [[ $userid == 0 ]]; then
	usercolor="34m"
else
	usercolor="36m"
fi

# Exit and cd into last dir you were on ranger; exit with Q
function ranger {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )

    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

export -f ranger

alias ls='ls --color=always --group-directories-first'
alias ll='ls --color=always --group-directories-first -lgh'
alias llfn='ls --color=always -1'
alias la='ls --color=always --group-directories-first -a'
alias lla='ls --color=always --group-directories-first -la'
alias laa='ls --color=always --group-directories-first -d .?*'
alias llaa='ls --color=always --group-directories-first -ld .?*'
alias lg="ls --color=always -lagh --git"
alias tree="tree -C"

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[\e[32m\][\[\e[m\]\[\e[${usercolor}\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32;48m\]\[\e[33m\]\$(parse_git_branch)\[\e[32;48m\]$\[\e[m\] "

export TERM=xterm-256color

HISTSIZE=100000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignorespace
