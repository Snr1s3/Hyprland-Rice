{ ... }:

{
  users.users.alba = {
    isNormalUser = true;
    description = "Alba";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
