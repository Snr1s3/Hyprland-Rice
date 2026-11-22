{ ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.tumbler.enable = true;

  programs.dconf.enable = true;
  services.dbus.enable = true;
}
