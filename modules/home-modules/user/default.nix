{...}: {
  flake = {
    homeModules.user = {...}: {
      home = rec {
        username = "adfaure";
        homeDirectory = "/home/${username}";
        stateVersion = "20.09";
      };
    };
  };
}
