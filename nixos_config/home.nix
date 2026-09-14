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
      edit_config = "sudo vim /etc/nixos/configuration.nix";
      scan_apps = "update-desktop-database ~/.local/share/applications";
    };

    initExtra = ''
      __git_branch() {
        local branch
        branch=$(git branch --show-current 2>/dev/null)

        [[ -n "$branch" ]] && printf " (%s)" "$branch"
      }

      shopt -s promptvars

      PS1='\[\e[38;2;235;203;139m\](\[\e[38;2;136;192;208m\]\A\[\e[38;2;235;203;139m\])-(\[\e[38;2;129;161;193m\]\h\[\e[38;2;235;203;139m\])-(\[\e[38;2;94;129;172m\]\W\[\e[38;2;235;203;139m\])$(\_\_git\_branch)\[\e[38;2;235;203;139m\]:\[\e[0m\] '
    '';
  };
}
