# .bashrc

export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
#HISTORY
export HISTFILESIZE=500000000
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'; PS1='\[\e[38;5;165m\](\[\e[38;5;212m\]\A\[\e[38;5;165m\])-(\[\e[38;5;212m\]\h\[\e[38;5;165m\])-(\[\e[38;5;212m\]\W\[\e[38;5;165m\])-(\[\e[38;5;212m\]${PS1_CMD1}\[\e[38;5;165m\]):\[\e[0m\]'
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

#ALIAS
alias s='source ~/.bashrc'
alias c='clear'
alias updt='sudo dnf update -y'
