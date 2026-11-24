{ ... }:

{
  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
  };

  programs.dconf.enable = true;
}