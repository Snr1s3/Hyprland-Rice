{ config, pkgs, ... }:

{
  # ============================================================================
  # Home Manager
  # ============================================================================

  home = {
    username = "alba";
    homeDirectory = "/home/alba";
    stateVersion = "26.05";
  };

  # ============================================================================
  # GTK / Appearance
  # ============================================================================
gtk = {
  enable = true;

  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };

  iconTheme = {
    name = "Papirus";
    package = pkgs.papirus-icon-theme;
  };

  cursorTheme = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
};
dconf.settings = {
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

};

  # ============================================================================
  # Bash
  # ============================================================================

  programs.bash = {
    enable = true;

    shellAliases = {
      bondia = "echo Bon Dia Alba";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };

    initExtra = ''
      __git_branch() {
        local branch
        branch=$(git branch --show-current 2>/dev/null)

        [[ -n "$branch" ]] && printf " (%s)" "$branch"
      }

      shopt -s promptvars

      PS1='\[\e[38;5;165m\](\[\e[38;5;212m\]\A\[\e[38;5;165m\])-(\[\e[38;5;165m\]\h\[\e[38;5;165m\])-(\[\e[38;5;212m\]\W\[\e[38;5;165m\])$(__git_branch)\[\e[38;5;165m\]:\[\e[0m\] '
    '';
  };
}
