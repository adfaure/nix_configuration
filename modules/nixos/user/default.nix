{...}: {pkgs, ...}: {
  users.users.adfaure = {
    isNormalUser = true;
    home = "/home/adfaure";
    shell = pkgs.zsh;

    extraGroups = [
      "audio"
      "wheel"
      "networkmanager"
      "vboxusers"
      "lp"
      "perf_users"
      "docker"
      "users"
    ];

    nix.settings.trusted-users = ["root" "adfaure"];

    initialPassword = "nixos";
    uid = 1000;
  };
}
