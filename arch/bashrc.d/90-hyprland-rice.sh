alias bondia='echo Bon Dia Alba'
alias rebuild='sudo pacman -Syu'
alias edit_config='${EDITOR:-nano} "$HOME/github/Hyprland-Rice/README.md"'
alias scan_apps='update-desktop-database "$HOME/.local/share/applications"'

__git_branch() {
  local branch
  branch=$(git branch --show-current 2>/dev/null)
  [[ -n "$branch" ]] && printf ' (%s)' "$branch"
}

shopt -s promptvars
PS1='\[\e[38;2;235;203;139m\](\[\e[38;2;136;192;208m\]\A\[\e[38;2;235;203;139m\])-(\[\e[38;2;129;161;193m\]\h\[\e[38;2;235;203;139m\])-(\[\e[38;2;94;129;172m\]\W\[\e[38;2;235;203;139m\])$(__git_branch)\[\e[38;2;235;203;139m\]:\[\e[0m\] '