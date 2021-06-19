{ config, pkgs, options, modulesPath, lib, utillinuxMinimal, specialArgs }: {
  # Module that automatically enable cadvisor and feed the data into influxdb database.
  # Note that the influxdb database needs to be created by hand (cadvisor doesn't do it).
  # Grafana is also enabled, and need to be configured within the web interface at localhost:3000:
  time.timeZone = "Europe/Paris";
  services.cadvisor = {
    enable = true;
    listenAddress = "${config.networking.hostName}";
    storageDriver = "influxdb";
    storageDriverHost = "${config.networking.hostName}:8086";
    storageDriverDb = "cadvisor";
    extraOptions = [
      # https://github.com/google/cadvisor/blob/master/docs/runtime_options.md
      "--allow_dynamic_housekeeping=false"
      # "--global_housekeeping_interval=10s"
      # "--housekeeping_interval=5s"
      # "--max_housekeeping_interval=5s"
    ];
  };

  services.influxdb = {
    enable = true;
  };

  services.grafana = {
    enable = true;
  };

  security.polkit = {
    enable = true;
    adminIdentities = [
      "unix-group:wheel"
    ];
    extraConfig = ''
      /* Allow users in group whell without password. */
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) return "yes";
      });
      '';
  };
}