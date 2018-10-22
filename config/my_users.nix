{ pkgs }:

with pkgs;
let
in
{
  adfaure = {
    isNormalUser = true;
    home = "/home/adfaure";
    shell = pkgs.zsh;
    extraGroups = [ "audio" "wheel" "networkmanager" "vboxusers" "lp" ];
    openssh.authorizedKeys.keys = [
        (lib.readFile ../deployments/keys/mael.pub)
        (lib.readFile ../deployments/keys/id_rsa.pub)
    ];
    hashedPassword = "$6$1povfYo8YR1SMM$lzpE2aBCGZyNFCE7Nr2pizFyLb4O7jB6IJdvuoGHVziBg2ynRjtz/8hemZPFiYX.9AGbyDoXMGoH6.P6SvQPx/";
    uid = 1000;
  };

}
