{
    programs.bash = {
        enable = true;
        shellAliases = {
            ll = "ls -lah";
            c = "clear";
        };
        initExtra = ''
            PS1='\[\e[38;5;165m\](\[\e[38;5;212m\]\A\[\e[38;5;165m\])-(\[\e[38;5;212m\]\h\[\e[38;5;165m\])-(\[\e[38;5;212m\]\W\[\e[38;5;165m\])-(\[\e[38;5;212m\]\$(git branch --show-current 2>/dev/null)\[\e[38;5;165m\]):\[\e[0m\]'
        '';
    };
}