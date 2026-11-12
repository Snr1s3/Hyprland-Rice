{ userName, ... }:

{
  users.users.${userName} = {
    isNormalUser = true;
    description = "Alba";
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
    ];
  };
}
